// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Pinture {
    IERC721 private _token;

    address private licenseTokenAddr;

    mapping(uint256 => uint256) private _tokenIdToPrice;
    mapping(uint256 => uint256) private _allTokensIndex;

    uint256[] private _allTokens;

    event Buy(uint256 tokenId, address buyer, uint256 price);
    event SetPrice(address owner, uint256 tokenId, uint256 price);
    event Cancel(uint256 tokenId);

    constructor(IERC721 licenseToken) {
        _token = licenseToken;
    }

    // dont use!
    function getListedTokens() public view returns (uint256[] memory) {
        return _allTokens;
    }

    function setPrice(uint256 tokenId, uint256 price) public _checkApproval(tokenId) {
        if (_tokenIdToPrice[tokenId] == 0) {
            _allTokensIndex[tokenId] = _allTokens.length;
            _allTokens.push(tokenId);
        }
        
        _tokenIdToPrice[tokenId] = price;

        emit SetPrice(msg.sender, tokenId, price);
    }

    function getPrice(uint256 tokenId) public view returns (uint256) {
        return _tokenIdToPrice[tokenId];
    }

    function cancel(uint256 tokenId) public _checkApproval(tokenId) {
        require(_token.ownerOf(tokenId) == msg.sender, "You are not the owner of the token.");
        delete _tokenIdToPrice[tokenId];

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId;
        _allTokensIndex[lastTokenId] = tokenIndex;

        delete _allTokensIndex[tokenId];
        _allTokens.pop();

        emit Cancel(tokenId);
    }

    function buy(uint256 tokenId) external payable _checkApproval(tokenId) {
        require(_tokenIdToPrice[tokenId] == msg.value, "The given ether is not matching the price");

        address ownerOfToken = _token.ownerOf(tokenId);

        _token.safeTransferFrom(ownerOfToken, msg.sender, tokenId);
        emit Buy(tokenId, msg.sender, msg.value);
    }

    modifier _checkApproval(uint256 tokenId) {
        require(address(this) == _token.getApproved(tokenId), "This token haven't been approved for Pinture yet.");
        _;
    }
}
