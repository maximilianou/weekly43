# weekly43

#### First Steps Learning Web3 - notes about ' following one tutorial '

#### Smart Contracts, Solidity, truffle, ganache, ethereum, Decentralized Bank Dev Local.


- Makefile
```
step10 web3-client:
	npm i -g truffle
step11 web3-ganache-install:
	curl https://github.com/trufflesuite/ganache/releases/download/v2.5.4/ganache-2.5.4-linux-x86_64.AppImage; mv ganache-2.5.4-linux-x86_64.AppImage /usr/local/bin/; chmod +x /usr/local/bin/ganache-2.5.4-linux-x86_64.AppImage; ln -s /usr/local/bin//usr/local/bin/ganache-2.5.4-linux-x86_64.AppImage /usr/local/bin/ganache;
step12 web3-browser-metamask:
	echo 'Install metamask in google chrome https://metamask.io/download.html'
step13 web3-dbank:
	curl https://github.com/dappuniversity/dbank/archive/refs/heads/starter_kit.zip; unzip dbank-starter_kit.zip
step14 web3-npm-install:
	cd dbank-starter_kit; npm i
step15 web3-compile:
	cd dbank-starter_kit; truffle compile
step16 web3-ganache-run:
	cd dbank-starter_kit; ganache
step17 web3-migrate:
	cd dbank-starter_kit; truffle migrate
step18 web3-test:
	cd dbank-starter_kit; truffle test
```


```js
:~/projects/weekly43/dbank-starter_kit$ truffle console
truffle(development)> const token = await Token.deployed();
undefined
truffle(development)> 
truffle(development)> token.address
'0x186c1da6932F8ED63319d3DC41ce7d36104F89d4'
truffle(development)> token.name()
'Decentrilized Bank Currency'
truffle(development)> token.symbol();
'DBC'
truffle(development)> token.totalSupply();
BN { negative: 0, words: [ 0, <1 empty item> ], length: 1, red: null }
truffle(development)> web3.eth.getAccounts();
[
  '0xBEe6b88820912b7F2Ae2c844d50aBA3BAd964D8A',
  '0x3B3C5A3d38C31192224307Fa4E692559018dCBdB',
  '0xB794ad285f790E2dcD2Dc3Dc758BfDeFFA171642',
  '0xcA7bC91d87C04Da1fF6C86081946ABa1d34cf90B',
  '0x416dCEB4Cb0D536CE1077381B1c7c9F76eDeF35C',
  '0xa1490D868b5653a8471C0dA81a24e920A1c1a3a2',
  '0xD00689830BFA0c1Dc63433ED8aC35d1b0C10c045',
  '0x1dC9601FB1F39FE3D8eE55784ECb3cAb8F012Cab',
  '0x98Dc60A7B1b293cad665313BafFD0acB6C653884',
  '0xe3CD676d11512320eE6D70D3Aee98AF6d89e8f4a'
]
truffle(development)> const accounts = web3.eth.getAccounts();

truffle(development)> token.mint(theAcc, web3.utils.toWei('100'));

truffle(development)> tokenBalance = await token.balanceOf(theAcc);
undefined
truffle(development)> tokenBalance
BN {
  negative: 0,
  words: [ 51380224, 30903128, 22204, <1 empty item> ],
  length: 3,
  red: null
}
truffle(development)> tokenBalance.toString();
'100000000000000000000'

```


