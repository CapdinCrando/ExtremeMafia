local Account = require("Account")
local Server = require("Server")

Game = {}

-- Retrieves and updates the game data
function Game.refreshData()
	--Account
end

function Game.getGameTitle()
	return self.title
end

function Game.getPlayers()
	return self.players
end

function Game.useSpecial(targetName)
	
end

function Game.died()
	
end

function Game.joinGame(gameCode)

end

function Game.getPlayerRole(playerName)
	return self.players(playerName).role
end

function Game.getMinutesRemaining()

end

return Game