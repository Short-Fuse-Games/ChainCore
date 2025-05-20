const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EventManager", function () {
    let eventManager;
    let owner;
    let addr1;

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();
        const EventManager = await ethers.getContractFactory("EventManager");
        eventManager = await EventManager.deploy();
        await eventManager.deployed();
    });

    it("Should emit and store events", async function () {
        const name = "TestEvent";
        const data = ethers.utils.toUtf8Bytes("event data");
        const tx = await eventManager.emitEvent(name, data);
        const receipt = await tx.wait();
        const event = receipt.events.find(e => e.event === "EventEmitted");
        expect(event.args.id).to.equal(1);
        expect(event.args.name).to.equal(name);
        expect(event.args.data).to.equal(ethers.utils.hexlify(data));
        expect(await eventManager.getEventCount()).to.equal(1);
    });

    it("Should return event by index", async function () {
        const name = "EventA";
        const data = ethers.utils.toUtf8Bytes("dataA");
        await eventManager.emitEvent(name, data);
        const event = await eventManager.getEvent(0);
        expect(event[1]).to.equal(name);
        expect(event[2]).to.equal(ethers.utils.hexlify(data));
    });

    it("Should revert when getting event with invalid index", async function () {
        await expect(eventManager.getEvent(0)).to.be.revertedWith("EventManager: Invalid index");
    });

    it("Should filter events by name", async function () {
        const nameA = "EventA";
        const nameB = "EventB";
        const dataA = ethers.utils.toUtf8Bytes("dataA");
        const dataB = ethers.utils.toUtf8Bytes("dataB");
        await eventManager.emitEvent(nameA, dataA);
        await eventManager.emitEvent(nameB, dataB);
        await eventManager.emitEvent(nameA, dataB);
        const filtered = await eventManager.filterEventsByName(nameA);
        expect(filtered.length).to.equal(2);
        expect(filtered[0].name).to.equal(nameA);
        expect(filtered[1].name).to.equal(nameA);
    });

    // Helper to get the next block timestamp
    async function getBlockTimestamp() {
        const blockNum = await ethers.provider.getBlockNumber();
        const block = await ethers.provider.getBlock(blockNum);
        return block.timestamp;
    }
}); 