
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
step19 web3-migrate-blockchain:
	cd dbank-starter_kit; truffle migrage --reset

	


