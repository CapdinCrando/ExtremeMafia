--Project Name: Extreme Mafia
--Authors: Tristan Jay, Max Stephenson, Jesse Wood
--Class: CS 371
--Instructor: ?
--Due Date: December 1, 2019
--File Name: 
--Description: 

--Libraries
local composer = require( "composer" )
local widget = require("widget")
local Game = require("Game")

--Create the scene object
local gameView = composer.newScene()

function gameView:create( event )
	
	local sceneGroup = self.view
	
	--Game Title
	local gameTitle = display.newText({
		x = display.contentWidth/2,
		y = 25,
		text = Game.getGameTitle(),
		fontSize = 28
	})
	sceneGroup:insert(gameTitle)
	
	--Game Phase
	local phaseText = display.newText({
		x = display.contentWidth/2,
		y = display.contentHeight/2 - 160,
		text = "",
		fontSize = 22
	})
	self.phaseText = phaseText
	sceneGroup:insert(phaseText)
		
		
	local function refresh()
		Runtime:dispatchEvent({name = "refresh"})
	end
	
	--Start game button
	local function startGame()
		Game.startDemo()
		refresh()
	end
	local startButton = widget.newButton({
		id = "startButton",
		x = display.contentWidth/2,
		y = display.contentHeight - 20,
		width = display.contentWidth - 175,
		height = 50,
		shape = "roundedRect",
		label = "Start Game",
		fontSize = 20,
		fillColor = { default={1,0,0,1}, over={1,1,1,1} },
		labelColor = { default={1,1,1,1}, over={1,0,0,1} },
		onRelease = startGame,
	})
	startButton.isVisible = false
	self.startButton = startButton
	sceneGroup:insert(startButton)
	
	--Account Icon
	local function accountScreen(event)
		Runtime:dispatchEvent({name = "accountScreen"})
	end
	local accountButton = widget.newButton({
		id = "accountButton",
		x = 40,
		y = 20,
		width = 40,
		height = 40,
		defaultFile = "accountIcon.png",
		onRelease = accountScreen,
	})
	sceneGroup:insert(accountButton)
	
	local function demo()
		local gamePhase = Game.getPhase()
		if(gamePhase == "active") then
			Game.demoVoting()
		elseif(gamePhase == "voting") then
			Game.endDemo()
		end
		refresh()
	end
	
	--Refresh Icon
	local refreshButton = widget.newButton({
		id = "refreshButton",
		x = display.contentWidth - 40,
		y = 20,
		width = 40,
		height = 40,
		defaultFile = "refreshIcon.png",
		onRelease = demo,
	})
	sceneGroup:insert(refreshButton)
	
end

