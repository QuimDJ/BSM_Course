// SPDX-License-Identifier: GPL-3.0
// @title BSM Engineering - Actividad Lección 8
// @Author: QDJ
// @dev Versión 2.0

pragma solidity < 0.9;

contract Loteria {
/*
@dev:  
En la versión 1:
    Implementación de un Sistema de Loteria en blockchain pública en
    Testnet Sopelia. Cada usuario participa con una más participaciones 
    de 0.01 ether. Cualquiera puede consultar el bote acumulado. Se 
    selecciona el ganador de manera pseudo-aleatoria.
En la versión 2, que conforma la Actividad 3:
    Se utilizará block.prevrandao junto con otras características para
    obtener un numero pseudo-aleatorio que decida la selección del ganador.balance
    A diferencia de la versión 1, aquí:
    - No existe un administrador del contrato.
    - La loteria dura 5 min desde la creación del contrato.
    - Cada usuario puede realizar varias participaciones en una sola transacción.
    - Existirá un contrato 'Padre' que genere nuevos contratos de Lotería individuales. 
*/
    // Variables de Estado.
    enum Estado {Activo, Finalizado} // Estados posibles de la loteria.
    Estado public estado; // Variable que define en que estado se encuentra la loteria. 
    address payable[] private participantes; // array que almacena las direcciones de los
                                             // participantes.
    address payable public ganador; // Variable que registra la dirección del ganador.
    uint precioLoteria = 0.01 ether; // Variable que indica el coste de una participación.
    uint private creadoContrato; // Marca de tiempo del momento de la creación del contrato.
    uint private constant periodoSegLoteria = 300 seconds; // Duración de la loteria.
    uint private seleccionado; // Variable que registra el indice del array de participantes
                               // que resulta ganador de la loteria.
    uint private nrand; // Número pseudo-aleatorio que determina mayormente al ganador.
    event EstadoLoteria(Estado); // Evento que se genera cuando se Activa o Finaliza la loteria.
    event PremioOtorgado(address payable, uint); // Evento que indica quien es el ganador y
                                                 // el premio que recibe.
    constructor() payable {
        estado = Estado.Activo;             // Al crearse el contrato se marca como Activo su
        emit EstadoLoteria(estado);         // estado y se lanza el evento y se registra el
        creadoContrato = block.timestamp;   // momento en que se puede participar en la loteria.
    }
    // receive permite recibir ether y participar en la loteria
    receive() external payable {
        uint n = msg.value / 0.01 ether;
        creaParticipaciones(n);
    }
    // fallback permite también recibir ether y participar
    fallback() external payable {
        uint n = msg.value / 0.01 ether;
        creaParticipaciones(n);
    }
    // Generación del número pseudo aleatório.
    function random() internal returns (uint) {
        nrand = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participantes.length, block.gaslimit)));
        return nrand;
    }
    // Selección del ganador mediante el operador módulo adaptado al número de participantes.
    // Para obtener un ganador la loteria debe estar activa y una vez seleccionado se finaliza.
    function obtenerGanador() internal {
        require(estado == Estado.Activo,"Loteria finalizada.");
        if (participantes.length > 0) {
            seleccionado = random() % participantes.length;
            ganador = participantes[seleccionado];
        }
        estado = Estado.Finalizado;
        emit EstadoLoteria(estado);
    }
    // Una vez se dispone del ganador se le transfiere el premio del bote acumulado.
    function enviarPremio() internal {
        uint premio = address(this).balance;
        ganador.transfer(premio);
        emit PremioOtorgado(ganador, premio);
    }
    // Podemos en cualquier momento consultar el bote acumulado.
    function obtenerBote() public view returns (uint) {
        return address(this).balance;
    }
    // Se puede consultar el coste/participación definido para la loteria.
    function precioParticiparLoteria() public view returns (uint) {
        return precioLoteria;
    }
    // Se puede consultar el nº actual de participantes en la loteria.
    function nParticipantes() public view returns (uint) {
        return participantes.length;
    }
    // Se puede consultar la lista de participantes.
    function listaParticipantes() public view returns (address payable[] memory) {
        return participantes;
    }
    // Se puede consultar un participante por orden de inscripción.
    function obtenerParticipante(uint _index) public view returns(address payable) {
        return participantes[_index];
    }
    // Se registrarán las participaciones ajustadas a los fondos enviados, siempre que la loteria
    // esté en estado 'Activo'. El tiempo máximo de duración de una loteria está establecido en 5 minutos.
    // Una vez transcurridos los 5 minutos cualquier participación será rechazada y se decidirá el ganador.
    // Si un participante pide un número de participaciones el excedente de fondos le será devuelto.
    function creaParticipaciones(uint numParticipaciones) public payable {
        require(msg.value > 0, "No se ha enviado ether para participar.");
        require(numParticipaciones > 0, "Numero participaciones incorrecto.");
        require(estado == Estado.Activo,"Loteria ya finalizada.");
        if ((creadoContrato + periodoSegLoteria) > block.timestamp) {
            require((msg.value / precioLoteria) >= numParticipaciones,"Coste por numero de participaciones incorrecto.");
            if ((msg.value / precioLoteria) > numParticipaciones) {
                payable(msg.sender).transfer(msg.value - (precioLoteria * numParticipaciones));
            }
            for(uint i = 0; i < numParticipaciones; i++){
                participantes.push(payable(msg.sender));
            }
        } else {
            obtenerGanador();
            enviarPremio();
        }
    }
    // Se ha considerado una función de transparencia que proporciona el número pseudo-aleatorio usado en la
    // loteria, el número de participantes y el índice resultante de aplicar el operador módulo.
    
    function transparencia() public view returns(uint _pseudoAleatorio, uint _participantes, uint _seleccionado) {
        require(estado == Estado.Finalizado, "Todavia no ha finalizado la Loteria");
        return (nrand, participantes.length, seleccionado);
    }
}

