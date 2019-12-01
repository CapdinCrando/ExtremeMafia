--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stephenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: 
--Description: 

local composer = require( "composer" )
local widget = require("widget")
 
local mainView = composer.newScene()

function mainView:create( event )
 
	local sceneGroup = self.view

	--Picture
	local width = display.contentWidth - 20
	local mafiaLogo = display.newImageRect("MafiaLogo.png", width, width/2)
	mafiaLogo.x = display.contentCenterX
	mafiaLogo.y = width/4 + 30
	sceneGroup:insert(mafiaLogo)

	--Game Title
	local gameTitle1 = display.newText({
		x = display.contentWidth/2 - 39,
		y = width/2 + 50,
		text = "EXTREME",
		fontSize = 24
	})
	sceneGroup:insert(gameTitle1)

	local gameTitle2 = display.newText({
		x = display.contentWidth/2 + 61,
		y = width/2 + 50,
		text = "MAFIA",
		fontSize = 24
	})
	gameTitle2:setFillColor(1, 0, 0)
	sceneGroup:insert(gameTitle2)

	--Buttons
	local function createGame(event)
		if (event.phase == "ended") then Runtime:dispatchEvent({name = "createGame"}) end
	end

	local createButton = widget.newButton({
		id = "createButton",
		x = display.contentWidth/2,
		y = 400,
		width = display.contentWidth - 50,
		height = 50,
		shape = "roundedRect",
		label = "Create Game",
		fontSize = 20,
		fillColor = { default={1,0,0,1}, over={1,1,1,1} },
		labelColor = { default={1,1,1,1}, over={1,0,0,1} },
		onEvent = createGame,
	})
	sceneGroup:insert(createButton)

	local codeBox = native.newTextField(display.contentWidth/2 - 75, 300, display.contentWidth - 200, 50)
	codeBox.inputType = "no-emoji"
	self.codeBox = codeBox
	sceneGroup:insert(codeBox)

	local function joinGame(event)
		if (event.phase == "ended") then Runtime:dispatchEvent({name = "joinGame", gameCode = codeBox.text}) end
	end

	local joinButton = widget.newButton({
		id = "joinButton",
		x = display.contentWidth/2 + 75,
		y = 300,
		width = 125,
		height = 50,
		shape = "roundedRect",
		label = "Join Game",
		fontSize = 20,
		fillColor = { default={1,0,0,1}, over={1,1,1,1} },
		labelColor = { default={1,1,1,1}, over={1,0,0,1} },
		onEvent = joinGame,
	})
	sceneGroup:insert(joinButton)

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

function mainView:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        self.codeBox.isVisible = true
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end


function mainView:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
		self.codeBox.text = ""
        self.codeBox.isVisible = false
 
    end
end

function mainView:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end

mainView:addEventListener( "create", mainView )
mainView:addEventListener( "show", mainView )
mainView:addEventListener( "hide", mainView )
mainView:addEventListener( "destroy", mainView )
 
return mainView
