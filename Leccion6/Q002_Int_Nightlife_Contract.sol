// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract INightSafe_Certif3 {
    // 
    // Certification to Triple Excellence
    // International Nightlife Safety Certified (INSC) +
    // International Nightlife Acoustic Quality (INAQ) +
    // International Nightlife Quality Service (INQS).

    address constant private INightSafe_addr=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    
    bool public triple_excellence;
    bool public INAQ;
    bool public INSC;
    bool public INQS;

    // Constructor code is only run when the contract
    // is created
    constructor() {
        INAQ=false; INSC=false; INQS=false;
    }

    function set_INSC(bool check) public {
        if (msg.sender==INightSafe_addr){
            INSC=check;
            if (INSC==true && INAQ==true && INQS==true){ triple_excellence=true;} else {triple_excellence=false;}
        }
    }

    function set_INAQ(bool check) public {
        if (msg.sender==INightSafe_addr){
            INAQ=check;
            if (INSC==true && INAQ==true && INQS==true){ triple_excellence=true;} else {triple_excellence=false;}
        }
    }

    function set_INQS(bool check) public {
        if (msg.sender==INightSafe_addr){
            INQS=check;
            if (INSC==true && INAQ==true && INQS==true){ triple_excellence=true;} else {triple_excellence=false;}
        }    
    }
}