--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: Server.lua
--Description:

Server = {}

Server.games = {
	["DJYZ"] = {
		title = "Demo Game",
		currentRound = 2,
		currentPhase = "active",
		timeRemaining = 5,
		host = "CapdinCrando",
		settings = {
			activeMinutes = 5,
			votingMinutes = 5,
			mafiaCount = 1,
			doctorCount = 1,
			detectiveCount = 1,
			assassinations = 1,
			mafiaSuicide = true,
			roleReveal = true
		},
		players = {
			["CapdinCrando"] = {displayName = "Tristan Jay", role = "doctor", alive = true, protected = false, usedAbility = false},
			["Max"] = {displayName = "Max Stevenson", role = "citizen", alive = true, protected = false},
			["InigoMontoya"] = {displayName = "Jesse Wood", role = "mafia", alive = false, protected = true},
			["TeckArcher"] = {displayName = "Eli Wright", role = "detective", alive = true, protected = false, usedAbility = true}
		},
		deaths = {
			"?"
		}
	}
}

Server.accounts = {
	["CapdinCrando"] = {
		displayName = "Tristan Jay",
		password = "1234",
		currentGame = "DJYZ",
		wins = "42",
		losses = "0",
		token = ""
	},
}

Server.tokens = {}

function Server.createToken(username)
	local t = os.date('*t')
	local time = os.time(t)

	math.randomseed(time)
	local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    local uuid = string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
	end)
	
	local token = {}
	token.username = username
	token.endTime = time
	Server.tokens[uuid] = token
	return uuid
end

--Account functions
function Server.addAccount(username, password, displayName)
	if(username ~= nil) then
		if(password ~= nil) then
			if(displayName ~= nil) then
				if(self.accounts[username] == nil) then
					return Server.createToken(username)
				end
			end
		end
	end
	return nil
end

function Server.invalidate(token)
	local t = Server.tokens[token]
	if(t ~= nil) then
		Server.accounts[t.username].token = ""
		table.remove(Server.tokens, token)
	end
end

function Server.login(username, password)
	local account = Server.accounts[username]
	if(account ~= nil) then
		if(account.password == password) then
			if(account.token ~= "") then
				Server.invalidate(account.token)
			end
			return Server.createToken(username)
		end
	end
	return nil
end

function Server.validate(token)
	local t = Server.tokens[token]
	if(t ~= nil) then
		local time = os.time(os.date('*t'))
		if(t.endTime > time) then
			t.endTime = time
			return true
		end
	end
	Server.invalidate(token)
	return false
end

function Server.getAccountData(token)
	if(Server.validate(token)) then
		local account = Server.accounts[Server.tokens[token].username]
		local data = {}
		data.displayName = account.displayName
		data.currentGame = account.currentGame
		data.wins = account.wins
		data.losses = account.losses
		return data
	end
	return nil
end

function Server.createGame()

end

function Server.startGame(player)

end

function Server.useSpecial(playerName, targetName)
	local game = self.games(self.accounts(playerName).currentGame)
	local role = game.player(playerName).role
	if(role == "doctor") then
		--local game.player(targetName).
	elseif(role == "detective") then

	end
end

function Server.playerDied(playerName)
	self.deaths.insert(playerName)
end

function Server.getPlayerRole(playerName)
	return self.players(playerName).role
end

return Server