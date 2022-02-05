// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is ERC721, IERC721Enumerable{
    uint256 [] private _allTokens;
    uint256 [] private _ownerTokens;

    mapping(uint256 => uint256) private _allTokensId;
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;
 
    constructor(){
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    // функция которая возвращает количество всех созданных токенов
    function totalSupply() public view override returns (uint256){
        return _allTokens.length;
    }

    // функция которая возвращает ID токена
    function tokenByIndex(uint256 _index) public view override returns (uint256){
        require(_index < totalSupply(), 'Error: That index doesnt exist');
        return _allTokens[_index];
    }

    
    // функция которая возвращает ID токена находя его по индексу среди токенов владельца(в качестве 
    // параметра принимает адресс владельца и индекс токена)
    function tokenOfOwnerByIndex(address owner, uint256 index) external view override returns (uint256){
        require(owner != address(0), 'Error: Invalid address');
        require(index < balanceOf(owner), 'Error: That address doesnt have this token');
        
        return _ownedTokens[owner][index];
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721){
        super._mint(to, tokenId);

        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(tokenId, to);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal override(ERC721) {
        super._transferFrom(_from, _to, _tokenId);
        _addTokensToOwnerEnumeration(_tokenId, _to);
    }

    function _addTokensToOwnerEnumeration(uint256 tokenId, address to) private{
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;

    }

    function _addTokensToAllTokenEnumeration(uint256 tokenId) private{
        _allTokensId[tokenId] = _allTokens.length;
         _allTokens.push(tokenId);
    }
    
}

