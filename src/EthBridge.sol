// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface Eth {
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
}

contract EthBridge is Ownable {
    address EthAddress;
    mapping(address => uint) usersRecord;
    event Deposit(address indexed depositor, uint amount);

    constructor(address _EthContractAddress) Ownable(msg.sender) {
        EthAddress = _EthContractAddress;
    }

    function lock(uint amount) public {
        require(amount <= Eth(EthAddress).allowance(msg.sender, address(this)));
        Eth(EthAddress).transferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, amount);
    }

    function unLock(uint amount) public {
        require(amount <= usersRecord[msg.sender]);
        Eth(EthAddress).transfer(msg.sender, amount);
        usersRecord[msg.sender] -= amount;
    }

    function burnedOnOtherSide(address from, uint amount) public onlyOwner {
        usersRecord[from] += amount;
    }
}
