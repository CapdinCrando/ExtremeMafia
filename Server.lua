--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: Server.lua
--Description:

Server = {}

Server.games = {
	["ABCD"] = {
		title = "Demo Game",
		currentRound = 2,
		currentPhase = "active",
		timeRemaining = 5,
		host = "CapdinCrando",
		winner = "",
		playerCount = 4,
		neededVotes = 3,
		settings = {
			activeMinutes = 1,
			votingMinutes = 1,
			mafiaCount = 1,
			doctorCount = 1,
			detectiveCount = 1,
			assassinations = 1,
			mafiaSuicide = true,
			roleReveal = true
		},
		players = {
			["CapdinCrando"] = {displayName = "Tristan Jay", role = "doctor", alive = true, protected = false, votes = 0, voted = false, usedAbility = false},
			["Max"] = {displayName = "Max Stevenson", role = "citizen", alive = true, protected = false, votes = 0, voted = false, usedAbility = false},
			["InigoMontoya"] = {displayName = "Jesse Wood", role = "mafia", alive = false, protected = true, votes = 0, voted = false, usedAbility = false},
			["TeckArcher"] = {displayName = "Eli Wright", role = "detective", alive = true, protected = false, votes = 0, voted = false, usedAbility = true}
		},
		deaths = {
			["TeckArcher"] = true
		}
	}
}

