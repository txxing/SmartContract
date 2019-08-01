pragma solidity ^0.4.24;

contract IdentityContract{
    address public Regulators=0x5a84833752634dce71a61898787a2d8d7d2b6324;
    
    mapping(address=>string) public Identity;
    
    modifier onlyRegulators(){
        require(msg.sender==Regulators);
        _;
    }
    function AddMerber(address Merber,string Type) onlyRegulators() public{
        if(keccak256(Type)==keccak256("M"))
        {
            Identity[Merber]="Merchant";
        }
        else if(keccak256(Type)==keccak256("L"))
        {
            Identity[Merber]="LogisticCompany";
        }
        else if(keccak256(Type)==keccak256("C"))
        {
            Identity[Merber]="Customer";
        }
    }
    function DeleteMerber(address Merber) onlyRegulators() public{
        Identity[Merber]="null";
    }
}
