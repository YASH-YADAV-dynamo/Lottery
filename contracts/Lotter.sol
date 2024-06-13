// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    // three roles are there- players,manager,winner
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor(){
        manager=msg.sender;
    }

    function participate () public payable{
        require(msg.value ==1 ether,"Please pay 1 ether to enter Lottery");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require (manager ==msg.sender,"You are not allowed to access this information");
        return address(this).balance;
    }

    function random() internal view returns(uint){
        return(uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length))));
    }

    function pickWinner() public{
        require(manager ==msg.sender, "You don't have access , you are not manager");
        require(players.length>=2,"we need minimum 2 players to get started");

        uint r =random();
        uint index = r%players.length;
        winner=players[index];
        winner.transfer(getBalance());
        players = new address payable [] (0);
        // above statement will set players array back to zero, to start again
    }
}