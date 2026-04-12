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

    function mint(address to, uint amount) public onlyOwner {
        require(usersRecord[to] >= amount);
        WEth(WEthAddress).mint(to, amount);
        usersRecord[to] -= amount;
    }

    function burnFrom(address from, uint amount) public onlyOwner {
        require(WEth(WEthAddress).balanceOf(from) >= amount);
        WEth(WEthAddress).burn(from, amount);
        emit Burned(from, amount);
    }

    function deopsitedOnOtherSide(address from, uint amount) public onlyOwner {
        usersRecord[from] += amount;
    }
}
