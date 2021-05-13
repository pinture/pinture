//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract PictureToken is ERC721Enumerable {
    using Strings for uint256;

    mapping(uint256 => string) private _tokenURIs;

    constructor() ERC721("PictureToken", "PIC") {}

    function safeMint(
        address to,
        string memory tokenUri
    ) public {
        uint64 tokenId = uint64(bytes8(keccak256(abi.encodePacked( tokenUri ))));
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenUri);
    }
 
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
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
