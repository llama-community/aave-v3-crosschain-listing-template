// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {EthereumScript, PolygonScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3_Eth_AssetsBridge_20230808} from './AaveV3_Eth_AssetsBridge_20230808.sol';
import {AavePolEthERC20Bridge} from './AavePolEthERC20Bridge.sol';

contract DeployEthereum is EthereumScript {
  function run() external broadcast {
    bytes32 salt = keccak256(abi.encode(tx.origin, uint256(0)));
    new AavePolEthERC20Bridge{salt: salt}();
  }
}

contract DeployPolygon is PolygonScript {
  function run() external broadcast {
    bytes32 salt = keccak256(abi.encode(tx.origin, uint256(0)));
    new AavePolEthERC20Bridge{salt: salt}();
  }
}
