//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

contract Pravda {

    struct Post {
        uint256 timestamp;
        string text;
        string img;
    }

    struct User {
        string username;
        Post[] posts;
    }

    mapping(address => User) public users;
    mapping(string => address) public addressByUsername;

    event PostCreated(address indexed userAddress, string text, string img, uint256 timestamp);

    function createPost(string memory _text, string memory _img) public {
        Post memory newPost = Post(block.timestamp, _text, _img);
        users[msg.sender].posts.push(newPost);
        emit PostCreated(msg.sender, _text, _img, block.timestamp);
    }

    function setUsername(string memory _username) public {
        require(bytes(_username).length > 0, "Username cannot be empty");
        require(addressByUsername[_username] == address(0), "Username is already taken");
        addressByUsername[_username] = msg.sender;
        users[msg.sender].username = _username;
    }

    function getPostsByUser(string memory _username) public view returns (Post[] memory) {
        address userAddress = addressByUsername[_username];
        require(userAddress != address(0), "User does not exist");
        return users[userAddress].posts;
    }

}
