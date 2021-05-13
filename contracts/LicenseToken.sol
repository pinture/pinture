//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LicenseToken is ERC721Enumerable, Ownable {
    using Address for address;
    using Strings for uint256;

    address private pictureTokenAddr;

    mapping(uint256 => LicenseTokenInfo) private _licenseIdToInfo;
    mapping(uint256 => string) private _tokenURIs;

    event Mint(address, uint256, uint256, uint64, uint64, uint256);
    event SetPictureTokenAddress(address _pictureTokenAddr);

    constructor(address _pictureTokenAddr) ERC721("LicenseToken", "LIC") {
        setPictureTokenAddress(_pictureTokenAddr);
    }

    struct LicenseTokenInfo {
        uint256 pictureTokenId;
        uint256 quantity;
        uint64 startTime;
        uint64 endTime;
        bool isValid;
    }

    modifier checkOwnerOfPictureToken(address _to, uint256 _pictureTokenId) {
        address ownerAddr = _checkOwnerOfPictureToken(_pictureTokenId);
        require(ownerAddr == _to, "Token owner must be the same address.");
        _;
    }

    function _checkOwnerOfPictureToken(uint256 _pictureTokenId) internal returns (address) {
        (, bytes memory data) = pictureTokenAddr.call(abi.encodeWithSignature("ownerOf(uint256)", _pictureTokenId));
        address ownerOfPic = bytesToAddress(data);
        return ownerOfPic;
    }

    function setPictureTokenAddress(address _addr) public onlyOwner {
        require(_addr != address(0), "address is empty");
        pictureTokenAddr = _addr;

        emit SetPictureTokenAddress(_addr);
    }

    function getPictureTokenAddress() public view returns (address) {
        return pictureTokenAddr;
    }

    function getPictureTokenId(uint256 _licenseTokenId) public view returns (uint256) {
        return _licenseIdToInfo[_licenseTokenId].pictureTokenId;
    }

    function getLicenseTokenInfo(uint256 _licenseTokenId)
        public
        view
        returns (
            uint256,
            uint256,
            uint64,
            uint64,
            bool
        )
    {
        LicenseTokenInfo memory p = _licenseIdToInfo[_licenseTokenId];

        return (p.pictureTokenId, p.quantity, p.startTime, p.endTime, p.isValid);
    }

    function safeMint(
        address _to,
        uint256 _pictureTokenId,
        uint256 _licenseTokenId,
        uint64 _startTime,
        uint64 _endTime,
        uint256 _quantity,
        string memory tokenUri
    ) public checkOwnerOfPictureToken(_to, _pictureTokenId) {
        // _beforeTokenTransfer(address(0), _to, _licenseTokenId);
        _safeMint(_to, _licenseTokenId);
        _setTokenURI(_licenseTokenId, tokenUri);

        _licenseIdToInfo[_licenseTokenId] = LicenseTokenInfo({
            pictureTokenId: _pictureTokenId,
            startTime: _startTime,
            endTime: _endTime,
            quantity: _quantity,
            isValid: true
        });

        emit Mint(_to, _pictureTokenId, _licenseTokenId, _startTime, _endTime, _quantity);
    }
    
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        _beforeTokenTransfer(from, to, tokenId);
        safeTransferFrom(from, to, tokenId, "");
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? _tokenURI(tokenId) : "";
    }

    function _tokenURI(uint256 tokenId) internal view returns (string memory) {
        return string(abi.encodePacked(_baseURI(), _tokenURIs[tokenId]));
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        _tokenURIs[tokenId] = uri;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function bytesToAddress(bytes memory bys) public pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 32))
        }
    }
}