function gameView:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
	
    if ( phase == "will" ) then
		local role = Game.getPlayerRole()
		local gamePhase = Game.getPhase()
        -- Table Functions
		local function onRowRender(event)
			-- event.row
			local row = event.row
			local rowHeight = row.contentHeight
			local rowWidth = row.contentWidth
			local player = event.row.params.player
			
			-- Username text
			local userText = display.newText(row, player.displayName, 0, 0, nil, 20)
			userText:setFillColor(245/255, 245/255, 245/255)
			userText.anchorX = 0
			userText.x = 15
			userText.y = rowHeight * 0.5
			
			if(gamePhase == "lobby") then
				print("lobby")
			else
				local aliveText = display.newText(row, "", 0, 0, nil, 20)
				local aText
				if(player.alive) then
					aliveText.text = "Alive"
					aliveText:setFillColor(0, 1, 0, 1)
				else
					aliveText.text = "Dead"
					aliveText:setFillColor(1, 0, 0, 1)
				end
				aliveText.anchorX = 0
				aliveText.x = rowWidth - 115
				aliveText.y = rowHeight * 0.5
				if(gamePhase == "active") then
					local user = Game.getPlayer()
					print(user.role)
					if(not player.usedAbility) then
						if(user.role == "doctor") then
							-- Player is doctor
							function saveButtonHandler(event)
								Game.useSpecial(player.user)
								Runtime:dispatchEvent({name = "refresh"})
								return true
							end
							local saveButton = widget.newButton({
								onEvent = saveButtonHandler,
								width = 50,
								height = 25,
								defaultFile = "save_default.png",
								overFile = "save_over.png",
							})
							row:insert(saveButton)
							saveButton.anchorX = 0
							saveButton.x = rowWidth - saveButton.width - 15
							saveButton.y = rowHeight * 0.5
						elseif(user.role == "detective") then
							-- Player is detective
							function inspectButtonHandler(event)
								Game.useSpecial(player.user)
								Runtime:dispatchEvent({name = "refresh"})
								return true
							end
							local inspectButton = widget.newButton({
								onEvent = inspectButtonHandler,
								width = 50,
								height = 25,
								defaultFile = "inspect_default.png",
								overFile = "inspect_over.png",
							})
							row:insert(inspectButton)
							inspectButton.anchorX = 0
							inspectButton.x = rowWidth - inspectButton.width - 15
							inspectButton.y = rowHeight * 0.5
						end
					end
				elseif(gamePhase == "voting") then
					-- If game phase is voting --------------------------------------------
					-- Vote button (display as needed)
					function voteButtonHandler(event)
						print("***************" .. player.user)
						Game.vote(player.user)
						Runtime:dispatchEvent({name = "refresh"})
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
				end
			end
		end
		local function onRowUpdate(event)
			-- event.row
			-- event.row.index
			print("update")
		end
		local function onRowTouch(event)
			-- event.phase == "press"
			-- event.target.index == row touced
			local player = event.row.params.player
			native.showAlert(
				player.displayName .. " Role",
				player.displayName .. " is " .. player.role
			)
			return true
		end
		local function gameTableListener(event)
			return true
		end
		
		-- Create table
		local gameTable = widget.newTableView({
			x = display.contentCenterX,
			y = display.contentCenterY - 20,
			width = display.contentWidth - 10,
			height = display.contentHeight - (display.contentHeight/2),
			listener = gameTableListener,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch
		})
		
		-- Populate table
		local players = Game.getPlayers()
		for key, item in pairs(players) do
			item.user = key
			gameTable:insertRow({--item.displayName,
				rowHeight = 40,
				rowColor = { default = { 0.5, 0.5, 0.5 }, over = { 1, 0, 0 } },
				params = { player = item }
			})
		end
		
		sceneGroup:insert(gameTable)
		
		if(gamePhase == "lobby") then
			self.phaseText.text = "Lobby"
			if(Game.isHost()) then
				self.startButton.isVisible = true
			else
				self.startButton.isVisible = false
			end
		else
			--Game has been started
			self.startButton.isVisible = false
			--IF WINNER:
				--WINNER TEXT
			--ELSE
				--TIME REMAINING
				--IF ALIVE: I DIED BUTTON
				
			--Picture
			local options = {
				width = 150,
				height = 330,
				numFrames = 4,
				sheetContentWidth = 625,
				sheetContentHeight = 330
			}
			local sheet = graphics.newImageSheet("MafiaLogo2.png", options)
			local roleIcon
			if (role == "mafia") then
				roleIcon = display.newImageRect(sheet, 4, 60, 132)
			elseif (role == "doctor") then
				roleIcon = display.newImageRect(sheet, 2, 60, 132)
			elseif (role == "detective") then
				roleIcon = display.newImageRect(sheet, 1, 60, 132)
			elseif (role == "citizen") then
				roleIcon = display.newImageRect(sheet, 3, 60, 132)
			end
			roleIcon.x = 275
			roleIcon.y = 20
			sceneGroup:insert(roleIcon)
			
			if(gamePhase == "active") then
				self.phaseText.text = "Active"
			elseif(gamePhase == "voting") then
				self.phaseText.text = "Voting"
			end
		end
		
		-- Timer
		local timeRemaining = Game.getMinutesRemaining()
		local timerText = display.newText({
			text = "Time Remaining: " .. timeRemaining .. "m",
			y = gameTable.y + gameTable.height/2 + 20,
			x = display.contentCenterX,
			fontSize = 24
		})
		
		-- Your Role
		local user = Game.getPlayer()
		local role = display.newText({
			text = "You are " .. user.role,
			y = gameTable.y + gameTable.height/2 + 50,
			x = display.contentCenterX,
			fontSize = 24
		})
	
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
