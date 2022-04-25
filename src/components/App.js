import React, {useEffect, useState} from 'react';
import {mintToken, getBalance, init, totalSupply, ownerOf, payEther, callPrice, startAuction, bid, auctionEnd} from './web3.js';

function App(){
    const [balance, setBalance] = useState(0);
    const [data, setData] = useState(null);
    const [supply, setSupply] = useState(0);
    const [id, setId] = useState(0);
    const [owner, setOwner] = useState(null);
    const [transfered, setTransfered] = useState(false);
    const [_id, _setId] = useState(0);
    const [price, setPrice] = useState(0);

    useEffect (() =>{
        init();
        callTotalSupply();
    });

    const getData = (val) =>{
        setData(val.target.value)
    }

    const getPrice = (val) =>{
        setPrice(val.target.value)
    }

    const getId = (val) =>{
        setId(val.target.value)
    }

    const _getId = (val) =>{
        _setId(val.target.value)
    }

    const callTotalSupply = () =>{
        totalSupply()
                .then((supply) =>{
                    setSupply(supply);
                })
                .catch((err) =>{
                    console.log(err)
                })
    }

    const callOwnerOf = (id) =>{
        ownerOf(id)
                .then((address) =>{
                    setOwner(address);
                })
                .catch((err) =>{
                    console.log(err)
                    setOwner("Invalid address");
                })
    }

     const mint = (data, price) =>{
	 	mintToken(data, price)
	 		.then((tx) => {
	 			console.log(tx);
	 		})
	 		.catch((err) => {
	 			console.log(err);
                 window.alert("Please connect to MetaMask!");

			});
	 };

     const callBalance = () => {
        getBalance()
			.then((balance) => {
				setBalance(balance);
			})
			.catch((err) => {
				console.log(err);
                window.alert("Please connect to MetaMask!");
			});

    };

    const buyNFT = (_id) => {
       
        payEther(_id)
            .then((result) =>{
                //setTransfered(result);
                console.log(result);
            })
            .catch((err)=>{
                console.log(err);
            });
    };

    const showPrice = (id) =>{
        callPrice(id)
            .then((result) =>{
                
                console.log(result);
            })
            .catch((err)=>{
                console.log(err);
            });
    }

    const auction = (data, id) =>{
        startAuction(data, id)
            .then((result) =>{
                console.log(result);
            })
            .catch((err)=>{
                console.log(err);
            });
    }

    const placeBid = (price, id) =>{
        bid(price, id)
            .then((result) =>{
                console.log(result);
            })
            .catch((err)=>{
                console.log(err);
            });
    }

    const closeAuction = (id) =>{
        auctionEnd(id)
            .then((result) =>{
                console.log(result);
            })
            .catch((err)=>{
                console.log(err);
            });
    }



    

    return <div className = "App">
        <form>
            <label>
                <input type = "text" onChange={getData}/>
            </label>
        </form>
        <form>
            <label>
                <input type = "text" onChange={getPrice}/>
            </label>
        </form>
        <button onClick={() => mint(data, price)}>Mint Token</button>
        <p>Create a token</p>
        <p>Your balance: {balance}</p>
        <button onClick={() => callBalance()}>Balance</button>
        <p>Total supply: {supply}</p>
        <p>Owner of token: {owner}</p>
        <form>
            <label>
                <input type = "text" onChange={getId}/>
            </label>
        </form>
        <button onClick={() => callOwnerOf(id)}>Find Owner</button>
        <p>Buy token #{_id}!</p>
        <form>
            <label>
                <input type = "text" onChange={_getId}/>
            </label>
        </form>
        {!transfered ?(
            <button onClick={() => buyNFT(_id)}>Buy now!</button>       
        ):(
            <p>You successfully bought an NFT!</p>
        )
        }
        <p>Price is: {price}</p>
        <form>
            <label>
                <input type = "text" onChange={getId}/>
            </label>
        </form>
        <button onClick={() => showPrice(id)}>Buy now!</button> 
        <p>Type auction name and token min bid</p>
        <label>
            <input type = "text" onChange={getData}/>
        </label>
        <label>
           <input type = "text" onChange={getId}/>
        </label>
        <button onClick={() => auction(data, id)}>Start auction</button>
        <form>
            <label>
                <input type = "text" onChange={getPrice}/>
            </label>
            <label>
                <input type = "text" onChange={_getId}/>
            </label>
        </form>
        <button onClick={() => placeBid(price, _id)}>Place a bid</button>   
        <form> 
        <label>
                <input type = "text" onChange={getId}/>
            </label>
        </form>   
        <button onClick={() => closeAuction(_id)}>Close the auction</button>

    </div>;
}

export default App;