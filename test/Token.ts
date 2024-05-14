import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Token', () => {
	async function fixture() {
		const [owner, addr1, addr2] = await ethers.getSigners();

		const token = await ethers.deployContract('Token');

		await token.waitForDeployment();

		return { token, owner, addr1, addr2 };
	}

	it('first test', async () => {
		const { token, owner } = await loadFixture(fixture);

		const ownerBalance = await token.balancesOf(owner.address);

		expect(await token.totalSupply()).to.eq(ownerBalance);
	});

	it('second test', async () => {
		const { token, owner, addr1, addr2 } = await loadFixture(fixture);

		await token.transfer(addr1.address, 50);

		expect(await token.balancesOf(addr1.address)).to.equal(50);

		await token.connect(addr1).transfer(addr2.address, 50);

		expect(await token.balancesOf(addr2.address)).to.equal(50);
		expect(await token.balancesOf(addr1.address)).to.equal(0);
	});

	it('third test', async () => {
		const { token, owner, addr1 } = await loadFixture(fixture);

		await expect(token.transfer(addr1.address, 100))
			.to.emit(token, 'Transfer')
			.withArgs(owner.address, addr1.address, 100);
	});

	it('fourth test', async () => {
		const { token, addr1, addr2 } = await loadFixture(fixture);

		await expect(
			token.connect(addr1).transfer(addr2.address, 100)
		).to.be.revertedWith('Not enough tokens');
	});
});
