// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';
import {SafeERC20} from 'solidity-utils/contracts/oz-common/SafeERC20.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {IMilkman} from './interfaces/IMilkman.sol';

contract COWSwapper {
  using SafeERC20 for IERC20;

  error InvalidCaller();

  address public constant ALLOWED_CALLER = 0xA519a7cE7B24333055781133B13532AEabfAC81b;
  address public constant MILKMAN = 0x11C76AD590ABDFFCD980afEC9ad951B160F02797;
  address public constant CHAINLINK_PRICE_CHECKER = 0xe80a1C615F75AFF7Ed8F08c9F21f9d00982D666c;

  function swap(address fromToken, address oracleFrom, uint256 slippage) external {
    if (msg.sender != AaveGovernanceV2.SHORT_EXECUTOR) revert InvalidCaller();

    uint256 balance = IERC20(fromToken).balanceOf(address(this));

    IERC20(fromToken).safeApprove(MILKMAN, balance);

    IMilkman(MILKMAN).requestSwapExactTokensForTokens(
      balance,
      IERC20(fromToken),
      IERC20(AaveV2EthereumAssets.USDC_UNDERLYING),
      address(this),
      CHAINLINK_PRICE_CHECKER,
      _getEncodedData(oracleFrom, AaveV2EthereumAssets.USDC_ORACLE, slippage)
    );
  }

  function cancelSwap(
    address milkman,
    address fromToken,
    address oracleFrom,
    uint256 amount,
    uint256 slippage
  ) external {
    if (msg.sender != ALLOWED_CALLER && msg.sender != AaveGovernanceV2.SHORT_EXECUTOR) {
      revert InvalidCaller();
    }

    IMilkman(milkman).cancelSwap(
      amount,
      IERC20(fromToken),
      IERC20(AaveV2EthereumAssets.USDC_UNDERLYING),
      address(this),
      CHAINLINK_PRICE_CHECKER,
      _getEncodedData(oracleFrom, AaveV2EthereumAssets.USDC_ORACLE, slippage)
    );

    IERC20(fromToken).safeTransfer(
      address(AaveV2Ethereum.COLLECTOR),
      IERC20(fromToken).balanceOf(address(this))
    );
  }

  function depositIntoAaveV2(address token) external {
    uint256 amount = IERC20(token).balanceOf(address(this));
    IERC20(token).safeApprove(address(AaveV2Ethereum.POOL), amount);
    AaveV2Ethereum.POOL.deposit(token, amount, address(AaveV2Ethereum.COLLECTOR), 0);
  }

  /// @notice Transfer any tokens accidentally sent to this contract to Aave V2 Collector
  /// @param tokens List of token addresses
  function rescueTokens(address[] calldata tokens) external {
    if (msg.sender != ALLOWED_CALLER && msg.sender != AaveGovernanceV2.SHORT_EXECUTOR)
      revert InvalidCaller();
    for (uint256 i = 0; i < tokens.length; ++i) {
      IERC20(tokens[i]).safeTransfer(
        address(AaveV2Ethereum.COLLECTOR),
        IERC20(tokens[i]).balanceOf(address(this))
      );
    }
  }

  function _getEncodedData(
    address oracleOne,
    address oracleTwo,
    uint256 slippage
  ) internal pure returns (bytes memory) {
    bytes memory data;
    address[] memory paths = new address[](2);
    paths[0] = oracleOne;
    paths[1] = oracleTwo;

    bool[] memory reverses = new bool[](2);
    reverses[1] = true;

    data = abi.encode(paths, reverses);

    return abi.encode(slippage, data);
  }
}
