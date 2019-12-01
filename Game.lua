--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: Dr. Haeyong Chung
--Due Date: December 1, 2019
--File Name: Game.lua
--Description:	Represents the game session. Used as an interface between
--				the server and the app and holds game information locally.

--Libraries
local Account = require("Account")
local Server = require("Server")

--Create game object
Game = {}

--Retrieves and updates the game data
function Game.refreshData()
	Game.gameData = Server.getGameData(Account.getToken())
end

--Gets the game title
function Game.getGameTitle()
	return Game.gameData.title
end

--Gets the player table
function Game.getPlayers()
	return Game.gameData.players
end

--Returns whether or not the player is the host of the current game
function Game.isHost()
	return Game.gameData.host == Account.getUsername()
end

--Gets the current game phase
function Game.getPhase()
	return Game.gameData.currentPhase
end

--Uses the player's special ability
function Game.useSpecial(targetName)
	Server.useSpecial(Account.getToken(), targetName)
end

--Tells the game that the player has been attacked
function Game.died()
	Server.playerDied(Account.getToken())
end

--Joins a game with the given game code
function Game.joinGame(gameCode)
	return Server.joinGame(Account.getToken(), gameCode)
end

--Starts the player's game if the player is the host
function Game.startGame()
	Server.startGame(Account.getToken())
end

--Leaves the current game
function Game.leaveGame()
	Server.leaveGame(Account.getToken())
end

--Gets the player's role
function Game.getPlayerRole()
	return Server.players[Account.getUsername()].role
end

--Gets the specified player's role
function Game.getPlayerRole(playerName)
	return Server.players[playerName].role
end

--Gets the minutes remaining in the current phase
function Game.getMinutesRemaining()
	return Server.getRemainingTime(Account.getToken())
end

--Sends the player's vote to the server
function Game.vote(targetName)
	Server.vote(Account.getToken(), targetname)
end

--Creates a new game from the given settings
function Game.createGame(title, gameSettings)
	return Server.createGame(Account.getToken(), title, gameSettings)
end

return Game
