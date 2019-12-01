--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: main.lua
--Description: Main entry point for the program.

local composer = require("composer")
local Account = require("Account")
local Game = require("Game")

local function goToGame()
	if(Account.hasGame()) then
		Game.refreshData()
		local phase = Game.getPhase()
		if(phase == "lobby") then
			composer.gotoScene("lobbyView")
		elseif(phase == "active") then
			composer.gotoScene("activeView")
		elseif(phase == "votingView") then
			composer.gotoScene("votingView")
		end
	else
		composer.gotoScene("mainView")
	end
end

local function login(event)
	if(Account.login(event.un, event.pw)) then
		goToGame()
	else
		native.showAlert("Invalid login!", "Username or password is invalid!")
	end
end

local function logout(event)
	Account.logout()
	composer.gotoScene("loginView")
end

local function startup()
	if(Account.validate()) then
		goToGame()
		Account.refreshData()
	else
		composer.gotoScene("loginView")
	end
end

Runtime:addEventListener("login", login)
Runtime:addEventListener("logout", logout)
Runtime:addEventListener("goToGame", goToGame)

--composer.gotoScene("loadingView")
--timer.performWithDelay(100, startup, 1)
--composer.gotoScene("accountView")