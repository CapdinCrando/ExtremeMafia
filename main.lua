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

local function refresh()
	Account.refreshData()
	if(Account.hasGame()) then
		Game.refreshData()
		composer.gotoScene("gameView")
	else
		composer.gotoScene("mainView")
	end
end

local function login(event)
	if(Account.login(event.username, event.password)) then
		refresh()
	else
		native.showAlert("Invalid login!", "Username or password is invalid!")
	end
end

local function logout(event)
	Account.logout()
	composer.gotoScene("loginView")
end

local function joinGame(event)
	if(Game.joinGame(event.gameCode)) then
		refresh()
	else
		native.showAlert("Invalid Game Code!", "The game code you entered is not valid!")
	end
end

local function leaveGame()
	Game.leaveGame()
	refresh()
end

local function startup()
	if(Account.validate()) then
		refresh()
	else
		composer.gotoScene("loginView")
	end
end

local function accountScreen()
	composer.gotoScene("accountView", {effect = "slideRight", time = 200})
end

local function back()
	local previous = composer.getSceneName("previous")
	if(previous ~= nil) then
		composer.gotoScene(previous, {effect = "slideLeft", time = 200})
	end
end

Runtime:addEventListener("login", login)
Runtime:addEventListener("logout", logout)
Runtime:addEventListener("refresh", refresh)
Runtime:addEventListener("accountScreen", accountScreen)
Runtime:addEventListener("back", back)
Runtime:addEventListener("joinGame", joinGame)
Runtime:addEventListener("leaveGame", leaveGame)

composer.gotoScene("loadingView")
timer.performWithDelay(100, startup, 1)
