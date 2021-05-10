//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PhotoToken is ERC721 {
    using Strings for uint256;

    mapping(uint256 => string) _tokenURIs;

    constructor() ERC721("PhotoToken", "PHOTO") {}

    function safeMint(
        address to,
        uint256 tokenId,
        string memory tokenUri
    ) public {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenUri);
    }

    function _safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public {
        safeTransferFrom(from, to, tokenId, data);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? _tokenURI(tokenId) : "";
    }

    function _tokenURI(uint256 tokenId) internal view returns (string memory) {
        return string(abi.encodePacked(_baseURI(), _tokenURIs[tokenId] ));
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        _tokenURIs[tokenId] = uri;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }
}
