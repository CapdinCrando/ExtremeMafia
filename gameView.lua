--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stephenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: 
--Description: 

local composer = require( "composer" )
local widget = require("widget")
local Game = require("Game")

local gameView = composer.newScene()

function gameView:create( event )
 
	local sceneGroup = self.view
	
	--Account Icon
	local function accountScreen(event)
		if (event.phase == "ended") then Runtime:dispatchEvent({name = "accountScreen"}) end
	end
	local accountButton = widget.newButton({
		id = "accountButton",
		x = 40,
		y = 20,
		width = 40,
		height = 40,
		defaultFile = "accountIcon.png",
		onEvent = accountScreen,
	})
	sceneGroup:insert(accountButton)
	
	
	
end

function gameView:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end


function gameView:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end

function gameView:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end

gameView:addEventListener( "create", gameView )
gameView:addEventListener( "show", gameView )
gameView:addEventListener( "hide", gameView )
gameView:addEventListener( "destroy", gameView )
 
return gameView
