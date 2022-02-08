// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MopedShop {

    // адреса покупателей
    mapping (address => bool) buyers;

    // цена мопеда
    uint256 public price = 2 ether;

    // владелец моменда
    address public owner;

    // адрес магазина
    address public shopAddress;

    // полная оплачеваемость товара
    bool fullyPaid; // false

    // событие
    event ItemFullyPaid(uint _price, address _shopAddress);

    constructor() {

        // вернет адрес учетной записи из под которой развернулся смартконтракт
        owner = msg.sender;

        // адрес нашего контракта
        shopAddress = address(this);

    }

    function getBuyer(address _addr) public returns(bool) {
        // только владелец может вызывать эту функцию
        require(owner == msg.sender, "You are not owner!");

        return buyers[_addr] = true;
    }

    function addBuyer(address _addr) public {

        // только владелец может вызывать эту функцию
        require(owner == msg.sender, "You are not owner!");

        buyers[_addr] = true;
    }

    function getBalance() public view returns(uint) {
        return shopAddress.balance;
    }

    receive() external payable {

        // числиться человек который отправляет денежные средства в покупателях
        require(buyers[msg.sender], "Rejected");

        // та сумма которая приходит должна быть меньше или равна чем цена продаваемого мопеда
        require(msg.value <= price, "Rejected");

        // полной оплачиваемость еще false 
        require(fullyPaid == false, "Rejected");

        // установить что контракт уже оплачен
        if (shopAddress.balance == price) {

            // устанавливается что контракт оплачен
            fullyPaid = true;

            // вызывается событие если все оплачено
            emit ItemFullyPaid(price, shopAddress);

        }

    }

    function withdrawAll() public {

        // только владелец может снимать средства
        require(owner == msg.sender, "You are not owner!");

        // деньги можно снять только если контракт полностью оплачен
        require(fullyPaid == true, "Reject");

        // баланс больше нуля
        require(shopAddress.balance > 0, "Reject");

        // приведение типа msg.sender --> payable(msg.sender), чтоб можно было зачислять средства на адрес
        address payable receiver = payable(msg.sender);

        // отправить все что есть на балансе на указанный адрес
        receiver.transfer(shopAddress.balance);

    }



    
}