// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165{

    mapping(bytes4 => bool) private _supportedInterface;

    constructor(){
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
    }

    function supportsInterface(bytes4 interfaceID) public view override returns (bool){
        return _supportedInterface[interfaceID];
    }

    function _registerInterface(bytes4 interfaceID) internal{
        require(interfaceID != 0xffffffff, "Invalid interface request");
        _supportedInterface[interfaceID] = true;
    }

}