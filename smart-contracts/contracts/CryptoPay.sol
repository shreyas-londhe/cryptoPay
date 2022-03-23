//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract CryptoPay {
    // Admin of the contract.
    address public admin;

    // Fee percent taken during each transaction.
    uint256 public feePercent;

    // Global MerchantID counter.
    uint256 public merchantID;

    // Struct to store Merchant details.
    struct Merchant {
        uint256 id;
        address merchant;
        address wallet;
        string name;
        uint256 balance;
    }

    // mapping to get Merchant details.
    mapping(uint256 => Merchant) public merchants;

    // only run once while deployment, initially setting admin and fee percent.
    constructor() {
        admin = msg.sender;
        feePercent = 25;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyMerchant(uint256 merchantId) {
        require(
            msg.sender == merchants[merchantId].merchant,
            "Only merchant can call this function"
        );
        _;
    }

    function setFeePercent(uint256 _feePercent) public onlyAdmin {
        feePercent = _feePercent;
    }

    function setAdmin(address _admin) public onlyAdmin {
        admin = _admin;
    }

    function createMerchant(
        string calldata _name,
        address _merchant,
        address _wallet
    ) public payable {
        require(
            msg.value == 0.001 ether,
            "Merchant creation requires 0.001 ether"
        );
        require(_merchant != address(0), "Merchant address cannot be 0");
        require(_wallet != address(0), "Wallet address cannot be 0");
        uint256 nextMerchantID = ++merchantID;
        require(
            merchants[nextMerchantID].merchant != address(0),
            "Merchant already exists"
        );

        merchants[nextMerchantID] = Merchant({
            id: nextMerchantID,
            merchant: _merchant,
            wallet: _wallet,
            name: _name,
            balance: msg.value
        });
    }
}
