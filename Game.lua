local Account = require("Account")

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

function Game.useSpecial(playerName, targetName)
	
end

function Game.playerDied(playerName)
	--self.deaths.insert(playerName)
end

function Game.getPlayerRole(playerName)
	return self.players(playerName).role
end

function Game.getMinutesRemaining()

end

return Game