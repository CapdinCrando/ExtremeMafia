--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: Dr. Haeyong Chung
--Due Date: December 1, 2019
--File Name: Server.lua
--Description:	Class used to simulate a server enviroment. This class is
--				for demonstration and would not exist in the actual app.

--Libraries
local FileUtility = require("FileUtility")

--Filenames for server saves
local gameSave = "Games.dat"
local accountSave = "Accounts.dat"
local tokenSave = "Tokens.dat"

--Create server object
Server = {}

--Load server states from file
Server.games = FileUtility.loadTable(gameSave)
Server.accounts = FileUtility.loadTable(accountSave)
Server.tokens = FileUtility.loadTable(tokenSave)

--Saves server game states
function Server.saveGames()
	FileUtility.saveTable(Server.games, gameSave)
end

--Saves server account states
function Server.saveAccount()
	FileUtility.saveTable(Server.accounts, accountSave)
end

--Saves server token states
function Server.saveTokens()
	FileUtility.saveTable(Server.tokens, tokenSave)
end

--Creates a new token for the given user
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
	Server.accounts[username].token = uuid
	Server.saveTokens()
	Server.saveAccount()
	return uuid
end

--Adds a new account to the server and returns a new token
--Returns nil if account cannot be created
function Server.addAccount(username, password, displayName)
	if(username ~= nil) then
		if(password ~= nil) then
			if(displayName ~= nil) then
				if(Server.accounts[username] == nil) then
					local account = Server.accounts[username]
					account.username = username
					account.password = password
					account.displayName = displayName
					account.wins = 0
					account.losses = 0
					return Server.createToken(username)
				end
			end
		end
	end
	return nil
end

--Removes the given token
function Server.invalidate(token)
	local t = Server.tokens[token]
	if(t ~= nil) then
		Server.accounts[t.username].token = ""
		Server.tokens[token] = nil
		Server.saveTokens()
		Server.saveAccount()
	end
end

--If username exists and password is correct, returns a new token
--Returns nil if account information is incorrect
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

--Checks to see if the given token is valid
--If yes, refresh end time and return true
--If no, return false
function Server.validate(token)
	local t = Server.tokens[token]
	if(t ~= nil) then
		local time = os.time(os.date('*t'))
		if(t.endTime > time) then
			t.endTime = time + 86400
			Server.saveTokens()
			return true
		end
	end
	Server.invalidate(token)
	return false
end

--Gets the account data for the account tied to the given token
--Returns nil if token is invalid
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

--Returns the game data of the game tied to the token's user
--Returns nil if token is invalid
function Server.getGameData(token)
	if(Server.validate(token)) then
		return Server.games[Server.accounts[Server.tokens[token].username].currentGame]
	end
	return nil
end

--Creates a new game from the given parameters
--Returns the gameCode
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
	local gameCode = "DHZJ" --Normally random generated
	game.neededVotes = needed
	Server.games[gameCode] = game
	Server.saveGames()
	Server.saveAccount()
	return gameCode
end

--Ends the game and declares the winning party given
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
	Server.saveGames()
	Server.saveAccount()
end

--Checks for a potential win condition
function Server.checkWin(game)
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
		return true
	else
		if(citizens == 0) then
			Server.winGame(game, "mafia")
		return true
		elseif(citizens == 1) then
			if(aliveDoctors == 1) then
				Server.winGame(game, "mafia")
		return true
			end
		end
	end
	return false
end

--Ends the current game round
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

	Server.checkWin(game)

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
	Server.saveGames()
end

--Begins the voting period
function Server.beginVoting(game)
	if(Server.checkWin(game) == false) then
		game.currentPhase = "voting"
		game.timeRemaining = game.settings.votingMinutes
		Server.saveGames()
	end
end


--Begins the active period
function Server.beginActive(game)
	game.currentPhase = "active"
	game.timeRemaining = game.settings.activeMinutes
	Server.saveGames()
end

--Represents a single game tick
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
	Server.saveGames()
end

--Handles a player's vote
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
					Server.saveGames()
				end
			end
		end
	end
end

--Adds a user to and existing game
--Returns false if unable to add user
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
			Server.accounts[username].currentGame = gameCode
			Server.saveGames()
			Server.saveAccount()
			return true
		end
	end
	return false
end

--Assigns roles and starts the game tick cycle
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
		Server.saveGames()
		return true
	end
	return false
end

--Removes a player from the current game
function Server.leaveGame(token)
	local username = Server.tokens[token].username
	local currentGame = Server.accounts[username].currentGame
	Server.games[currentGame].players[username] = nil
	Server.accounts[username].currentGame = ""
	Server.saveGames()
	Server.saveAccount()
end

--Gets the remaining time in the current phase
function Server.getRemainingTime(token)
	if(Server.validate(token)) then
		local game = Server.games[Server.accounts[Server.tokens[token].username].currentGame]
		return game.timeRemaining
	end
end

--Handles the use of a player's special ability
--Returns the role of the target if player is a doctor
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
				Server.saveGames()
			elseif(role == "detective") then
				player.usedAbility = true
				Server.saveGames()
				return game.players[targetName].role
			end
		end
	end
	return nil
end

--Handles a potential player death
function Server.playerDied(token)
	if(Server.validate(token)) then
		local username = Server.tokens[token].username
		Server.games[Server.accounts[username].currentGame].deaths[username] = true
		Server.saveGames()
	end
end

return Server
