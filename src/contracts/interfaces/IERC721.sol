// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC721{
 
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _from, address indexed _to, bool indexed _approved);

    // фунция которая показывает баланс NFT на аккаунте(в качестве параметра принимает адресс)
    function balanceOf(address _owner) external view returns (uint256);

    // функция показывает адресс который владеет NFT(ID токена указывается в параметре)
    function ownerOf(uint256 _tokenId) external view returns (address);

    // функция которая отвечает за передачу владением NFT(принимает в качестве параметра
    // адресс который владеет токеном, адресс нового владельца и ID токена)
    function transferFrom(address _from, address _to, uint256 _tokenId) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator) external view returns (bool);

     function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}