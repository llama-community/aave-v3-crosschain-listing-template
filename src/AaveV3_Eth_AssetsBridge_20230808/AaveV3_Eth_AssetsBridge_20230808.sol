// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from 'aave-helpers/interfaces/IProposalGenericExecutor.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

/**
 * @title Bridge Assets From Polygon To Ethereum
 * @author Llama
 * - Snapshot: https://snapshot.org/#/aave.eth/proposal/0xb4141f12f7ec8e037e6320912b5673fcc5909457d9f6201c018d5c15e5aa5083
 * - Discussion: https://governance.aave.com/t/arfc-deploy-ethereum-collector-contract/12205
 */
contract AaveV3_Eth_AssetsBridge_20230808 is IProposalGenericExecutor {
  function execute() external {}
}
