# weekly43
kubernetes, typescript, react


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

