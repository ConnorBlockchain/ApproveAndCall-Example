const mockApprover = artifacts.require('./mockApprover.sol');
const mockReceiver = artifacts.require('./mockReceiver.sol');
const ERC20BurnableAndMintable = artifacts.require('./ERC20BurnableAndMintable.sol');

contract('ApproveAndCallMock', async (accounts) => {
  const erc20Creator = accounts[0];
  const vester = accounts[1];

  let mockApproverInstance;
  let mockReceiverInstance;
  let erc20Instance;

  const initialAmount = 1000;
  const tokenName = 'ApproverToken';
  const decimalUnits = 18;
  const tokenSymbol = 'APT';

  it('Deploy Contracts', async () => {
    erc20Instance = await ERC20BurnableAndMintable.new(
      initialAmount,
      tokenName,
      decimalUnits,
      tokenSymbol,
      {from: erc20Creator});

    mockReceiverInstance = await mockReceiver.new(erc20Instance.address);
    mockApproverInstance = await mockApprover.new(erc20Instance.address, mockReceiverInstance.address);
  });

  it('Transfer 35%', async () => {
    await erc20Instance.transfer(mockApproverInstance.address, 350);
    assert.equal(await erc20Instance.balanceOf(mockApproverInstance.address), 350);
  });

  it('ApproveAndCall mock auction', async () => {
    await mockApproverInstance.sendTo(100, vester);
    assert.equal(await mockReceiverInstance.userAddress(), vester, 'address set');
    assert.equal(await mockReceiverInstance.total(), 100, 'transfered value');
  });
});
