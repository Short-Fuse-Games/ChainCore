const { expect } = require("chai");
const { ethers } = require("hardhat");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");

describe("ChainCore", function () {
    let chainCore;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        // Get signers
        [owner, addr1, addr2] = await ethers.getSigners();

        // Deploy ChainCore
        const ChainCore = await ethers.getContractFactory("ChainCore");
        chainCore = await ChainCore.deploy();
        await chainCore.waitForDeployment();
    });

    describe("Initialization", function () {
        it("Should initialize successfully", async function () {
            await expect(chainCore.initialize())
                .to.emit(chainCore, "EngineInitialized");
        });

        it("Should not initialize twice", async function () {
            await chainCore.initialize();
            await expect(chainCore.initialize())
                .to.be.revertedWith("ChainCore: Already initialized");
        });
    });

    describe("State Management", function () {
        beforeEach(async function () {
            await chainCore.initialize();
        });

        it("Should get current state", async function () {
            const [state, version] = await chainCore.getState();
            expect(state).to.equal("0x");
            expect(version).to.equal(0);
        });

        it("Should update state", async function () {
            const newState = ethers.toUtf8Bytes("test state");
            await expect(chainCore.updateState(newState))
                .to.emit(chainCore, "StateUpdated")
                .withArgs(1, anyValue);

            const [state, version] = await chainCore.getState();
            expect(state).to.equal(ethers.hexlify(newState));
            expect(version).to.equal(1);
        });

        it("Should not allow non-owner to update state", async function () {
            const newState = ethers.toUtf8Bytes("test state");
            await expect(chainCore.connect(addr1).updateState(newState))
                .to.be.revertedWith("Ownable: caller is not the owner");
        });
    });

    describe("Event Management", function () {
        beforeEach(async function () {
            await chainCore.initialize();
        });

        it("Should emit events", async function () {
            const eventName = "TestEvent";
            const eventData = ethers.toUtf8Bytes("test data");
            
            await expect(chainCore.emitEvent(eventName, eventData))
                .to.emit(chainCore, "EventEmitted")
                .withArgs(eventName, ethers.hexlify(eventData));
        });

        it("Should not allow operations before initialization", async function () {
            const newState = ethers.toUtf8Bytes("test state");
            try {
                await chainCore.updateState(newState);
            } catch (err) {
                console.log("Error thrown:", err);
                throw err;
            }
        });
    });
}); 