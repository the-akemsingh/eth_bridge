// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface WEth {
    function mint(address to, uint amount) external;
    function burn(address to, uint amount) external;
    function balanceOf(address account) external view returns (uint256);
}

contract WEthBridge is Ownable {
    address WEthAddress;
    mapping(address => uint) usersRecord;
    event Burned(address indexed depositor, uint amount);

    constructor(address _EthContractAddress) Ownable(msg.sender) {
        WEthAddress = _EthContractAddress;
    }

    function mint(uint amount) public onlyOwner {
        require(usersRecord[msg.sender] >= amount);
        WEth(WEthAddress).mint(msg.sender, amount);
        usersRecord[msg.sender] -= amount;
    }

    function burn(uint amount) public {
        require(WEth(WEthAddress).balanceOf(msg.sender) >= amount);
        WEth(WEthAddress).burn(msg.sender, amount);
        emit Burned(msg.sender, amount);
    }

    function deopsitedOnOtherSide(address from, uint amount) public onlyOwner {
        usersRecord[from] += amount;
    }
}
