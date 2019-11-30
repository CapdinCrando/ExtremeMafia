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

local function startup()
	print("AHHHH?")
	if(Account.validate()) then
		print("AHHHH!")
		Account.refreshData()
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
	else
		print("lgoin!")
		composer.gotoScene("loginView")
	end
end

local function login(event)
	if(Account.login(event.un, event.pw)) then
		--Login successful
	else
		native.showAlert("Invalid login!", "Username or password is invalid!")
	end
end

Runtime:addEventListener("login", login)

composer.gotoScene("loadingView")
timer.performWithDelay(100, startup, 1)