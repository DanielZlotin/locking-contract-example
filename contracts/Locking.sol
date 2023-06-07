// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./ABDKMath64x64.sol";

contract Locking {
    using SafeERC20 for IERC20;
    using ABDKMath64x64 for int128;

    address public token;
    mapping(address => Lock) public locks;

    uint256 public constant BASE = 10000;
    uint256 public constant SLOPE = 12000;

    constructor(address _token) {
        token = _token;
    }

    function createLock(uint256 amount, uint256 durationSeconds) external {
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        locks[msg.sender] = Lock(amount, block.timestamp + durationSeconds);
    }

    function getLockedBalance(address target) external view returns (uint256 amount, uint256 deadline) {
        amount = locks[target].amount;
        deadline = locks[target].deadline;
    }

    // uint256 remainingSeconds = locks[target].deadline - block.timestamp;

    function calcPower(uint256 remainingSeconds) external pure returns (uint256 power) {
        int128 factor = ABDKMath64x64.divu(SLOPE, BASE);
        int128 months = ABDKMath64x64.divu(remainingSeconds, 30 days);
        power = months.log_2().mul(factor).exp_2().mulu(BASE);
    }
}

struct Lock {
    uint256 amount;
    uint256 deadline;
}
