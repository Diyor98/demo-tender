import {
	loadFixture,
	time,
} from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { ethers } from 'hardhat';
import { expect } from 'chai';

describe('BepsTender', () => {
	async function fixture() {
		const [owner, addr1, addr2] = await ethers.getSigners();

		const bepsTender = await ethers.deployContract('BepsTender');
		await bepsTender.waitForDeployment();

		return { bepsTender, owner, addr1, addr2 };
	}

	describe('createTender', () => {
		it('should revert if the deadline is in the past', async () => {
			const { bepsTender } = await loadFixture(fixture);

			const deadline = (await time.latest()) - 100;

			await expect(
				bepsTender.createTender('', '', '', '', 2000, 2000, deadline)
			).to.be.revertedWith('Deadline must be greater than current date');
		});
	});
});
