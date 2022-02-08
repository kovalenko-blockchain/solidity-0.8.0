// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MyShop {
    address public owner;

    // 0xd9145CCE52D386f254917e481eB44e9943F39138

    // хранит информацию о платильщике
    mapping (address => uint) public payments; 

    constructor() {

        // адрес отправителя
        owner = msg.sender; 
    
    }

    // payable принимает деньги
    function payForItem() public payable { 

        // сколько прислали только 1 раз
        payments[msg.sender] = msg.value; 
    
    }

    function withdrawAll() public {

        // владелец контракта
        address payable _to = payable(owner);

        // текущий контракт
        address _thisContract = address(this);

        // переправляю скопившийся баланс контракта владельцу контракта
        _to.transfer(_thisContract.balance);
    
    }
} 