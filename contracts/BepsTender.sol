// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract BepsTender {
    mapping(uint256 => mapping(address => bool)) public tenderApplicantsMapping;
    mapping(uint256 => address[]) public tenderApplicants;
    mapping(address => TenderTerm[]) public tendersByUser;

    TenderTerm[] public tenders;

    struct TenderTerm {
        uint256 tenderId;
        string title;
        string description;
        string specifications;
        string materialType;
        uint256 budget;
        uint256 quantity;
        uint256 deadline;
        address owner;
        address supplier;
    }

    event NewTender(
        uint256 indexed tenderId,
        string title,
        string description,
        string specifications,
        string materialType,
        uint256 budget,
        uint256 quantity,
        uint256 deadline
    );

    event AppliedToTender(
        uint256 indexed _tenderId,
        address indexed _applicant
    );

    event SupplierPicked(uint256 indexed _tenderId, address indexed _supplier);

    function getTenders() public view returns (TenderTerm[] memory) {
        return tenders;
    }

    function getUserTenders(
        address _user
    ) public view returns (TenderTerm[] memory) {
        return tendersByUser[_user];
    }

    function createTender(
        string calldata _title,
        string calldata _description,
        string calldata _specifications,
        string calldata _materialType,
        uint256 _budget,
        uint256 _quantity,
        uint256 _deadline
    ) external {
        require(
            _deadline > block.timestamp,
            "Deadline must be greater than current date"
        );

        uint256 tenderId = tenders.length;

        TenderTerm memory tender = TenderTerm(
            tenderId,
            _title,
            _description,
            _specifications,
            _materialType,
            _budget,
            _quantity,
            _deadline,
            msg.sender,
            address(0)
        );

        tenders.push(tender);
        tendersByUser[msg.sender].push(tender);

        emit NewTender(
            tenderId,
            _title,
            _description,
            _specifications,
            _materialType,
            _budget,
            _quantity,
            _deadline
        );
    }

    function applyForTender(uint256 _tenderId) external {
        require(_tenderId < tenders.length, "Tender does not exist");
        require(msg.sender != tenders[_tenderId].owner, "Owner cannot apply");
        require(
            !tenderApplicantsMapping[_tenderId][msg.sender],
            "Already applied"
        );
        require(
            tenders[_tenderId].deadline > block.timestamp,
            "Deadline passed"
        );
        require(
            tenders[_tenderId].supplier == address(0),
            "Tender already awarded"
        );

        tenderApplicantsMapping[_tenderId][msg.sender] = true;
        tenderApplicants[_tenderId].push(msg.sender);

        emit AppliedToTender(_tenderId, msg.sender);
    }

    function pickSupplier(uint256 _tenderId, address _supplier) external {
        require(_tenderId < tenders.length, "Tender does not exist");
        require(
            tenders[_tenderId].owner == msg.sender,
            "You are not the owner"
        );
        require(
            tenders[_tenderId].supplier == address(0),
            "Supplier already picked"
        );
        require(
            tenderApplicantsMapping[_tenderId][_supplier],
            "Invalid supplier"
        );
        require(
            tenders[_tenderId].deadline > block.timestamp,
            "Deadline passed"
        );

        tenders[_tenderId].supplier = _supplier;

        emit SupplierPicked(_tenderId, _supplier);
    }
}
