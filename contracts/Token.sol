pragma solidity 0.7.0;

import "./IERC20.sol";
import "./IMintableToken.sol";
import "./IDividends.sol";
import "./SafeMath.sol";

contract Token is IERC20, IMintableToken, IDividends {
  // ------------------------------------------ //
  // ----- BEGIN: DO NOT EDIT THIS SECTION ---- //
  // ------------------------------------------ //
  using SafeMath for uint256;
  uint256 public totalSupply;
  uint256 public decimals = 18;
  string public name = "Test token";
  string public symbol = "TEST";
  mapping (address => uint256) public balanceOf;
  // ------------------------------------------ //
  // ----- END: DO NOT EDIT THIS SECTION ------ //
  // ------------------------------------------ //

  // -----------------------------
  // ERC20 allowances
  // -----------------------------
  mapping(address => mapping(address => uint256)) private _allowances;

  // -----------------------------
  // Holder tracking (non-zero balances)
  // - holders array stores addresses
  // - holderIndex is 1-based index into holders array (0 = not present)
  // This enables O(1) add/remove via swap+pop.
  // -----------------------------
  address[] private _holders;
  mapping(address => uint256) private _holderIndex1; // 1-based

  // -----------------------------
  // Dividends: withdrawable ETH per address
  // -----------------------------
  mapping(address => uint256) private _withdrawableDividend;

  // -----------------------------
  // Internal: holder helpers
  // -----------------------------
  function _addHolder(address a) internal {
    if (_holderIndex1[a] != 0) return;
    _holders.push(a);
    _holderIndex1[a] = _holders.length; // 1-based
  }

  function _removeHolder(address a) internal {
    uint256 idx1 = _holderIndex1[a];
    if (idx1 == 0) return; // not present
    uint256 idx0 = idx1 - 1;

    uint256 last0 = _holders.length - 1;
    if (idx0 != last0) {
      address lastAddr = _holders[last0];
      _holders[idx0] = lastAddr;
      _holderIndex1[lastAddr] = idx0 + 1;
    }

    _holders.pop();
    _holderIndex1[a] = 0;
  }

  function _updateHolder(address a, uint256 prevBal, uint256 newBal) internal {
    if (prevBal == 0 && newBal > 0) {
      _addHolder(a);
    } else if (prevBal > 0 && newBal == 0) {
      _removeHolder(a);
    }
  }

  // IERC20

  function allowance(address owner, address spender) external view override returns (uint256) {
    return _allowances[owner][spender];
  }

  function approve(address spender, uint256 value) external override returns (bool) {
    _allowances[msg.sender][spender] = value;
    return true;
  }

  function transfer(address to, uint256 value) external override returns (bool) {
    require(to != address(0), "bad to");
    uint256 fromBal = balanceOf[msg.sender];
    require(fromBal >= value, "insufficient");

    uint256 toBal = balanceOf[to];

    uint256 newFrom = fromBal.sub(value);
    uint256 newTo = toBal.add(value);

    balanceOf[msg.sender] = newFrom;
    balanceOf[to] = newTo;

    _updateHolder(msg.sender, fromBal, newFrom);
    _updateHolder(to, toBal, newTo);

    return true;
  }

  function transferFrom(address from, address to, uint256 value) external override returns (bool) {
    require(to != address(0), "bad to");

    uint256 allowed = _allowances[from][msg.sender];
    require(allowed >= value, "allowance");

    uint256 fromBal = balanceOf[from];
    require(fromBal >= value, "insufficient");

    uint256 toBal = balanceOf[to];

    _allowances[from][msg.sender] = allowed.sub(value);

    uint256 newFrom = fromBal.sub(value);
    uint256 newTo = toBal.add(value);

    balanceOf[from] = newFrom;
    balanceOf[to] = newTo;

    _updateHolder(from, fromBal, newFrom);
    _updateHolder(to, toBal, newTo);

    return true;
  }

  // IMintableToken

  function mint() external payable override {
    require(msg.value > 0, "no eth");
    uint256 prev = balanceOf[msg.sender];
    uint256 next = prev.add(msg.value);

    balanceOf[msg.sender] = next;
    totalSupply = totalSupply.add(msg.value);

    _updateHolder(msg.sender, prev, next);
  }

  function burn(address payable dest) external override {
    require(dest != address(0), "bad dest");
    uint256 bal = balanceOf[msg.sender];
    require(bal > 0, "no tokens");

    balanceOf[msg.sender] = 0;
    totalSupply = totalSupply.sub(bal);

    _updateHolder(msg.sender, bal, 0);

    (bool ok, ) = dest.call{ value: bal }("");
    require(ok, "eth send failed");
  }

  // IDividends

  function getNumTokenHolders() external view override returns (uint256) {
    return _holders.length;
  }

  function getTokenHolder(uint256 index) external view override returns (address) {
    // index is 1-based per interface + tests
    if (index == 0 || index > _holders.length) return address(0);
    return _holders[index - 1];
  }

  function recordDividend() external payable override {
    require(msg.value > 0, "no eth");
    uint256 n = _holders.length;
    if (n == 0) return; // no holders to assign to (shouldn't happen in tests)
    require(totalSupply > 0, "no supply");

    // Assign dividend proportional to balances at this moment
    for (uint256 i = 0; i < n; i++) {
      address h = _holders[i];
      uint256 bal = balanceOf[h];
      if (bal == 0) continue; // safety (shouldn't happen if list maintained)
      uint256 share = msg.value.mul(bal).div(totalSupply);
      if (share > 0) {
        _withdrawableDividend[h] = _withdrawableDividend[h].add(share);
      }
    }
  }

  function getWithdrawableDividend(address payee) external view override returns (uint256) {
    return _withdrawableDividend[payee];
  }

  function withdrawDividend(address payable dest) external override {
    require(dest != address(0), "bad dest");
    uint256 amount = _withdrawableDividend[msg.sender];
    require(amount > 0, "no dividend");

    // effects first (re-entrancy safe pattern)
    _withdrawableDividend[msg.sender] = 0;

    (bool ok, ) = dest.call{ value: amount }("");
    require(ok, "eth send failed");
  }
}
