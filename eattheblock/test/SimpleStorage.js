const SimpleStorage = artifacts.require('SimpleStorage');

contract('SimpleStorage', function (accounts) {
  it('should store the value', async function () {
    const simpleStorage = await SimpleStorage.deployed();
    await simpleStorage.set(12345);
    const storedValue = await simpleStorage.get();

    assert.equal(
      storedValue.toNumber(),
      12345,
      'The value is not stored correctly'
    );
  });
});
