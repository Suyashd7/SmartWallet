// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
contract consumer{
    function getBalance() public view returns(uint){
        return address(this).balance; 
 }
    function deposit() public payable {}
}
contract SmartWallet {
    address payable public owner;
    mapping(address=>uint) public allowance;
    mapping (address => bool) public isAllowToSend;

    mapping (address=>bool) public guardians;
    mapping (address => mapping (address=>bool)) public nextOwnerGuardisVotedBool;
    address payable nextOwner;
    uint guardianResetCount;
    uint public constant confirmFromGToReset = 3;

    constructor() {
        owner = payable(msg.sender);
    }

    function setGuardian(address _guardian,bool _isGuadian) public{
          require(msg.sender == owner,"You are not owner.");
          guardians[_guardian] = _isGuadian;
    }

    function proposeNewOwner (address payable _newOwner) public {
        require(guardians[msg.sender], "You are not a guardian.");
        require(nextOwnerGuardisVotedBool[_newOwner][msg.sender] == false,"You are already voted.");
        if(_newOwner != nextOwner){
            nextOwner = _newOwner;
            guardianResetCount = 0;
        }
        guardianResetCount+=1;
        if (guardianResetCount >= confirmFromGToReset){
            owner = nextOwner;
            nextOwner = payable (address(0));
        }
    }

    function setAllowance(address _for,uint _amount) public{
        require(msg.sender == owner,"You are not owner.");
        allowance[_for]= _amount;
        if(_amount>0){
            isAllowToSend[_for]=true;
        }else{
            isAllowToSend[_for]=false;
        }
    }

    function transfer(address payable _to,uint _amount, bytes memory _payload) public returns(bytes memory) {
        //require(msg.sender == owner,"Only owner can send");
        if(msg.sender != owner){
              require(isAllowToSend[msg.sender],"You are not allowed to send anything from this contract.");
            require(allowance[msg.sender]>=_amount,"Sending more than allowed.");
            allowance[msg.sender] -= _amount;
        }

        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success,"Call was not successfull");
        return returnData;
    }

    receive() external payable { }
}