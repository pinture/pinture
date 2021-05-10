//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UsageRightToken is ERC721, Ownable {
    using Address for address;
    using Strings for uint256;

    address private photoTokenAddr;

    mapping(uint256 => UsageRightTokenInfo) private _usageRightsIdToInfo;
    mapping(uint256 => string) _tokenURIs;

    event Mint(address, uint256, uint256, uint64, uint64, uint256);
    event SetPhotoTokenAddress(address _photoTokenAddr);

    constructor(address _photoTokenAddr) ERC721("UsageRightsToken", "URT") {
        setPhotoTokenAddress(_photoTokenAddr);
    }

    struct UsageRightTokenInfo {
        uint256 photoTokenId;
        uint256 quantity;
        uint64 startTime;
        uint64 endTime;
        bool isValid;
    }

    modifier checkOwnerOfPhotoToken(address _to, uint256 _photoTokenId) {
        address ownerAddr = _checkOwnerOfPhotoToken(_photoTokenId);
        require(ownerAddr == _to, "Token owner must be the same address.");
        _;
    }

    function _checkOwnerOfPhotoToken(uint256 _photoTokenId) internal returns (address) {
        (, bytes memory data) = photoTokenAddr.call(abi.encodeWithSignature("ownerOf(uint256)", _photoTokenId));
        address owner = bytesToAddress(data);
        return (owner);
    }

    function setPhotoTokenAddress(address _addr) public onlyOwner {
        require(_addr != address(0), "address is empty");
        photoTokenAddr = _addr;

        emit SetPhotoTokenAddress(_addr);
    }

    function getPhotoTokenAddress() public view returns (address) {
        return photoTokenAddr;
    }

    function getPhotoTokenId(uint256 _usageRightsTokenId) public view returns (uint256) {
        return _usageRightsIdToInfo[_usageRightsTokenId].photoTokenId;
    }

    function getUsageRightsTokenInfo(uint256 _usageRightsTokenId)
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
        UsageRightTokenInfo memory p = _usageRightsIdToInfo[_usageRightsTokenId];

        return (p.photoTokenId, p.quantity, p.startTime, p.endTime, p.isValid);
    }

    function safeMint(
        address _to,
        uint256 _photoTokenId,
        uint256 _usageRightTokenId,
        uint64 _startTime,
        uint64 _endTime,
        uint256 _quantity,
        string memory tokenUri
    ) public checkOwnerOfPhotoToken(_to, _photoTokenId) {
        _safeMint(_to, _usageRightTokenId);
        _setTokenURI(_usageRightTokenId, tokenUri);

        _usageRightsIdToInfo[_usageRightTokenId] = UsageRightTokenInfo({
            photoTokenId: _photoTokenId,
            startTime: _startTime,
            endTime: _endTime,
            quantity: _quantity,
            isValid: true
        });

        emit Mint(_to, _photoTokenId, _usageRightTokenId, _startTime, _endTime, _quantity);
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
