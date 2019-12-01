--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stephenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: 
--Description: 

local composer = require( "composer" )
 
local loadingView = composer.newScene()

function loadingView:create( event )
 
	local sceneGroup = self.view
	
	--Picture
	local width = display.contentWidth - 20
	local mafiaLogo = display.newImageRect("MafiaLogo.png", width, width/2)
	mafiaLogo.x = display.contentCenterX
	mafiaLogo.y = display.contentCenterY
	sceneGroup:insert(mafiaLogo)

	--Game Title
	local gameTitle1 = display.newText({
		x = display.contentWidth/2 - 39,
		y = 330,
		text = "EXTREME",
		fontSize = 24
	})
	sceneGroup:insert(gameTitle1)

	local gameTitle2 = display.newText({
		x = display.contentWidth/2 + 61,
		y = 330,
		text = "MAFIA",
		fontSize = 24
	})
	gameTitle2:setFillColor(1, 0, 0)
	sceneGroup:insert(gameTitle2)
end

function loadingView:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end


function loadingView:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end

function loadingView:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end

loadingView:addEventListener( "create", loadingView )
loadingView:addEventListener( "show", loadingView )
loadingView:addEventListener( "hide", loadingView )
loadingView:addEventListener( "destroy", loadingView )
 
return loadingView