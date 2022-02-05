// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC721{
 
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    // фунция которая показывает баланс NFT на аккаунте(в качестве параметра принимает адресс)
    function balanceOf(address _owner) external view returns (uint256);

    // функция показывает адресс который владеет NFT(ID токена указывается в параметре)
    function ownerOf(uint256 _tokenId) external view returns (address);

    // функция которая отвечает за передачу владением NFT(принимает в качестве параметра
    // адресс который владеет токеном, адресс нового владельца и ID токена)
    function transferFrom(address _from, address _to, uint256 _tokenId) external;

}