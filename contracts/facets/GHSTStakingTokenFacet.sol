// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

import "../libraries/AppStorage.sol";

contract GHSTStakingTokenFacet {
    AppStorage s;

    uint256 constant MAX_UINT = uint256(-1);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function name() external pure returns (string memory) {
        return "GHSTStakingToken";
    }

    function symbol() external pure returns (string memory) {
        return "GHSTS";
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return s.ghstStakingTokensTotalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance_) {
        balance_ = s.accounts[_owner].ghstStakingTokens;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        uint256 frombalance = s.accounts[msg.sender].ghstStakingTokens;
        require(frombalance >= _value, "Not enough GHSTStakingToken to transfer");
        s.accounts[msg.sender].ghstStakingTokens = frombalance - _value;
        s.accounts[_to].ghstStakingTokens += _value;
        emit Transfer(msg.sender, _to, _value);
        success = true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        uint256 fromBalance = s.accounts[_from].ghstStakingTokens;
        if (msg.sender != _from) {
            uint256 l_allowance = s.accounts[_from].ghstStakingTokensAllowances[msg.sender];
            require(l_allowance >= _value, "Allowance not great enough to transfer GHSTStakingToken");
            if (l_allowance != MAX_UINT) {
                s.accounts[_from].ghstStakingTokensAllowances[msg.sender] = l_allowance - _value;
                emit Approval(_from, msg.sender, l_allowance - _value);
            }
        }
        require(fromBalance >= _value, "Not enough GHSTStakingToken to transfer");
        s.accounts[_from].ghstStakingTokens = fromBalance - _value;
        s.accounts[_to].ghstStakingTokens += _value;
        emit Transfer(_from, _to, _value);
        success = true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success_) {
        s.accounts[msg.sender].ghstStakingTokensAllowances[_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success_ = true;
    }

    function increaseAllowance(address _spender, uint256 _value) external returns (bool success) {
        uint256 l_allowance = s.accounts[msg.sender].ghstStakingTokensAllowances[_spender];
        uint256 newAllowance = l_allowance + _value;
        require(newAllowance >= l_allowance, "GHSTStakingToken allowance increase overflowed");
        s.accounts[msg.sender].ghstStakingTokensAllowances[_spender] = newAllowance;
        emit Approval(msg.sender, _spender, newAllowance);
        success = true;
    }

    function decreaseAllowance(address _spender, uint256 _value) external returns (bool success) {
        uint256 l_allowance = s.accounts[msg.sender].ghstStakingTokensAllowances[_spender];
        require(l_allowance >= _value, "GHSTStakingToken allowance decreased below 0");
        l_allowance -= _value;
        s.accounts[msg.sender].ghstStakingTokensAllowances[_spender] = l_allowance;
        emit Approval(msg.sender, _spender, l_allowance);
        success = true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining_) {
        remaining_ = s.accounts[_owner].ghstStakingTokensAllowances[_spender];
    }

    // function mint() external {
    //     uint256 amount = 4_000_000_000e18;
    //     s.balances[msg.sender] += amount;
    //     s.totalSupply += uint96(amount);
    //     emit Transfer(address(0), msg.sender, amount);
    // }
}
