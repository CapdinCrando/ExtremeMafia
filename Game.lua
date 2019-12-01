local Account = require("Account")
local Server = require("Server")

Game = {}

-- Retrieves and updates the game data
function Game.refreshData()
	Game.gameData = Server.getGameData(Account.getToken())
end

function Game.getGameTitle()
	return Game.gameData.title
end

function Game.getPlayers()
	return Game.gameData.players
end

function Game.getPhase()
	return Game.gameData.currentPhase
end

function Game.useSpecial(targetName)
	
end

function Game.died()
	
end

function Game.joinGame(gameCode)
	return Server.joinGame(Account.getToken(), gameCode)
end

function Game.leaveGame()
	Server.leaveGame(Account.getToken())
end

function Game.getPlayerRole(playerName)
	return self.players(playerName).role
end

function Game.getMinutesRemaining()

end

return Game
