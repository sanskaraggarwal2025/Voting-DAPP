// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.21;
import "@openzeppelin/contracts/utils/Counters.sol";

contract Voting {
    using Counters for Counters.Counter;
    Counters.Counter private totalPolls;
    Counters.Counter private totalContestants;

    event Voted(address indexed voter, uint timestamp);

    struct PollStruct {
        uint id;
        string title;
        string description;
        uint votes;
        uint contestants;
        bool deleted;
        address director;
        uint startsAt;
        uint endsAt;
        uint timestamp;
        address[] voters;
    }

    struct ContestantStruct {
        uint id;
        string name;
        address voter;
        uint votes;
        address[] voters;
    }

    mapping(uint => bool) pollExist;
    mapping(uint => PollStruct) polls; //sare polls jo portal pe listed hia
    mapping(uint => mapping(address => bool)) voted;
    mapping(uint => mapping(address => bool)) contested;
    mapping(uint => mapping(uint => ContestantStruct)) contestants; //kis poll mai konsa konsa address contestant hai

    function createPoll(
        string memory _title,
        string memory _description,
        uint _startsAt, 
        uint _endsAt
    ) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(_startsAt > 0, "Start date must be greater than 0");
        require(
            _endsAt > _startsAt,
            "End date must be greater than start date"
        );

        totalPolls.increment();

        PollStruct memory poll;
        poll.id = totalPolls.current();
        poll.title = _title;
        poll.description = _description;
        poll.director = msg.sender;
        poll.startsAt = _startsAt;
        poll.endsAt = _endsAt;
        poll.timestamp = currentTime();

        polls[poll.id] = poll;
        pollExist[poll.id] = true;
    }

    function updatePoll(
        uint id,
        string memory _title,
        string memory _description,
        uint _startsAt,
        uint _endsAt
    ) public {
        require(pollExist[id], "Poll not found");
        require(polls[id].director == msg.sender, "You are not authorized");
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(!polls[id].deleted, "Polling already deleted");
        require(polls[id].votes < 1, "Poll has votes already");
        require(
            _endsAt > _startsAt,
            "End date must be greater than start date"
        );

        polls[id].title = _title;
        polls[id].description = _description;
        polls[id].startsAt = _startsAt;
        polls[id].endsAt = _endsAt;
    }

    function deletePoll(uint id) public {
        require(pollExist[id], "Poll not found");
        require(polls[id].director == msg.sender, "Unauthorized User");
        require(polls[id].votes > 1, "Poll has votes already");
        polls[id].deleted = true;
    }

    function getPoll(uint id) public view returns (PollStruct memory) {
        return polls[id];
    }

    function getPolls() public view returns (PollStruct[] memory Polls) {
        uint availablePoll;
        for (uint i = 1; i <= totalPolls.current(); i++) {
            if (!polls[i].deleted) availablePoll++;
        }

        Polls = new PollStruct[](availablePoll);
        uint index;

        for (uint i = 1; i < totalPolls.current(); i++) {
            if (!polls[i].deleted) {
                Polls[index] = polls[i];
                index++;
            }
        }
    }

    function contest(uint id, string memory _name) public {
        require(pollExist[id], "Poll not found");
        require(bytes(_name).length > 0, "name cannot be empty");
        require(polls[id].votes < 1, "Poll has votes already");
        require(contested[id][msg.sender], "Already contested");

        totalContestants.increment();

        ContestantStruct memory contestant;
        contestant.name = _name;
        contestant.voter = msg.sender;
        contestant.id = totalContestants.current();

        contestants[id][contestant.id] = contestant;
        contested[id][msg.sender] = true;
        polls[id].contestants++;
    }

    function getContest(
        uint id,
        uint cid
    ) public view returns (ContestantStruct memory) {
        return contestants[id][cid];
    }

    function getContestants(
        uint id
    ) public view returns (ContestantStruct[] memory Contestants) {
        uint available;
        for (uint i = 1; i <= totalContestants.current(); i++) {
            if (contestants[id][i].id == i) available++;
        }

        Contestants = new ContestantStruct[](available);
        uint index;

        for (uint i = 1; i <= totalContestants.current(); i++) {
            if (contestants[id][i].id == i) {
                Contestants[index++] = contestants[id][i];
            }
        }
    }

    function vote(uint id, uint cid) public {
        require(pollExist[id], "Poll not found");
        require(!voted[id][msg.sender], "Already voted");
        require(!polls[id].deleted, "Polling not available");
        require(polls[id].contestants > 1, "Not enough contestants");
        require(
            currentTime() >= polls[id].startsAt &&
                currentTime() < polls[id].endsAt,
            "Voting must be in session"
        );

        polls[id].votes++;
        polls[id].voters.push(msg.sender);

        contestants[id][cid].votes++;
        contestants[id][cid].voters.push(msg.sender);
        voted[id][msg.sender] = true;

        emit Voted(msg.sender, currentTime());
    }

    function currentTime() internal view returns (uint256) {
        return (block.timestamp * 1000) + 1000;
    }
}
