import { Contract } from "ethers";
import { JsonRpcProvider, id } from "ethers";
import { ETH_BRIDGE_ABI, WETH_BRIDGE_ABI } from "./abi.js";
import { Wallet } from "ethers";
const provider = new JsonRpcProvider("http://127.0.0.1:8545");
import dotenv from "dotenv";
dotenv.config();

const ETH_BRIDGE_ADDRESS = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";
const WETH_BRIDGE_ADDRESS = "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9";

const wallet = new Wallet(
    process.env.PRIVATE_KEY as string,
    provider
);

const WETH_BRIDGE = new Contract(
    WETH_BRIDGE_ADDRESS,
    WETH_BRIDGE_ABI,
    wallet
)

const ETH_BRIDGE = new Contract(
    ETH_BRIDGE_ADDRESS,
    ETH_BRIDGE_ABI,
    wallet
)

async function pollBlock(blockNumber: number) {
    const logs = await provider.getLogs({
        address: ETH_BRIDGE_ADDRESS,
        fromBlock: blockNumber,
        toBlock: blockNumber,
        topics: [id("Deposit(address,uint256)")]
    })
    logs.forEach(async (log) => {
        const depositer = "0x" + log.topics[1].slice(26)
        const amount = (BigInt(log.data))
        console.log(depositer);
        await sendTx(depositer, amount)
    })
}

async function sendTx(from: string, amount: BigInt) {
    const transaction = await WETH_BRIDGE.depositedOnOtherSide(from, amount);
    await transaction.wait();
    console.log("confirmed");
}


// await pollBlock(9);

async function pollBlockForWETHBurn(blockNumber: number) {
    const logs = await provider.getLogs({
        address: WETH_BRIDGE_ADDRESS,
        fromBlock: blockNumber,
        toBlock: blockNumber,
        topics: [id("Burned(address,uint256)")]
    })
    logs.forEach(async (log) => {
        const depositer = "0x" + log.topics[1].slice(26)
        const amount = (BigInt(log.data))
        console.log(depositer);
        await sendTxToEthBridge(depositer, amount)
    })
}

async function sendTxToEthBridge(from: string, amount: BigInt) {
    const transaction = await ETH_BRIDGE.burnedOnOtherSide(from, amount);
    await transaction.wait();
    console.log("confirmed");
}

// await pollBlockForWETHBurn(12);