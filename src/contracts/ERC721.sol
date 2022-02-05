// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721{

    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownedTokensCount;

    constructor(){
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }

    function _exists(uint tokenId) internal view returns(bool){
        address owner = _tokenOwner[tokenId];

        return owner != address(0);
    }

    

    function balanceOf(address _owner) public view override returns(uint256){
        require(_owner != address(0), 'Error: Invalid address');

        return _ownedTokensCount[_owner];
    }

    
    function ownerOf(uint256 _tokenId) public view override returns(address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'Error: Invalid address');
        
        return owner;
    }

    function _mint(address to, uint256 tokenId) internal virtual{
        require(to > address(0), "Error: Invalid address");
        require(!_exists(tokenId));

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to]++;

        emit Transfer(address(0), to, tokenId);
    }

    
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal virtual{
        require(ownerOf(_tokenId) == _from, 'Error: That address doesnt have that NFT');
        require(_to != address(0) && _from != address(0), 'Error: Invalid address');

        _tokenOwner[_tokenId] = _to;
        _ownedTokensCount[_from]--;
        _ownedTokensCount[_to]++;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 tokenId) public override{
        _transferFrom(_from, _to, tokenId);
    }


}