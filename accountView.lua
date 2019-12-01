--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stephenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: 
--Description: 

local composer = require( "composer" )
local widget = require("widget")
local Account = require("Account")
 
local accountView = composer.newScene()

function accountView:create( event )
 
	local sceneGroup = self.view
	
	--Title
	local titleText = display.newText({
		x = display.contentWidth/2,
		y = 50,
		text = "Account Details",
		fontSize = 32
	})
	sceneGroup:insert(titleText)

	--Username
	local usernameText = display.newText({
		x = display.contentWidth/2,
		y = 100,
		text = "Username: "..Account.getUsername(),
		fontSize = 24
	})
	sceneGroup:insert(usernameText)

	--Display Name
	local displayText = display.newText({
		x = display.contentWidth/2,
		y = 150,
		text = "Display Name: "..Account.getDisplayName(),
		fontSize = 24
	})
	sceneGroup:insert(displayText)

	--Wins
	local winsText = display.newText({
		x = display.contentWidth/2,
		y = 200,
		text = "Wins: "..Account.getWins(),
		fontSize = 24
	})
	sceneGroup:insert(winsText)

	--Losses
	local lossesText = display.newText({
		x = display.contentWidth/2,
		y = 250,
		text = "Losses: "..Account.getLosses(),
		fontSize = 24
	})
	sceneGroup:insert(lossesText)

	--Logout Button
	local function logout(event)
		if (event.phase == "ended") then Runtime:dispatchEvent({name = "logout"}) end
	end
	local logoutButton = widget.newButton({
		id = "logoutButton",
		x = display.contentWidth/2,
		y = 325,
		width = 150,
		height = 50,
		shape = "roundedRect",
		label = "Logout",
		fontSize = 20,
		fillColor = { default={1,0,0,1}, over={1,1,1,1} },
		labelColor = { default={1,1,1,1}, over={1,0,0,1} },
		onEvent = logout,
	})
	sceneGroup:insert(logoutButton)
	
	--Leave game button 
	local function leaveGame(event)
		if (event.phase == "ended") then Runtime:dispatchEvent({name = "leaveGame"}) end
	end
	local leaveButton = widget.newButton({
		id = "leaveButton",
		x = display.contentWidth/2,
		y = 400,
		width = 150,
		height = 50,
		shape = "roundedRect",
		label = "Leave Game",
		fontSize = 20,
		fillColor = { default={1,0,0,1}, over={1,1,1,1} },
		labelColor = { default={1,1,1,1}, over={1,0,0,1} },
		onEvent = leaveGame,
	})
	self.leaveButton = leaveButton
	sceneGroup:insert(leaveButton)
	
	--Back Icon
	local function back(event)
		if (event.phase == "ended") then Runtime:dispatchEvent({name = "back"}) end
	end
	local backButton = widget.newButton({
		id = "backButton",
		x = display.contentWidth - 40,
		y = 20,
		width = 40,
		height = 40,
		defaultFile = "backIcon.png",
		onEvent = back,
	})
	sceneGroup:insert(backButton)
end

function accountView:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        if(Account.hasGame()) then
        	self.leaveButton.isVisible = true
        else
        	self.leaveButton.isVisible = false
        end
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end


function accountView:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
 
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
