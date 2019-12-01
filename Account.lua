local json = require("json")
local FileUtility = require("FileUtility")
local Server = require("Server")

local accountFile = "Account.dat"

Account = {}
Account.accountData = FileUtility.loadTable(accountFile)

function Account.getUsername()
	return Account.accountData.username
end

function Account.getDisplayName()
	return Account.accountData.displayName
end

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

function Account.hasGame()
	return Account.accountData.currentGame ~= ""
end

function Account.getToken()
	return Account.accountData.token
end

function Account.getWins()
	return Account.accountData.wins
end

function Account.getLosses()
	return Account.accountData.losses
end

function Account.validate()
	return Server.validate(Account.accountData.token)
end

function Account.logout()
	Server.invalidate(Account.accountData.token)
	Account.accountData = {}
	FileUtility.saveTable(Account.accountData, accountFile)
end

return Account
