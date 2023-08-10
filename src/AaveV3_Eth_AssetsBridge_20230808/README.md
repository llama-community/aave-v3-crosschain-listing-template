# Aave Polygon -> Mainnet ERC20 Bridge

## Functions

## Burn Proof Generation

After you have called `withdraw()` Polygon, it will take 30-90 minutes for a checkpoint to happen. Once the next checkpoint includes the burn transaction, you can withdraw the tokens on Mainnet.

The API endpoint used to generate the burn proof is as follows, where `TRANSACTION_HASH` is the transaction to `withdraw()`. `EVENT_SIGNATURE` is the signature of the `Withdraw` event.

https://proof-generator.polygon.technology/api/v1/matic/exit-payload/<TRANSACTION_HASH>?eventSignature=<EVENT_SIGNATURE>

Here's a sample transaction: https://polygonscan.com/tx/0x08365e09c94c5796ae300e706cc516714661a42c50dfff2fa1e9a01b036b21d6

The log topic to use is the `Transfer` function to the zero address (aka. burn).

https://polygonscan.com/tx/0x08365e09c94c5796ae300e706cc516714661a42c50dfff2fa1e9a01b036b21d6#eventlog

TRANSACTION_HASH: 0x08365e09c94c5796ae300e706cc516714661a42c50dfff2fa1e9a01b036b21d6
EVENT_SIGNATURE: 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef

And the generated proof: https://proof-generator.polygon.technology/api/v1/matic/exit-payload/0x08365e09c94c5796ae300e706cc516714661a42c50dfff2fa1e9a01b036b21d6?eventSignature=0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef

The result is the bytes data that is later passed to `exit()`.

## Deployed Addresses

Mainnet:
Polygon:
