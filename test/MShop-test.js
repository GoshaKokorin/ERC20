const { expect } = require("chai")
const { ethers } = require("hardhat")
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace")

describe("MShop", function() {
    let owner
    let buyer
    let shop

    beforeeach(async function() {
        [owner, buyer] = await ethers.getSigners()

        const MShop = await ethers.getContractFactory("MShop", owner)
        shop = await MShop.deploy()
        await shop.deployed()
    })

    it("should have an owner and a token", async function() {
        expect(await shop.owner()).to.eq(owner.address)

        expect(await shop.token()).to.be.properAddress
    })

    it("allows to but", async function() {
        const tokenAmount = 3 

        const txData = {
            value: tokenAmount,
            to: shop.address
        }

        const tx = await buyer.sendTransaction(txData)
        await tx.wait()
        
        
    })
})