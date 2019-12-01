--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: Dr. Haeyong Chung
--Due Date: December 1, 2019
--File Name: Account.lua
--Description:	Represents the player's account. Used as an interface
--				with the server and stores account information.
--Note: For the actual app, the Server class functions
--		would be replaced with networking code.

--Libraries
local json = require("json")
local FileUtility = require("FileUtility")
local Server = require("Server")

--Account file save location
local accountFile = "Account.dat"

--Create account object
Account = {}

--Gets the account data from file (if exists)
Account.accountData = FileUtility.loadTable(accountFile)

--Returns the player's username
function Account.getUsername()
	return Account.accountData.username
end

--Returns the player's display name
function Account.getDisplayName()
	return Account.accountData.displayName
end

--Retrieves and updates account 
function Account.refreshData()
	local data = Server.getAccountData(Account.accountData.token)
	if(data ~= nil) then
		Account.accountData.displayName = data.displayName
		Account.accountData.currentGame = data.currentGame
		Account.accountData.wins = data.wins
		Account.accountData.losses = data.losses
		FileUtility.saveTable(Account.accountData, accountFile)
	end
end

--Logs into the server and updates account information
--Returns false if unable to log in
function Account.login(username, password)
	local response = Server.login(username, password)
	if(response ~= nil) then
		Account.accountData.username = username
		Account.accountData.token = response
		Account.refreshData()
		return true
	end
	return false
end

--Returns whether or not the player has a game in progress
function Account.hasGame()
	return Account.accountData.currentGame ~= ""
end

--Returns the player's client token
function Account.getToken()
	return Account.accountData.token
end

--Returns the amount of player wins
function Account.getWins()
	return Account.accountData.wins
end

--Returns the amount of player losses
function Account.getLosses()
	return Account.accountData.losses
end

--Checks to see if the current client token is valid
function Account.validate()
	return Server.validate(Account.accountData.token)
end

--Logs out from the server and resets account data
function Account.logout()
	Server.invalidate(Account.accountData.token)
	Account.accountData = {}
	FileUtility.saveTable(Account.accountData, accountFile)
end

return Account
