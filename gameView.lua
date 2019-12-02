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
	
	--Picture
	local options = {
						width = 150,
						height = 330,
						numFrames = 4,
						sheetContentWidth = 625,
						sheetContentHeight = 330
					}
	local sheet = graphics.newImageSheet("MafiaLogo2.png", options)
	local role = Game.getPlayerRole()
	local roleIcon
	if (role == "mafia") then
		roleIcon = display.newImageRect(sheet, 4, 60, 132)
	elseif (role == "doctor") then
		roleIcon = display.newImageRect(sheet, 2, 60, 132)
	elseif (role == "detective") then
		roleIcon = display.newImageRect(sheet, 1, 60, 132)
	else
		roleIcon = display.newImageRect(sheet, 3, 60, 132)
	end
	roleIcon.x = 275
	roleIcon.y = 20
	sceneGroup:insert(roleIcon)
	
    if ( phase == "will" ) then
        -- Table Functions
		local function onRowRender(event)
			-- event.row
			local row = event.row
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			
			-- Username text
			local userText = display.newText(row, event.row.params.user, 0, 0, nil, 20)
			userText:setFillColor(245/255, 245/255, 245/255)
			userText.anchorX = 0
			userText.x = 15
			userText.y = rowHeight * 0.5
			
			-- If game phase is voting --------------------------------------------
			-- Vote button (display as needed)
			function voteButtonHandler(event)
				return true
			end
			local voteButton = widget.newButton({
				onEvent = voteButtonHandler,
				width = 50,
				height = 25,
				defaultFile = "vote_default.png",
				overFile = "vote_over.png",
			})
			row:insert(voteButton)
			voteButton.anchorX = 0
			voteButton.x = rowWidth - voteButton.width - 15
			voteButton.y = rowHeight * 0.5
			
			-- Vote count (display as needed)
			if (event.row.params.votes ~= nil) then
				local voteCount = display.newText(row, event.row.params.votes, 0, 0, nil, 20)
				voteCount:setFillColor(245/255, 245/255, 245/255)
				voteCount.anchorX = 0
				voteCount.x = voteButton.x - 15
				voteCount.y = rowHeight * 0.5
			end
			
			-- If game phase is active --------------------------------------------
			-- Alive or dead state (currently tries to use a nil value, commented out
			--[[
			local playerState = display.newText(row, event.row.params.state, 0, 0, nil, 15)
			playerState.anchorX = 0
			playerState.x = rowWidth - playerState.width - 15
			playerState.y = rowHeight * 0.5
			]]
			
		end
		local function onRowUpdate(event)
			-- event.row
			-- event.row.index
			print("update")
		end
		local function onRowTouch(event)
			-- event.phase == "press"
			-- event.target.index == row touced
			print("touch")
		end
		local function gameTableListener(event)
			return true
		end
		
		-- Create table
		local gameTable = widget.newTableView({
			x = display.contentCenterX,
			y = display.contentCenterY,
			width = display.contentWidth - (display.contentWidth/8),
			height = display.contentHeight - (display.contentHeight/4),
			listener = gameTableListener,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch
		})
		
		-- Populate table
		local players = Game.getPlayers()
		for _, item in pairs(players) do
			gameTable:insertRow({--item.displayName,
				rowHeight = 50,
				rowColor = { default = { 0.5, 0.5, 0.5 }, over = { 1, 0, 0 } },
				params = { user = item.displayName }
			})
		end
		
		sceneGroup:insert(gameTable)
	
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
