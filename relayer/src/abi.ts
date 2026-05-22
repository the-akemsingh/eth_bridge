const WETH_BRIDGE_ABI = [

    {
        "inputs": [
            {
                "internalType": "address",
                "name": "from",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "amount",
                "type": "uint256"
            }
        ],
        "name": "depositedOnOtherSide",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]
const ETH_BRIDGE_ABI = [

    {
        "inputs": [
            {
                "internalType": "address",
                "name": "from",
                "type": "address"
            },
            {
                "internalType": "uint256",
                "name": "amount",
                "type": "uint256"
            }
        ],
        "name": "burnedOnOtherSide",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]

export { WETH_BRIDGE_ABI, ETH_BRIDGE_ABI };