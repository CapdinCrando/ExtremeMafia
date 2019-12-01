--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: 
--Description: 

local composer = require( "composer" )
local widget = require("widget")
local Account = require("Account")
 
local accountView = composer.newScene()

--[[ ["CapdinCrando"] = {
	displayName = "Tristan Jay",
	password = "1234",
	currentGame = "",
	wins = "42",
	losses = "0",
	token = ""
}, ]]

function accountView:create( event )
 
	local sceneGroup = self.view

	--Username
	local usernameText = display.newText({
		left = display.contentWidth/2 - 100,
		top = 50,
		text = "Username: "..Account.getUsername(),
		fontSize = 24
	})
	sceneGroup:insert(usernameText)

	--Display Name
	local displayText = display.newText({
		left = display.contentWidth/2 - 100,
		top = 50,
		text = "Display Name: "..Account.getDisplayName(),
		fontSize = 24
	})
	sceneGroup:insert(displayText)

	--Wins
	local winsText = display.newText({
		left = display.contentWidth/2 - 100,
		top = 50,
		text = "Wins: "..Account.getWins(),
		fontSize = 24
	})
	sceneGroup:insert(winsText)

	--Losses
	local lossesText = display.newText({
		left = display.contentWidth/2 - 100,
		top = 50,
		text = "Losses: "..Account.getLosses(),
		fontSize = 24
	})
	sceneGroup:insert(lossesText)

	--Logout Button
	--Leave game button 
end

function accountView:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end


function accountView:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		self.un.text = ""
		self.pw.text = ""
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end

function accountView:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end

accountView:addEventListener( "create", accountView )
accountView:addEventListener( "show", accountView )
accountView:addEventListener( "hide", accountView )
accountView:addEventListener( "destroy", accountView )
 
return accountView