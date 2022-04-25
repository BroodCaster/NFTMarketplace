// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import './ERC721Connector.sol';

contract NFTMarketplace is ERC721Connector {
    string [] public tokens;
    address [] bidders;
    address owner;

    event NftBought(address _seller, address _buyer, uint256 _price);
    event FeeTransfered(address owner, uint256 fee);
    event AuctionStarted(address seller, uint256 tokenId);
    event HighestBidIncrease(address bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 amount);

    struct Auction {
        address payable auctionSeller;

        bool onAuction;

        address highestBidder;

        uint256 highestBid;

        bool ended;

        mapping(address => uint256) bids;
    }

    mapping(uint256 => uint256) tokenIdToPrice;
    mapping(uint256 => Auction) tokenIdToAuction;
    mapping(string => bool)  tokensExist;

    constructor() ERC721Connector( 'NFTMarketplace', 'NFT'){
        owner = msg.sender;
    }

    // функция для создания NFT токена(в качестве параметра принимает ссылку на файл)
    function mint(string memory _token, uint256 _price) public returns(uint256){
        require(! tokensExist[_token], 'Error: That token already exists!');
        require(_price > 0, 'Price zero');
        tokens.push(_token);
        uint256 _id = tokens.length - 1;
        _mint(msg.sender, _id);
        tokensExist[_token] = true;
        tokenIdToPrice[_id] = _price;
        return _id;
    }

    function mintAuction(string memory _token, uint256 _min_bid) public returns(uint256){
        require(! tokensExist[_token], "Error: That token already exists!");
        require(_min_bid > 0, "Price zero");
        tokens.push(_token);
        uint256 _id = tokens.length - 1;
        _mint(msg.sender, _id);
        tokensExist[_token] = true;
        tokenIdToPrice[_id] = _min_bid;

        startAuction(_id);
        return _id;
    }


    function getPrice(uint256 _tokenId) external view returns(uint256){
        require(_exists(_tokenId), "Error: That token doesn't exist!");
        if(tokenIdToPrice[_tokenId] > 0){
        return tokenIdToPrice[_tokenId];
        }else{
            return 0;
        }
    }

    function allowBuy(uint256 _tokenId, uint256 _price) external {
        require(msg.sender == ownerOf(_tokenId), 'Not owner of this token');
        require(_price > 0, 'Price zero');
        tokenIdToPrice[_tokenId] = _price;
    }

    function buy(uint256 _tokenId) external payable {
        uint256 price = tokenIdToPrice[_tokenId];

        require(price > 0, "This token is not for sale");
        require(msg.sender != ownerOf(_tokenId), "You can't buy your token");

        uint256 fee = msg.value - price;
        address seller = ownerOf(_tokenId);
        _transfer(seller, msg.sender, _tokenId);
        tokenIdToPrice[_tokenId] = 0; 
        payable(seller).transfer(msg.value - fee);
        emit NftBought(seller, msg.sender, msg.value);
        payable(owner).transfer(fee);
        emit FeeTransfered(owner, msg.value);       
    }

    function startAuction(uint256 _tokenId) internal {
        require(msg.sender == ownerOf(_tokenId), "You are not owner of this token!");
    
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(!auction.onAuction, "That token already on auction");
        
        address seller = ownerOf(_tokenId);
        
        auction.auctionSeller = payable(seller);
        auction.highestBidder = address(0);
        auction.highestBid =  0;
        auction.onAuction = true;
        auction.ended = false;

        emit AuctionStarted(auction.auctionSeller, _tokenId);
    }

    function bid(uint256 _tokenId) external payable{
        Auction storage auction = tokenIdToAuction[_tokenId];

        require(msg.sender != ownerOf(_tokenId), "You cannot bid on your product");
        require(auction.onAuction, "This token is not up for auction ");
        require(msg.value > 0, "The bid cannot be zero");

        auction.bids[msg.sender] += msg.value;
        if(auction.bids[msg.sender] < auction.highestBid){
            auction.bids[msg.sender] -= msg.value;
            revert("There is already a higher or equal bid!");
        }
        
        auction.highestBidder = msg.sender;
        auction.highestBid = auction.bids[msg.sender];
        tokenIdToPrice[_tokenId] = auction.highestBid;

        bidders.push(auction.highestBidder);
        emit HighestBidIncrease(msg.sender, msg.value);
    }

    function withdraw(uint256 _tokenId) internal{
        Auction storage auction = tokenIdToAuction[_tokenId];
        uint256 amount;

        for(uint128 i = 0; i < bidders.length; i++){
            amount = auction.bids[bidders[i]];
            auction.bids[bidders[i]] = 0;
                if(!payable(bidders[i]).send(amount)){
                    auction.bids[bidders[i]] = amount;
                }
        }
    }

    function auctionEnd(uint256 _tokenId) external {
        require(msg.sender == owner, "Only marketplace owner can close auction!");
        Auction storage auction = tokenIdToAuction[_tokenId]; 

        if(auction.highestBidder == address(0)){
            revert("Auction ended without any bid");
        }

        if(auction.ended){
            revert("The auction has already ended");
        }

        auction.ended = true;
        auction.onAuction = false;
        emit AuctionEnded(auction.highestBidder, auction.highestBid);
        address payable seller = auction.auctionSeller;
        seller.transfer(auction.highestBid);
        auction.bids[auction.highestBidder] = 0;
        _transfer(seller, auction.highestBidder, _tokenId);
        withdraw(_tokenId);
    }


}