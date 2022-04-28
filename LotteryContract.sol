//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    //dynamic array of players - we dont know how many players will be
    address payable[] public players;
    //manager deploys contract and pay the winner
    address public manager;

    constructor() {
        manager = msg.sender; 
    }

    //function receive : players must send 0.1ETH to access to lottery, and contract can reveive ETH
    receive() external payable {
        //require of every user to send fixed amount of 0.1ETH
        require(msg.value == 0.1 ether);
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        //only manager can see the balance of the contract
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint) {
        //generating random uint with functions keccak and abi.encod..
        return uint (keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }


    function pickWinner() public {
        require(msg.sender == manager);
        require(players.length >= 3);

        uint r = random();
        address payable winner;

        uint index = r % players.length;
        winner = players[index]; 

        winner.transfer(getBalance());
        //reseting lottery; '0' means size of dynamic array
        players = new address payable[](0);

        }


}