---
- dbank-starter_kit/test/helpers.js
```js
export const ETHER_ADDRESS = '0x0000000000000000000000000000000000000000'
export const EVM_REVERT = 'VM Exception while processing transaction: revert'

export const ether = n => {
  return new web3.utils.BN(
    web3.utils.toWei(n.toString(), 'ether')
  )
}

// Same as ether
export const tokens = n => ether(n)

export const wait = s => {
  const milliseconds = s * 1000
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}
```
---
- dbank-starter_kit/test/test.js
```js
import { tokens, ether, ETHER_ADDRESS, EVM_REVERT, wait } from './helpers'

const Token = artifacts.require('./Token')
const DecentralizedBank = artifacts.require('./dBank')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('dBank', ([deployer, user]) => {
  let dbank, token
  const interestPerSecond = 31668017 //(10% APY) for min. deposit (0.01 ETH)

  beforeEach(async () => {
    token = await Token.new()
    dbank = await DecentralizedBank.new(token.address)
    await token.passMinterRole(dbank.address, {from: deployer})
  })

  describe('testing token contract...', () => {
    describe('success', () => {
      it('checking token name', async () => {
        expect(await token.name()).to.be.eq('Decentralized Bank Currency')
      })

      it('checking token symbol', async () => {
        expect(await token.symbol()).to.be.eq('DBC')
      })

      it('checking token initial total supply', async () => {
        expect(Number(await token.totalSupply())).to.eq(0)
      })

      it('dBank should have Token minter role', async () => {
        expect(await token.minter()).to.eq(dbank.address)
      })
    })

    describe('failure', () => {
      it('passing minter role should be rejected', async () => {
        await token.passMinterRole(user, {from: deployer}).should.be.rejectedWith(EVM_REVERT)
      })

      it('tokens minting should be rejected', async () => {
        await token.mint(user, '1', {from: deployer}).should.be.rejectedWith(EVM_REVERT) //unauthorized minter
      })
    })
  })

  describe('testing deposit...', () => {
    let balance

    describe('success', () => {
      beforeEach(async () => {
        await dbank.deposit({value: 10**16, from: user}) //0.01 ETH
      })

      it('balance should increase', async () => {
        expect(Number(await dbank.etherBalanceOf(user))).to.eq(10**16)
      })

      it('deposit time should > 0', async () => {
        expect(Number(await dbank.depositStart(user))).to.be.above(0)
      })

      it('deposit status should eq true', async () => {
        expect(await dbank.isDeposited(user)).to.eq(true)
      })
    })

    describe('failure', () => {
      it('depositing should be rejected', async () => {
        await dbank.deposit({value: 10**15, from: user}).should.be.rejectedWith(EVM_REVERT) //to small amount
      })
    })
  })

  describe('testing withdraw...', () => {
    let balance

    describe('success', () => {

      beforeEach(async () => {
        await dbank.deposit({value: 10**16, from: user}) //0.01 ETH

        await wait(2) //accruing interest

        balance = await web3.eth.getBalance(user)
        await dbank.withdraw({from: user})
      })

      it('balances should decrease', async () => {
        expect(Number(await web3.eth.getBalance(dbank.address))).to.eq(0)
        expect(Number(await dbank.etherBalanceOf(user))).to.eq(0)
      })

      it('user should receive ether back', async () => {
        expect(Number(await web3.eth.getBalance(user))).to.be.above(Number(balance))
      })

      it('user should receive proper amount of interest', async () => {
        //time synchronization problem make us check the 1-3s range for 2s deposit time
        balance = Number(await token.balanceOf(user))
        expect(balance).to.be.above(0)
        expect(balance%interestPerSecond).to.eq(0)
        expect(balance).to.be.below(interestPerSecond*4)
      })

      it('depositer data should be reseted', async () => {
        expect(Number(await dbank.depositStart(user))).to.eq(0)
        expect(Number(await dbank.etherBalanceOf(user))).to.eq(0)
        expect(await dbank.isDeposited(user)).to.eq(false)
      })
    })

    describe('failure', () => {
      it('withdrawing should be rejected', async () =>{
        await dbank.deposit({value: 10**16, from: user}) //0.01 ETH
        await wait(2) //accruing interest
        await dbank.withdraw({from: deployer}).should.be.rejectedWith(EVM_REVERT) //wrong user
      })
    })
  })
})
```

