--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: 
--Description: 

local composer = require( "composer" )
local widget = require("widget")
 
local activeView = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function activeView:create( event )
 
	local sceneGroup = self.view
	
	--Title
	local gameTitle = display.newText({
		x = display.contentWidth/2,
		y = 40,
		text = "GAME TITLE",
		fontSize = 24
	})
	sceneGroup:insert(gameTitle)

	--Active Players Text
	local playerText = display.newText({
		x = display.contentWidth/2,
		y = 75,
		text = "Players:",
		fontSize = 16
	})
	sceneGroup:insert(playerText)

	--Players Table
	local tableView = widget.newTableView({
		left = 10,
		top = 85,
		height = display.contentHeight - 200,
		width = display.contentWidth - 20,
		--hideBackground = true
	})
	sceneGroup:insert(tableView)

	--Your role
	--Time remaining

	--Died Button
	--Ability Button
 
end
 
 
-- show()
function activeView:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function activeView:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function activeView:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
activeView:addEventListener( "create", activeView )
activeView:addEventListener( "show", activeView )
activeView:addEventListener( "hide", activeView )
activeView:addEventListener( "destroy", activeView )
-- -----------------------------------------------------------------------------------
 
return activeView