Server.accounts = {
	["CapdinCrando"] = {
		displayName = "Tristan Jay",
		password = "1234",
		currentGame = "",
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
	token.endTime = time + 86400
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
		Server.tokens[token] = nil
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
			t.endTime = time + 86400
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

function Server.getGameData(token)
	if(Server.validate(token)) then
		return Server.games[Server.accounts[Server.tokens[token].username].currentGame]
	end
	return nil
end

function Server.createGame(token, t, gameSettings)
	local game = {
		title = t,
		currentRound = 0,
		currentPhase = "lobby",
		timeRemaining = 0,
		winner = "",
		playerCount = 1,
		host = "CapdinCrando",
		settings = gameSettings,
		players = {},
		deaths = {}
	}
	local percentage = playerCount/2
	local needed = math.round(percentage)
	if(needed == percentage) then
		needed = needed + 1
	end
	game.neededVotes = needed
	Server.games["DHZJ"] = game
	return "DHZJ" --Normally random generated
end

function Server.winGame(game, winner)
	game.winner = winner
	timer.cancel(game.timer)

	--Scoring
	if(winner == "mafia") then
		for k, v in pairs(game.players) do
			if(v.role == "mafia") then
				v.wins = v.wins + 1
			else
				v.losses = v.losses + 1
			end
		end
	else
		for k, v in pairs(game.players) do
			if(v.role ~= "mafia") then
				v.wins = v.wins + 1
			else
				v.losses = v.losses + 1
			end
		end
	end
end

function Server.endRound(game)
	--Check and kill votee
	local votes = {}
	for k,v in pairs(game.players) do
		if(votes[k] == nil) then
			votes[k] = 0
		end
		local targetName = v.vote
		if(targetName ~= "") then
			if(votes[targetName] == nil) then
				votes[targetName] = 1
			else
				votes[targetName] = votes[targetName] + 1
			end
		end
	end
	for k,v in pairs(votes) do
		if(v >= game.neededVotes) then
			game.players[v].alive = false
		end
	end

	--Check for win condition
	local aliveMafia = 0
	local aliveCitizens = 0
	local aliveDoctors = 0
	for k,v in pairs(game.players) do
		if(v.role == "mafia") then
			aliveMafia = aliveMafia + 1
		else
			aliveCitizens = aliveCitizens + 1
			if(v.role == "doctor") then
				aliveDoctors = aliveDoctors + 1
			end
		end
	end

	if(aliveMafia == 0) then
		Server.winGame(game, "citizens")
	else
		if(citizens == 0) then
			Server.winGame(game, "mafia")
		elseif(citizens == 1) then
			if(aliveDoctors == 1) then
				Server.winGame(game, "mafia")
			end
		end
	end

	--Reset
	game.currentRound = currentRound + 1
	game.deaths = {}
	for k,v in pairs(game.players) do 
		if(v.role == "doctor") then
			v.usedAbility = false
		elseif(v.role == "detective") then
			v.usedAbility = false
		end
		v.protected = false
		v.vote = ""
	end
end

function Server.beginVoting(game)
	game.currentPhase = "voting"
	game.timeRemaining = game.settings.votingMinutes
end

function Server.beginActive(game)
	game.currentPhase = "active"
	game.timeRemaining = game.settings.activeMinutes
end

function gameTick(game)
	local round = game.currentRound
	if(round == "lobby") then
		Server.beginActive(game)
	else
		game.timeRemaining = game.timeRemaining - 1
		if(round == "active") then
			if(game.timeRemaining == 0) then
				Server.beginVoting(game)
			end
		elseif(round == "voting") then
			if(game.timeRemaining == 0) then
				Server.endRound(game)
				Server.beginActive(game)
			end
		end
	end
end

function Server.vote(token, targetName)
	if(Server.validate(token)) then
		local username = Server.tokens[token].username
		local game = Server.games[Server.accounts[username].currentGame]
		local player = game.players[username]
		local target = game.players[targetName]
		if(target.alive) then
			if(targetName ~= username) then
				if(game.deaths[targetName] ~= nil) then
					player.vote = targetName
				end
			end
		end
	end
end

function Server.joinGame(token, gameCode)
	local username = Server.tokens[token].username
	local game = Server.games[gameCode]
	if(game ~= nil) then
		if(game.currentPhase == "lobby") then
			local p = {
				displayName = Server.accounts[username].displayName,
				role = "", alive = true, 
				protected = false, 
				vote = "",
				usedAbility = false
			}
			game.players[username] = p
			game.playerCount = game.playerCount + 1
			return true
		end
	end
	return false
end

function Server.startGame(token)
	local username = Server.tokens[token].username
	local game = Server.games[Server.accounts[username].currentGame]
	if(game.host == username) then
		--Assign roles
		local mafia = game.settings.mafiaCount
		local doctor = game.settings.doctorCount
		local detective = game.settings.detectiveCount
		for k,v in pairs(game.players) do
			while(v.role == "") do
				local select = math.random(0, 2)
				if(select == 0) then
					if(mafia ~= 0) then
						v.role = "mafia"
						mafia = mafia - 1
					end
				elseif(select == 1) then
					if(doctor ~= 0) then
						v.role = "doctor"
						doctor = doctor - 1
					end
				elseif(select == 2) then
					if(detective ~= 0) then
						v.role = "detective"
						detective = detective - 1
					end
				end
			end
		end
		Server.gameTick(game)
		game.timer = timer.performWithDelay(60000, function() Server.gameTick(game) end, -1)
		return true
	end
	return false
end

function Server.leaveGame(token)
	Server.accounts[Server.tokens[token].username].currentGame = ""
end

function Server.getRemainingTime(token)
	if(Server.validate(token)) then
		local game = Server.games[Server.accounts[Server.tokens[token].username].currentGame]
		return game.timeRemaining
	end
end

function Server.useSpecial(token, targetName)
	if(Server.validate(token)) then
		local username = Server.tokens[token].username
		local player = game.players[username]
		local game = Server.games[Server.accounts[username].currentGame]
		local role = game.players[username].role
		if(player.usedAbility == false) then
			if(role == "doctor") then
				game.players[targetName].protected = true
				player.usedAbility = true
			elseif(role == "detective") then
				player.usedAbility = true
				return game.players[targetName].role
			end
		end
	end
	return nil
end

function Server.playerDied(token)
	if(Server.validate(token)) then
		local username = Server.tokens[token].username
		Server.games[Server.accounts[username].currentGame].deaths[username] = true
	end
end

function Server.getPlayerRole(token)
	if(Server.validate(token)) then
		local username = Server.tokens[token].username
		local game = Server.games[Server.accounts[username].currentGame]
		return game.player[username].role
	end
end

return Server
