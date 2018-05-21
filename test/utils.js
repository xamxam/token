function toEther(n) {
    return web3.toWei(n, 'ether')
  }
  
  module.exports = {
    assertRevert: async promise => {
      try {
        await promise
        assert.fail('Expected revert not received')
      } catch (error) {
        const revertFound = error.message.search('revert') >= 0
        assert(revertFound, `Expected 'revert', got ${error} instead`)
      }
    },
  
    toEther: toEther,
  
    halfEther: toEther(0.5),
    oneEther: toEther(1),
    twoEther: toEther(2),
    threeEther: toEther(3),
    fourEther: toEther(4),
    fiveEther: toEther(5),
    sixEther: toEther(6),
    eightEther: toEther(8),
    tenEther: toEther(10),
    hundredEther: toEther(100),
  
    GAS_LIMIT_IN_WEI: 50000000000,
    zeroAddress: '0x0000000000000000000000000000000000000000',
  }
  