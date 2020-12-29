var ERC721MintableComplete = artifacts.require('CustomERC721Token');

contract('TestERC721Mintable', accounts => {

  const account_1 = accounts[0];
  const account_2 = accounts[1];
  const account_3 = accounts[2];

  describe('match erc721 spec', function () {
    beforeEach(async function () {
      this.contract = await ERC721MintableComplete.new("Dwelling Token", "DWL", {from: account_1});

      // TODO: mint multiple tokens
      await this.contract.mint(account_1, 1);
      await this.contract.mint(account_1, 2);
      await this.contract.mint(account_2, 3);
    })

    it('should return total supply', async function () {
      const count = await this.contract.totalSupply();
      assert.equal(count, 3, "Total supply does not match")
    })

    it('should get token balance', async function () {
      let bal = await this.contract.balanceOf(account_1);
      assert.equal(bal.toString(), '2', 'Balance does not match for first account');

      bal = await this.contract.balanceOf(account_2);
      assert.equal(bal.toString(), '1', 'Balance does not match for second account');

    })

    // token uri should be complete i.e: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1
    it('should return token uri', async function () {
      let uri = await this.contract.tokenURI(1);
      assert.equal(
        uri,
        'https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/1',
        `URI does not match`
      );

      uri = await this.contract.tokenURI(2);
      assert.equal(
        uri,
        'https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/2',
        `URI does not match`
      );
    })

    it('should transfer token from one owner to another', async function () {
      let bal = await this.contract.balanceOf(account_1);
      assert.equal(bal.toString(), '2', 'Starting balance does not match for first account');

      bal = await this.contract.balanceOf(account_2);
      assert.equal(bal.toString(), '1', 'Starting balance does not match for second account');

      await this.contract.transferFrom(account_1, account_2, 1);

      bal = await this.contract.balanceOf(account_1);
      assert.equal(bal.toString(), '1', 'Transfer balance does not match for first account');

      bal = await this.contract.balanceOf(account_2);
      assert.equal(bal.toString(), '2', 'Transfer balance does not match for second account');
    })
  });

  describe('have ownership properties', function () {
    beforeEach(async function () {
      this.contract = await ERC721MintableComplete.new("Dwelling Token", "DWL", {from: account_1});
    })

    it('should fail when minting when address is not contract owner', async function () {
      let msg = 'OK';
      try {
        await this.contract.mint(account_2, 1, {from: account_2});
      } catch (e) {
        msg = e.reason;
      }

      assert.equal(msg, 'Only the owner is allowed to perform this action', "Transaction did not fail");
    })

    it('should return contract owner', async function () {
      const owner = await this.contract.getOwner();
      assert.equal(owner, account_1, "Contract owner is not correct");
    })

  });
})