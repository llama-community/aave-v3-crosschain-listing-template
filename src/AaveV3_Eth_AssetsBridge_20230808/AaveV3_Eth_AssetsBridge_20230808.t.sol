// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

/**
 * @dev Test for AaveV3_Eth_AssetsBridge_20230808
 * command: make test-contract filter=AaveV3_Eth_AssetsBridge_20230808
 */
contract AaveV3_Eth_AssetsBridge_20230808_Test is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 17870364);
  }


}
