import { AptosClient, FaucetClient, AptosAccount, CoinClient } from "aptos";
const NODE_URL = "https://fullnode.devnet.aptoslabs.com";
const FAUCET_URL = "https://faucet.devnet.aptoslabs.com";
const client = new AptosClient(NODE_URL);
const faucetClient = new FaucetClient(NODE_URL, FAUCET_URL);
const coinClient = new CoinClient(client);

const alice = new AptosAccount();
await faucetClient.fundAccount(alice.address(), 100_000_000);

const module_address = "db6280d9127959cacc85e0ab309e3189e8a47895d87ddc1df6f7940623ec0d9f";
let modules = await client.getAccountModules(module_address);
console.log(modules[0].abi.exposed_functions);
const hash = Buffer.from("This is seed".replace('0x', ''), 'hex');
const transaction = {
    function: `${module_address}::random::get_random_number`,
    arguments: [hash]
}
let receipt = await client.generateSignSubmitWaitForTransaction(alice, transaction);
console.log(receipt)
