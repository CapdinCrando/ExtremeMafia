--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: 
--Description: 

local composer = require( "composer" )
 
local lobbyView = composer.newScene()

function lobbyView:create( event )
 
	local sceneGroup = self.view
end

function lobbyView:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end


function lobbyView:hide( event )
 
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

function lobbyView:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end

lobbyView:addEventListener( "create", lobbyView )
lobbyView:addEventListener( "show", lobbyView )
lobbyView:addEventListener( "hide", lobbyView )
lobbyView:addEventListener( "destroy", lobbyView )
 
return lobbyView