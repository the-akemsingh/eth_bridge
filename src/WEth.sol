// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WEth is ERC20, Ownable {
    constructor() ERC20("WEth", "WEth") Ownable(msg.sender) {
        
    }

    function mint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint amount) public onlyOwner {
        _burn(from, amount);
    }
}
