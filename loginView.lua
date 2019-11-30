--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stevenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: 
--Description: 

local composer = require( "composer" )
local widget = require("widget")
 
local loginView = composer.newScene()

function loginView:create( event )
 
	local sceneGroup = self.view
	
	--Picture
	local width = display.contentWidth - 20
	local mafiaLogo = display.newImageRect("MafiaLogo.png", width, width/2)
	mafiaLogo.x = display.contentCenterX
	mafiaLogo.y = width/4
	sceneGroup:insert(mafiaLogo)

	--Game Title
	local gameTitle1 = display.newText({
		x = display.contentWidth/2 - 39,
		y = width/2 + 20,
		text = "EXTREME",
		fontSize = 24
	})
	sceneGroup:insert(gameTitle1)

	local gameTitle2 = display.newText({
		x = display.contentWidth/2 + 61,
		y = width/2 + 20,
		text = "MAFIA",
		fontSize = 24
	})
	gameTitle2:setFillColor(1, 0, 0)
	sceneGroup:insert(gameTitle2)

	--Login
	local loginText = display.newText({
		x = display.contentWidth/2,
		y = 250,
		text = "Login:",
		fontSize = 24
	})
	sceneGroup:insert(loginText)

	local usernameText = display.newText({
		x = display.contentWidth/2 - 100,
		y = 300,
		text = "Username: ",
		fontSize = 16
	})
	sceneGroup:insert(usernameText)
	local usernameBox = native.newTextField(display.contentWidth/2 + 40, 300, display.contentWidth - 125, 35)
	usernameBox.inputType = "no-emoji"
	self.un = usernameBox
	sceneGroup:insert(usernameBox)

	local passwordText = display.newText({
		x = display.contentWidth/2 - 100,
		y = 350,
		text = "Password: ",
		fontSize = 16
	})
	sceneGroup:insert(passwordText)
	local passwordBox = native.newTextField(display.contentWidth/2 + 40, 350, display.contentWidth - 125, 35)
	passwordBox.inputType = "no-emoji"
	passwordBox.isSecure = true
	self.pw = passwordBox
	sceneGroup:insert(passwordBox)

	local function login()
		Runtime:dispatchEvent({name = "login", un = self.un.text, pw = self.pw.text})
	end

	local loginButton = widget.newButton({
		id = "loginButton",
		x = display.contentWidth/2,
		y = 400,
		width = 100,
		height = 50,
		shape = "roundedRect",
		label = "Login",
		fontSize = 20,
		fillColor = { default={1,0,0,1}, over={1,1,1,1} },
		labelColor = { default={1,1,1,1}, over={1,0,0,1} },
		onPress = login,
	})
	sceneGroup:insert(loginButton)
end

function loginView:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end


function loginView:hide( event )
 
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

function loginView:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end

loginView:addEventListener( "create", loginView )
loginView:addEventListener( "show", loginView )
loginView:addEventListener( "hide", loginView )
loginView:addEventListener( "destroy", loginView )
 
return loginView