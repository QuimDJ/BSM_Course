// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4 <0.9.0;

contract Tricert {
    // 
    // Certificación de 'Triple Excellence' si: C1,C2 y C3 tienen éxito

    address constant private Tricert_addr=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    
    bool public triple_excellence;
    bool public C1;
    bool public C2;
    bool public C3;

    // Constructor define el estado inicial de las certificaciones
    constructor() {
        C1=false; C2=false; C3=false;
    }

    function set_C1(bool check) public {
        if (msg.sender==Tricert_addr){
            C1=check;
            if (C1==true && C2==true && C3==true){ triple_excellence=true;} else {triple_excellence=false;}
        }
    }

    function set_C2(bool check) public {
        if (msg.sender==Tricert_addr){
            C2=check;
            if (C1==true && C2==true && C3==true){ triple_excellence=true;} else {triple_excellence=false;}
        }
    }

    function set_C3(bool check) public {
        if (msg.sender==Tricert_addr){
            C3=check;
            if (C1==true && C2==true && C3==true){ triple_excellence=true;} else {triple_excellence=false;}
        }    
    }
}