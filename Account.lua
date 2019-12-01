local json = require("json")
local FileUtility = require("FileUtility")
local Server = require("Server")

local accountFile = "Account.dat"

Account = FileUtility.loadTable(accountFile)

function Account.getUsername()
	return Account.username
end

function Account.getDisplayname()
	return Account.displayName
end

function Account.login(username, password)
	local response = Server.login(username, password)
	if(response ~= nil) then
		Account.username = username
		Account.token = response
		FileUtility.saveTable(Account, accountFile)
		return true
	end
	return false
end

function Account.hasGame()
	return Account.currentGame ~= nil
end

function Account.getToken()
	return Account.token
end

function Account.getWins()
	return Account.wins
end

function Account.getLosses()
	return Account.losses
end

function Account.validate()
	return Server.validate(Account.token)
end

function Account.refreshData()
	local data = Server.getAccountData(Account.token)
	if(data ~= nil) then
		Account.displayName = data.displayName
		Account.currentGame = data.currentGame
		Account.wins = data.wins
		Account.losses = data.losses
	end
end

function Account.logout()
	Server.invalidate(Account.token)
	Account = {}
	FileUtility.saveTable(Account, accountFile)
end

return Account