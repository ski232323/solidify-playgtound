// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Bridgeable} from "@openzeppelin/community-contracts/token/ERC20/extensions/ERC20Bridgeable.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {Nonces} from "@openzeppelin/contracts/utils/Nonces.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TESTCOIN is ERC20, ERC20Bridgeable, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes {
    address public immutable TOKEN_BRIDGE;
    error Unauthorized();

    constructor(address tokenBridge, address recipient, address initialOwner)
        ERC20("TESTCOIN", "TST")
        Ownable(initialOwner)
        ERC20Permit("TESTCOIN")
    {
        require(tokenBridge != address(0), "Invalid TOKEN_BRIDGE address");
        TOKEN_BRIDGE = tokenBridge;
        if (block.chainid == 11155111) {
            _mint(recipient, 10 * 10 ** decimals());
        }
    }

    function _checkTokenBridge(address caller) internal view override {
        if (caller != TOKEN_BRIDGE) revert Unauthorized();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, value);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }
}