---
- dbank-starter_kit/migrations/1_initial_migration.js
```js
const Migrations = artifacts.require("Migrations");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};

```
---
- dbank-starter_kit/migrations/2_deploy.js
```js
const Token = artifacts.require("Token");
const dBank = artifacts.require("dBank");

module.exports = async function(deployer) {
	//deploy Token
  await deployer.deploy(Token);
	//assign token into variable to get it's address
	const token = await Token.deployed();
	//pass token address for dBank contract(for future minting)
  await deployer.deploy(dBank, token.address);
	//assign dBank contract into variable to get it's address
  const dbank = await dBank.deployed();
	//change token's owner/minter from deployer to dBank
	await token.passMinterRole(dbank.address);
};
```

---
- dbank-starter_kit/src/contracts/Migrations.sol
```js
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;

  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
```
---
- dbank-starter_kit/src/contracts/dBank.sol
```js
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {

  //assign Token contract to variable
  Token private token;
  //add mappings
  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public depositStart;
  mapping(address => bool) public isDeposited;
  //add events
  event Deposit(address indexed user, uint etherAmount, uint timeStart);
  event Withdraw(address indexed user, uint etherAmount, uint depositTime, uint interest);
  //pass as constructor argument deployed Token contract
  constructor(Token _token) public {
    //assign token deployed contract to variable
    token = _token;
  }

  function deposit() payable public {
    //check if msg.sender didn't already deposited funds
    require(isDeposited[msg.sender] == false, 'Error, deposit already active');
    //check if msg.value is >= than 0.01 ETH
    require(msg.value >= 1e16,'Error, deposit must be >= 0.01 ETH');
  
    etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;
    //increase msg.sender ether deposit balance
    //start msg.sender hodling time
    depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;
    //set msg.sender deposit status to true
    isDeposited[msg.sender] = true;
    //emit Deposit event
    emit Deposit(msg.sender, msg.value, block.timestamp);

  }

  function withdraw() public {
    //check if msg.sender deposit status is true
    require(isDeposited[msg.sender] == true,'Error, no previous deposit');
    //assign msg.sender ether deposit balance to variable for event
    uint userBalance = etherBalanceOf[msg.sender];

    //check user's hodl time
    uint depositTime = block.timestamp - depositStart[msg.sender];
    //calc interest per second
    //calc accrued interest
    uint interestPerSecond = 31668017 * (etherBalanceOf[msg.sender] / 1e16);
    uint interest = interestPerSecond * depositTime;
    //send eth to user
    msg.sender.transfer(userBalance);
    //send interest in tokens to user
    token.mint(msg.sender, interest);

    //reset depositer data
    depositStart[msg.sender] = 0;
    etherBalanceOf[msg.sender] = 0;    
    isDeposited[msg.sender] = false;
    //emit event
    emit Withdraw(msg.sender, userBalance, depositTime, interest);
  }

  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    //check if user doesn't have active loan

    //add msg.value to ether collateral

    //calc tokens amount to mint, 50% of msg.value

    //mint&send tokens to user

    //activate borrower's loan status

    //emit event
  }

  function payOff() public {
    //check if loan is active
    //transfer tokens from user back to the contract

    //calc fee

    //send user's collateral minus fee

    //reset borrower's data

    //emit event
  }
}
```
---
- dbank-starter_kit/src/contracts/Token.sol
```js
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  address public minter; //add minter variable

  event MinterChanged(address indexed from, address to);//add minter changed event

  constructor() public payable ERC20("Decentralized Bank Currency", "DBC") {
    minter = msg.sender; //asign initial minter
  }

  function passMinterRole(address dBank) public returns (bool){
    require(msg.sender == minter, 'Error, only owner can change pass minter role');
    minter = dBank;
    emit MinterChanged(msg.sender, dBank);
    return true;
  }//Add pass minter role function

  function mint(address account, uint256 amount) public {
    require( msg.sender == minter, 'Error, msg.sender does not have minter role');//check if msg.sender have minter role
		_mint(account, amount);
	}
}
```
