import Web3 from 'web3';
import Eth from 'web3-eth'
import NFTMarketplace from "../abis/NFTMarketplace.json";

let selectedAccount;
let erc721token;
let isInitialized = false;
let web3;
let address;
let metaMaskInstalled;

export const init = async () => {
    let provider = window.ethereum;

	if (typeof provider !== 'undefined') {
		try{
		    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            selectedAccount = accounts[0];
            console.log(`Selected account is ${selectedAccount}`);
            metaMaskInstalled = true;
		}catch(error){
		    if (error.code === 4001) {
                console.log("User rejected request")
                 //window.location.href = "https://nft.howsimpl.com/user/dashboard";
                
          }
          console.log(error);
		}
			

		window.ethereum.on('accountsChanged', function (accounts) {
			selectedAccount = accounts[0];
			if(typeof selectedAccount == "undefined"){
			    //window.location.href = "https://nft.howsimpl.com/user/dashboard";
			}
			console.log(`Selected account changed to ${selectedAccount}`);
			
		});
        web3 = new Web3(provider);
        address = NFTMarketplace.networks['4'].address;
        erc721token = new web3.eth.Contract(NFTMarketplace.abi, address)
        isInitialized = true;

    }
};

export const mintToken = async (data, price) =>{
    if(!isInitialized){
        await init();
    }
    let txHash = null;
    let token_id = 0;
    let eth_wei = web3.utils.toWei(price, 'ether');    
    

   

    try {
        txHash = await erc721token.methods.mint(data, eth_wei).send({from: selectedAccount}).then((res)=>{
            return res['transactionHash'];
        });
        console.log(txHash)
        }catch(error){
                console.log(error);
                if (error.code === 4001) {
                     window.alert("You just denied transaction!");
                }
            }
        let receipt = await web3.eth.getTransactionReceipt(txHash)
            .then(function (result) {
                return result
            });
        let topics = receipt['logs'][0]['topics'];
        let tokenIdHex = topics[3].toString(10);
        token_id = parseInt(tokenIdHex, 16)
        return {'Hash': txHash, 'TokenID': token_id, 'Price': price};
    
};

export const getBalance = async () =>{
    if(!isInitialized){
        await init()
    }
    return erc721token.methods.balanceOf(selectedAccount).call();
}

export const totalSupply = async () =>{
    if(!isInitialized){
        await init()
    }
    return erc721token.methods.totalSupply().call();
}

export const ownerOf = async (id) =>{
    if(!isInitialized){
        await init()
    }
    return erc721token.methods.ownerOf(id).call();
}

export const payEther = async (_id) =>{
    if(!isInitialized){
        await init()
    }
    
    if(metaMaskInstalled){
    let price = await erc721token.methods.getPrice(_id).call();
    console.log(price);
    let pay = (price*102)/100;

    if (selectedAccount != null) {
        let txHash;
        try {
            
            txHash = await erc721token.methods.buy(_id).send({
                from: selectedAccount,
                value: pay 
              });
            console.log(txHash) 
        } catch (error) {
            console.log(error.code)
            console.log(error)
        }
        return txHash;
    }
    }else{
        init()
    }
}

export const startAuction = async (name, price) =>{
    if(!isInitialized){
        await init()
    }
        if(metaMaskInstalled){
            if (selectedAccount != null) {
                let txHash;
                try {
                    
                    txHash = await erc721token.methods.mintAuction(name, price).send({
                        from: selectedAccount
                      });
                    console.log(txHash) 
                } catch (error) {
                    console.log(error)
                }
                return txHash;
            }
        }else{
            window.alert("Please install MetaMask!")
        }
}

export const bid = async (amount, _id) =>{
    if(!isInitialized){
        await init()
    }
    let eth_wei = web3.utils.toWei(amount, 'ether');   
        if(metaMaskInstalled){
            if (selectedAccount != null) {
                let txHash;
                try {
                    
                    txHash = await erc721token.methods.bid(_id).send({
                        from: selectedAccount,
                        value: eth_wei
                      });
                    console.log(txHash) 
                } catch (error) {
                    console.log(error)
                }
                return txHash;
            }
        }else{
            window.alert("Please install MetaMask!")
        }
}

export const auctionEnd = async(_id) =>{
    if(!isInitialized){
        await init()
    }
    const tx = {
    from: selectedAccount,
    to: address,
    gas: 200000,
    data: erc721token.methods.auctionEnd(_id).encodeABI()
    }
    const account = web3.eth.accounts.privateKeyToAccount(privateKey);
    console.log(account);
    web3.eth.getBalance(selectedAccount).then(console.log);
        if(metaMaskInstalled){
            if (selectedAccount != null) {
                try {
                    web3.eth.accounts.signTransaction(tx, privateKey).then(signed => {
                        const tran = web3.eth
                          .sendSignedTransaction(signed.rawTransaction)
                          .on('transactionHash', hash => {
                            console.log(hash);
                          })
                          .on('receipt', receipt => {
                            console.log('=> reciept');
                            console.log(receipt);
                          })
                          .on('error', console.error);
                      });
                } catch (error) {
                    console.log(error)
                }
            }
        }else{
            window.alert("Please install MetaMask!")
        }
}

export const callPrice = async (tokenID) =>{
    if(!isInitialized){
       await init()
   }
   
   return erc721token.methods.getPrice(tokenID).call();
 
}