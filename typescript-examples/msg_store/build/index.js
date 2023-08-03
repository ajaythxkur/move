"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const aptos_1 = require("aptos");
const provider = new aptos_1.Provider(aptos_1.Network.DEVNET);
const moduleAddress = "02b97d9f48f43a426fb5dbdc9818b0d0c60471f1f3a1040e16a78e01925c9d67";
const NODE_URL = process.env.APTOS_NODE_URL || "https://fullnode.devnet.aptoslabs.com";
const FAUCET_URL = process.env.APTOS_FAUCET_URL || "https://faucet.devnet.aptoslabs.com";
const faucetClient = new aptos_1.FaucetClient(NODE_URL, FAUCET_URL);
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        const alice = new aptos_1.AptosAccount();
        console.log(`alice showed up!!`);
        yield faucetClient.fundAccount(alice.address(), 100000000);
        console.log(`alice found 1 apt in garden!!`);
        const entryFunctionPayload = new aptos_1.TxnBuilderTypes.TransactionPayloadEntryFunction(aptos_1.TxnBuilderTypes.EntryFunction.natural(`${moduleAddress}::msg_store`, "create_message", [], [aptos_1.BCS.bcsSerializeStr("read aptos.dev")]));
        const rawTxn = yield provider.generateSignSubmitTransaction(alice, entryFunctionPayload);
        console.log('alice is waiting for txn to complete');
        yield provider.waitForTransaction(rawTxn);
        const payload = {
            function: `${moduleAddress}::msg_store::get_message`,
            type_arguments: [],
            arguments: [],
        };
        const message = yield provider.view(payload);
        console.log(`alice found the message stored in blockchain ${message}`);
    });
}
main();