contract LoteriasFactory {
/*
@dev:  
En la Actividad 3 (T03-Lección 8):
    - Se requiere un contrato 'padre' que genere nuevos contratos de tipo Loteria.
    - Para ello se ha definido un contrato LoteriasFactory que las crea y organiza
      en un array de contratos Loteria. 
    - Se han implementado 4 maneras de crear dinámicamente un loteria:
        * Sin pasarle parámetros: crearLoteria.
        * Usando como parámetro una cantidad de fondos: crearLoteriaToken()
        * Usando como parámetro un numero como parámetro salt: crearLoteriaSalt(bytes32 _salt)
          _salt = 0x0698472c4668bddd0c694601ca101551bd7b5cfe6dc780ab37bccfc99ad22e4c
        * usando dos parámetros: uno para fondos y otro para salt: 
          crearLoteriaSaltToken(bytes32 _salt)
    - Se puede obterner la lista de loterias creadas: listaLoterias()
    - Se puede obtener una indicando su posición en la lista: obtenerLoteria(uint _index)
    - Se puede eliminar una loteria de la lista: eliminarLoteria(uint _index)
      Existe un evento que notifica cuando se elimina indicando su indice.  
    - Se puede consultar el número de Loterias creadas: numLoteriasCreadas()
*/
    // Variables de Estado.
    Loteria[] private loteriasCreadas;

    event LoteriaEliminada(uint); 

    function crearLoteria() public {
        Loteria loteria = new Loteria();
        loteriasCreadas.push(loteria);
    }

    function crearLoteriaToken() public payable {
        Loteria loteria = (new Loteria){value: msg.value}();
        loteriasCreadas.push(loteria);
    }

    function crearLoteriaSalt(bytes32 _salt) public {
        Loteria loteria = (new Loteria){salt: _salt}();
        loteriasCreadas.push(loteria);
    }

    function crearLoteriaSaltToken(bytes32 _salt) public payable {
        Loteria loteria = (new Loteria){value: msg.value, salt: _salt}();
        loteriasCreadas.push(loteria);
    }

    function obtenerLoteria(uint _index) public view returns (address loteriaDir, uint balance)
    {
        require(loteriasCreadas.length > 0, "Lista de Loterias vacia.");
        require(_index >= 0 && _index < loteriasCreadas.length,"Indice incorrecto.");
        Loteria loteria = loteriasCreadas[_index];
        return (address(loteria), address(loteria).balance);
    }

    function listaLoterias() public view returns (Loteria[] memory) {
        return loteriasCreadas;
    }

    function eliminarLoteria(uint _index) public {  
        require(loteriasCreadas.length > 0, "Lista vacia."); 
        require(_index >= 0 && _index < loteriasCreadas.length, "Indice fuera de rango."); 
        for(uint i=_index; i < loteriasCreadas.length-1; i++) {
            loteriasCreadas[i] = loteriasCreadas[i+1];
        }
        loteriasCreadas.pop();
        emit LoteriaEliminada(_index);
    }
    function numLoteriasCreadas() public view returns (uint) {
        return loteriasCreadas.length;
    }
}
