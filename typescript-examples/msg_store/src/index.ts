import { Provider, Network, AptosAccount, FaucetClient, TxnBuilderTypes, BCS } from "aptos";
const provider = new Provider(Network.DEVNET);
const moduleAddress = "02b97d9f48f43a426fb5dbdc9818b0d0c60471f1f3a1040e16a78e01925c9d67";
const NODE_URL = process.env.APTOS_NODE_URL || "https://fullnode.devnet.aptoslabs.com";
const FAUCET_URL = process.env.APTOS_FAUCET_URL || "https://faucet.devnet.aptoslabs.com";
const faucetClient = new FaucetClient(NODE_URL, FAUCET_URL);
async function main(){
    const alice = new AptosAccount();
    console.log(`alice showed up!!`);
    await faucetClient.fundAccount(alice.address(), 100_000_000);
    console.log(`alice found 1 apt in garden!!`);

    const entryFunctionPayload = new TxnBuilderTypes.TransactionPayloadEntryFunction(
        TxnBuilderTypes.EntryFunction.natural(`${moduleAddress}::msg_store`, "create_message", [], [BCS.bcsSerializeStr("read aptos.dev")]),
    );
      
    const rawTxn = await provider.generateSignSubmitTransaction(alice, entryFunctionPayload);
    console.log('alice is waiting for txn to complete');
    await provider.waitForTransaction(rawTxn)
    const payload = {
        function: `${moduleAddress}::msg_store::get_message`,
        type_arguments: [],
        arguments: [],
    };
    const message = await provider.view(payload);
    console.log(`alice found the message stored in blockchain ${message}`)



}
main()

