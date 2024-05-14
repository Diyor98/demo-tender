import { buildModule } from '@nomicfoundation/hardhat-ignition/modules';

const tokenModule = buildModule('TokenModule', (m) => {
	const token = m.contract('Token');

	return { token };
});

export default tokenModule;
