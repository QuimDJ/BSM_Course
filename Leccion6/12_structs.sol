// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4;

contract EjemploDynamicdArrays {
    
  struct Alumno {
      string nombre;
      string dni;
      Estado estado;
      uint8 edad;
  }
  enum Estado {Matriculado, Baja}
  
  Alumno[] public alumnos;
  Alumno public ultimoAlumno;
  
  function addAlumno(string memory _nombre, string memory _dni, uint8 _edad) public {
     // Alumno storage aux =  ultimoAlumno;
      ultimoAlumno = Alumno({nombre:_nombre, edad:_edad,dni:_dni,estado: Estado.Matriculado});
     // aux.nombre = "nuevo nombre";
      alumnos.push(ultimoAlumno);
     // aux.nombre = "nuevo nombre2";
    //Pregunta: si descomento anteriores líneas, qué nombre se asigna al alumno?
  }

  function getAlumno(uint index) public view returns (Alumno memory) {
      return alumnos[index];
  }
  function getAlumnosIndex2(uint index) public view returns (string memory name, uint8 edad, string memory dni, uint estado) {
        return (alumnos[index].nombre,alumnos[index].edad, alumnos[index].dni, uint(alumnos[index].estado));
  }
	
  function getAlumnos() public view returns (Alumno[] memory) {
      return alumnos;
  }
  function getNAlumnos() public view returns (uint) {
      return alumnos.length;
  }
  
   function bajaAlumno(uint index) public {
        if(alumnos[index].estado == Estado.Matriculado) {
            alumnos[index].estado = Estado.Baja;
        }
    }
}
