//SPDX-License-Identifier: GPL-3.0
/// @title BSM Engineering - Actividad 2 Lección 6. 
/// @Author QDJ
/// @dev Versión 1.0

pragma solidity ^0.8;
/// Actividad 2: Actualiza la actividad 1. Requiere implementar:
/// REQ1: Debe existir un contracto (Owned) que gestione quien es el administrador
///       y defina un modificador que controle si el usuario actual es administrador.
/// REQ2: El contrato principal debe heredar del contrato Owned.
/// REQ3: Adaptar condiciones IF por REQUIRE o ASSERT si incumple condición.
/// REQ4: Verificar que no se puede añadir el mensaje ofensivo "tonto quien lo lea".
/// REQ5: Crear y eliminar un mensaje debe generar un evento en la blockchain.
/// REQ6: El contrato debe poder destruirse y recuperar los fondos (solo administrador).

contract Owned {   // (REQ1)
    address payable _admin;
        
    constructor ()  {
    /// @dev: El constructor del contrato define su administrador con capacidad de recuperar el
    ///       el balance si decide destruirlo.
        _admin = payable(msg.sender); // Address que almacena la dirección del Administrador. (REQ1)
    }
   /// Modificador que asegura que la función sólo se ejecuta si el actual usuario es el administrador.
   /// (REQ1)
    modifier soloAdmin() {
        require(msg.sender == _admin);
        _;
    }
}

contract Messagebox is Owned { // (REQ2)
/// @dev Gestión de una lista de mensajes realizados por los usuarios del contrato.
    string[] private mensajes; // Array tipo string que almacenará la lista de mensajes.
    mapping(address => uint) userTotalMensajes; // mapeo de cuantos mensajes ha realizado cada usuario.
    uint pago = 0.001 ether; // Cantidad a pagar por cada mensaje después del primero gratuito.
    //// @dev  Se ha decido almacenar las fechas de cada mensaje en un array en dónde la posición
    ///        de cada fecha se corresponde con la posición de su corrspondiente mensaje en la lista.
    uint[] private fechaUnixUltimoMensaje; // Array de fechas de cada mensaje añadido a la lista.
    string constant MSG_OFENSIVO = "tonto quien lo lea";
    event NuevoMensaje(string nuevoMensaje); // Evento generado al crear un nuevo mensaje. (REQ5)
    event MensajeBorrado(string mensaje); // Evento generado al eliminar un mensaje. (REQ5)
    // Modificador que controla que no se introduzca un string ofensivo (REQ4)
    // Lo usaremos para evitar el definido en MSG_OFENSIVO en la función addMessage.
    modifier testMensajeOfensivo(string memory _nuevoMensaje, string memory _testMensaje) {
        require(keccak256(bytes(_nuevoMensaje)) != keccak256(bytes(_testMensaje)),"Mensaje ofensivo!");
        _;
    }
    /*
    @Dev: Para añadir un mensaje:
    a) Comprobamos si es el primero (gratuito) o sino cargamos coste de 0.001 Ether.
       Si no se envia mínimo 0.001 eth para el resto de mensajes la función dará error. 
       Si s'envia más ETH de la cantidad estipulada en la variable 'pago', se devuelve 
       la diferencia al usuario.  
    b) Registramos el mensaje a la lista. 
    c) Registramos su fecha. 
    d) Para ese usuario contabilizamos el número de mensajes realizados.
    */
    function addMessage(string memory _nuevoMensaje) public payable testMensajeOfensivo(
        _nuevoMensaje, MSG_OFENSIVO) {  // (REQ4)  
        if(userTotalMensajes[msg.sender] > 0){
            require(msg.value-pago >= 0); //  (REQ3)
            if (msg.value > pago) { 
                payable(msg.sender).transfer(msg.value-pago); 
            }
        }
        mensajes.push(_nuevoMensaje);
        fechaUnixUltimoMensaje.push(block.timestamp);
        userTotalMensajes[msg.sender]++;
        emit NuevoMensaje(_nuevoMensaje); // (REQ5)   
    }
    /// El contrato permite consultar un mensaje de la lista indicando su posición. 
    /// La inicial es la posición 0.  
    function getMessage(uint _idMensaje) public view returns (string memory) {
        require(_idMensaje >= 0 && _idMensaje < mensajes.length,"Lista vacia o Indice fuera de rango.");
        return mensajes[_idMensaje];
    }
    /// El contrato permite consultar todos los mensajes de la lista.
    function mostraMensajes() public view returns (string[] memory) {
        return mensajes;
    }
    /// El contrato permite consultar externamente la fecha del último mensaje añadido.
    function mostrarFechaUltimoMensaje() external view returns (uint) {
        if (fechaUnixUltimoMensaje.length > 0) {
            return fechaUnixUltimoMensaje[fechaUnixUltimoMensaje.length-1];
        } else {
            return 0;
        }
    }
    /// El contrato permite que su creador pueda eliminar mensajes indicando la posición
    /// del mensaje en la lista, considerando la primera posición 0.
    /// Para eliminar un mensaje se desplazan todos los mensajes posteriores a una posición
    ///  anterior y se tiene en cuenta:
    /// a) La posición indicada, sea menor al número de mensajes en la lista.
    /// b) Cuando se elimina el último mensaje, hace falta actualizar:
    ///    b.1) La fecha del último mensaje de la lista.
    ///    b.2) Restar el contador de mensajes de ese usuario.
    /// c) Si se elimina un mensaje hace falta restar el contador de mensajes de ese usuario.
    function borrarMensaje(uint _idMensaje) public soloAdmin() {  // (REQ1)
        require(_idMensaje >= 0 && _idMensaje < mensajes.length,
                 "Lista vacia o Indice fuera de rango.");  // (REQ3)
        for(uint i=_idMensaje; i<mensajes.length-1; i++) {
            mensajes[i] = mensajes[i+1];
            fechaUnixUltimoMensaje[i] = fechaUnixUltimoMensaje[i+1];
        }
        string memory msgb = mensajes[_idMensaje];
        mensajes.pop();
        fechaUnixUltimoMensaje.pop();
        userTotalMensajes[msg.sender]--;
        emit MensajeBorrado(msgb); // (REQ5)
    }

    /// Función que permite poder destruir el contrato y devolver su balance al administrador.
    function EliminaContrato() external soloAdmin() { 
        selfdestruct(_admin); // (REQ6)
    }
}
