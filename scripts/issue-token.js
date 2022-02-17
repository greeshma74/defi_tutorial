// For Client Side Application

const TokenFarm = artifacts.require('TokenFarm')

module.exports = async function(callback) {
    let tokenFarm = await TokenFarm.deployed()

    // Code goes here
    console.log("Tokens issued")

    callback()
}