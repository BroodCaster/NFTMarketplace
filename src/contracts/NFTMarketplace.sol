// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import './ERC721Connector.sol';

contract NFTMarketplace is ERC721Connector {
    string [] public tokens;

    mapping(string => bool)  tokensExist;

    constructor() ERC721Connector( 'NFTMarketplace', 'NFT'){

    }

    // функция для создания NFT токена(в качестве параметра принимает ссылку на файл)
    function mint(string memory _token) public {
        require(! tokensExist[_token], 'Error: That KryptoBird already exists!');

     tokens.push(_token);
        uint256 _id = tokens.length - 1;
        _mint(msg.sender, _id);
         tokensExist[_token] = true;
    }
   
}