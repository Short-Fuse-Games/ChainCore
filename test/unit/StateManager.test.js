const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("StateManager", function () {
    let stateManager;
    let owner;
    let addr1;

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();
        const StateManager = await ethers.getContractFactory("StateManager");
        stateManager = await StateManager.deploy();
        await stateManager.waitForDeployment();
    });

    it("Should return initial state and version", async function () {
        const [state, version] = await stateManager.getState();
        expect(state).to.equal("0x");
        expect(version).to.equal(0);
    });

    it("Should update state and increment version", async function () {
        const newState = ethers.toUtf8Bytes("state1");
        await expect(stateManager.updateState(newState))
            .to.emit(stateManager, "StateUpdated")
            .withArgs(1, ethers.hexlify(newState));
        const [state, version] = await stateManager.getState();
        expect(state).to.equal(ethers.hexlify(newState));
        expect(version).to.equal(1);
    });

    it("Should keep state history and allow rollback", async function () {
        const state1 = ethers.toUtf8Bytes("state1");
        const state2 = ethers.toUtf8Bytes("state2");
        await stateManager.updateState(state1);
        await stateManager.updateState(state2);
        // Rollback to version 1
        await expect(stateManager.rollbackState(1))
            .to.emit(stateManager, "StateRolledBack")
            .withArgs(1, ethers.hexlify(state1));
        const [state, version] = await stateManager.getState();
        expect(state).to.equal(ethers.hexlify(state1));
        expect(version).to.equal(1);
    });

    it("Should revert rollback to invalid version", async function () {
        await expect(stateManager.rollbackState(99)).to.be.revertedWith("StateManager: Invalid version");
    });

    it("Should revert rollback if no state for version", async function () {
        // Only version 0 exists, but no state set
        await expect(stateManager.rollbackState(0)).to.be.revertedWith("StateManager: Invalid version");
    });

    it("Should return the correct state version", async function () {
        const state1 = ethers.toUtf8Bytes("state1");
        await stateManager.updateState(state1);
        expect(await stateManager.getStateVersion()).to.equal(1);
    });
}); 