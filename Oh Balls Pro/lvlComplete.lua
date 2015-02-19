--lvlComplete.lua

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"

local completegameBtn
local okBtn
local userName
local enterName


local function buttonHit(event)
	storyboard.gotoScene (  event.target.destination, {effect = "fade", time = 800})
	
	return true
end



function scene:createScene( event )
	local group = self.view
	
	

	-- display a background image
	local background = display.newImageRect( "levelCompleteBackground.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	group:insert( background )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	
	storyboard.removeScene("level"..tostring(levelNumber))
	
	local function savetoFirstFile(data)
		local path = system.pathForFile("lvl"..tostring(levelNumber).."FirstTime.txt", system.DocumentsDirectory)
		local file = io.open(path, "w+")
		
		local fileContent = file:read("*a")
		local newData = data 
		file:write(newData)
		
	
		io.close(file)
	end
	
	local function savetoSecondFile(data)
		local path = system.pathForFile("lvl"..tostring(levelNumber).."SecondTime.txt", system.DocumentsDirectory)
		local file = io.open(path, "w+")
		
		local fileContent = file:read("*a")
		local newData = data 
		file:write(newData)
		
	
		io.close(file)
	end
	
	local function savetoThirdFile(data)
		local path = system.pathForFile("lvl"..tostring(levelNumber).."ThirdTime.txt", system.DocumentsDirectory)
		local file = io.open(path, "w+")
		
		local fileContent = file:read("*a")
		local newData = data 
		file:write(newData)
		
	
		io.close(file)
	end
	
	local function savetoFirstNameFile(data)
		local path = system.pathForFile("lvl"..tostring(levelNumber).."FirstName.txt", system.DocumentsDirectory)
		local file = io.open(path, "w+")
		
		local fileContent = file:read("*a")
		local newData = data 
		file:write(newData)
		
	
		io.close(file)
	end
	
	local function savetoSecondNameFile(data)
		local path = system.pathForFile("lvl"..tostring(levelNumber).."SecondName.txt", system.DocumentsDirectory)
		local file = io.open(path, "w+")
		
		local fileContent = file:read("*a")
		local newData = data 
		file:write(newData)
		
	
		io.close(file)
	end
	
	local function savetoThirdNameFile(data)
		local path = system.pathForFile("lvl"..tostring(levelNumber).."ThirdName.txt", system.DocumentsDirectory)
		local file = io.open(path, "w+")
		
		local fileContent = file:read("*a")
		local newData = data 
		file:write(newData)
		
	
		io.close(file)
	end
	
	local function savetoUserNameFile(data)
		local path = system.pathForFile("userName.txt", system.DocumentsDirectory)
		local file = io.open(path, "w+")
		
		local fileContent = file:read("*a")
		local newData = data 
		file:write(newData)
		
	
		io.close(file)
	end
	
local function loadTextFile( fname, base )
	local base = base or system.DocumentsDirectory
	local path = system.pathForFile( fname, base )
	local txtData
	local file = io.open( path, "r" )
	if file then
	   txtData = file:read( "*a" )
	   io.close( file )
	end
	return txtData
end

savedFirstTime = loadTextFile("lvl"..tostring(levelNumber).."FirstTime.txt")
savedSecondTime = loadTextFile("lvl"..tostring(levelNumber).."SecondTime.txt")
savedThirdTime = loadTextFile("lvl"..tostring(levelNumber).."ThirdTime.txt")

savedFirstName = loadTextFile("lvl"..tostring(levelNumber).."FirstName.txt")
savedSecondName = loadTextFile("lvl"..tostring(levelNumber).."SecondName.txt")
savedThirdName = loadTextFile("lvl"..tostring(levelNumber).."ThirdName.txt")



	local function inputListener( event )
		if event.phase == "submitted" then
			lvl1Name = event.target.text
			native.setKeyboardFocus(nil)
			savetoUserNameFile(lvl1Name)
		end
	end

	local function completeBtnClicked (event)
		levels[levelNumber] = 3
		savedUserName = loadTextFile("userName.txt")
		if firstPlace == true then
			savetoFirstNameFile(savedUserName)
			
			elseif secondPlace == true then
			savetoSecondNameFile(savedUserName)
			else
			savetoThirdNameFile(savedUserName)
		end
			userName:removeSelf()
			userName = nil
			firstPlace = false
			secondPlace = false
			thirdPlace = false
		completegameBtn.destination = "highScores"..tostring(levelNumber)
		completegameBtn:addEventListener("tap", buttonHit)
	end
	
	local function okBtnClicked (event)
		levels[levelNumber] = 3
		okBtn.destination = "highScores"..tostring(levelNumber)
		okBtn:addEventListener("tap", buttonHit)
	end
	
			local title = display.newText( tostring(lvl1Time) .. " seconds", 0, 0, "Helvetica", 20 )
			title.x = display.contentWidth *0.5
			title.y = display.screenOriginY + 140
			group:insert(title)
			
			enterName = display.newText( "Enter your name!", 0, 0, "Helvetica", 13 )
			enterName.x = display.contentWidth *0.5
			enterName.y = display.screenOriginY + 170
			enterName.isVisible = true
			group:insert(enterName)
	
	
	completegameBtn = widget.newButton { label = "Submit Time", labelColor = { default={255}, over={128} },
	onRelease=completeBtnClicked, defaultFile="mainButton2.png", width=164, height=35,
		overFile="mainButtonOver.png"}
	completegameBtn.x = 240
	completegameBtn.y = 250
	completegameBtn.isVisible = false
	group:insert( completegameBtn )
	
	okBtn = widget.newButton { label = "OK", labelColor = { default={255}, over={128} },
	onRelease=okBtnClicked, defaultFile="mainButton2.png", width=164, height=35,
		overFile="mainButtonOver.png"}
	okBtn.x = 240
	okBtn.y = 250
	okBtn.isVisible = false
	group:insert( okBtn )
	
	if savedFirstTime == nil then
	
		loadSavedUserName = loadTextFile("userName.txt")
	
		savetoFirstFile(lvl1Time)
		completegameBtn.isVisible = true
		firstPlace = true
		
			userName = native.newTextField(200, 120, 150, 35)
			userName.inputType = "default"
			userName.align = "center"
			if loadSavedUserName == nil then
				userName.text = " "
			else
				userName.text = loadSavedUserName
			end
			userName.size = 12
			userName.x = display.contentWidth*0.5
			userName.y = display.contentHeight - 120
			userName:addEventListener("userInput", inputListener)
			group:insert(userName)
			
		elseif lvl1Time < tonumber(savedFirstTime) then
		
			loadSavedUserName = loadTextFile("userName.txt")
		
			if savedSecondTime ~= nil then
			savetoThirdFile( tostring(savedSecondTime) )
			savetoThirdNameFile( savedSecondName )
			end
			savetoSecondFile(savedFirstTime)
			savetoSecondNameFile(savedFirstName)
			savetoFirstFile(lvl1Time)
			completegameBtn.isVisible = true
			firstPlace = true
			
			userName = native.newTextField(200, 120, 150, 35)
			userName.inputType = "default"
			userName.align = "center"
			if loadSavedUserName == nil then
				userName.text = " "
			else
				userName.text = loadSavedUserName
			end
			userName.size = 12
			userName.x = display.contentWidth*0.5
			userName.y = display.contentHeight - 120
			userName:addEventListener("userInput", inputListener)
			group:insert(userName)
		
		elseif savedSecondTime == nil then
	
		loadSavedUserName = loadTextFile("userName.txt")
		
		savetoSecondFile(lvl1Time)
		completegameBtn.isVisible = true
		secondPlace = true
		
			userName = native.newTextField(200, 120, 150, 35)
			userName.inputType = "default"
			userName.align = "center"
			if loadSavedUserName == nil then
				userName.text = " "
			else
				userName.text = loadSavedUserName
			end
			userName.size = 12
			userName.x = display.contentWidth*0.5
			userName.y = display.contentHeight - 120
			userName:addEventListener("userInput", inputListener)
			group:insert(userName)
		
		elseif lvl1Time < tonumber(savedSecondTime) then
		
			loadSavedUserName = loadTextFile("userName.txt")
			
			savetoThirdFile(savedSecondTime)
			savetoThirdNameFile(savedSecondName)
			savetoSecondFile(lvl1Time)
			completegameBtn.isVisible = true
			secondPlace = true
			
			userName = native.newTextField(200, 120, 150, 35)
			userName.inputType = "default"
			userName.align = "center"
			if loadSavedUserName == nil then
				userName.text = " "
			else
				userName.text = loadSavedUserName
			end
			userName.size = 12
			userName.x = display.contentWidth*0.5
			userName.y = display.contentHeight - 120
			userName:addEventListener("userInput", inputListener)
			group:insert(userName)
			
		elseif savedThirdTime == nil then
	
		loadSavedUserName = loadTextFile("userName.txt")
		
		savetoThirdFile(lvl1Time)
		completegameBtn.isVisible = true
		thirdPlace = true
		
			userName = native.newTextField(200, 120, 150, 35)
			userName.inputType = "default"
			userName.align = "center"
			if loadSavedUserName == nil then
				userName.text = " "
			else
				userName.text = loadSavedUserName
			end
			userName.size = 12
			userName.x = display.contentWidth*0.5
			userName.y = display.contentHeight - 120
			userName:addEventListener("userInput", inputListener)
			group:insert(userName)
	
		elseif lvl1Time < tonumber(savedThirdTime) then
		
			loadSavedUserName = loadTextFile("userName.txt")
			
			savetoThirdFile(lvl1Time)
			completegameBtn.isVisible = true
			thirdPlace = true
			
			userName = native.newTextField(200, 120, 150, 35)
			userName.inputType = "default"
			userName.align = "center"
			if loadSavedUserName == nil then
				userName.text = " "
			else
				userName.text = loadSavedUserName
			end
			userName.size = 12
			userName.x = display.contentWidth*0.5
			userName.y = display.contentHeight - 120
			userName:addEventListener("userInput", inputListener)
			group:insert(userName)
			
		else
			local title = display.newText( "Sorry No Best Time....", 0, 0, "Helvetica", 20 )
			title.x = display.contentWidth *0.5
			title.y = display.screenOriginY + 180
			group:insert(title)
			enterName.isVisible = false
			okBtn.isVisible = true
end
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	 
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene