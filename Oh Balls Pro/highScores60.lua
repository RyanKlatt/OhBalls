--highScores60.lua

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"

local resetLevelBtn
local levelSelectBtn


-- 'onRelease' event listener for levelSelectBtn
local function onLevelSelectBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "levelSelect4", "fade", 500 )
	return true	-- indicates successful touch
end

local function onPlayLevelBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "level60", "fade", 500 )
	return true	-- indicates successful touch
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

savedFirstTime = loadTextFile("lvl60FirstTime.txt")
savedSecondTime = loadTextFile("lvl60SecondTime.txt")
savedThirdTime = loadTextFile("lvl60ThirdTime.txt")

if savedFirstTime == nil then
	savedFirstTime = ""
end

if savedSecondTime == nil then
	savedSecondTime = ""
end

if savedThirdTime == nil then
	savedThirdTime = ""
end

savedFirstName = loadTextFile("lvl60FirstName.txt")
savedSecondName = loadTextFile("lvl60SecondName.txt")
savedThirdName = loadTextFile("lvl60ThirdName.txt")

if savedFirstName == nil then
	savedFirstName = "No best time yet!"
end

if savedSecondName == nil then
	savedSecondName = "No best time yet!"
end

if savedThirdName == nil then
	savedThirdName = "No best time yet!"
end



function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "highScoresBackground.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	local title = display.newText( "Level 60", 0, 0, "Helvetica", 27 )
	title.x = 240
	title.y = display.contentHeight - 215
	
	local firstPlace = display.newText( "1st: ".. tostring(savedFirstName), 0, 0, "Helvetica", 19 )
	firstPlace.x = 185
	firstPlace.y = display.contentHeight - 180
	
	local firstPlaceTime = display.newText( tostring(savedFirstTime) .. "(seconds)", 0, 0, "Helvetica", 19 )
	firstPlaceTime.x = 320
	firstPlaceTime.y = display.contentHeight - 180
	
	local secondPlace = display.newText( "2nd: ".. tostring(savedSecondName), 0, 0, "Helvetica", 19 )
	secondPlace.x = 185
	secondPlace.y = display.contentHeight - 155
	
	local secondPlaceTime = display.newText( tostring(savedSecondTime) .. "(seconds)", 0, 0, "Helvetica", 19 )
	secondPlaceTime.x = 320
	secondPlaceTime.y = display.contentHeight - 155
	
	local thirdPlace = display.newText( "3rd: ".. tostring(savedThirdName), 0, 0, "Helvetica", 19 )
	thirdPlace.x = 185
	thirdPlace.y = display.contentHeight - 130
	
	local thirdPlaceTime = display.newText( tostring(savedThirdTime) .. "(seconds)", 0, 0, "Helvetica", 19 )
	thirdPlaceTime.x = 320
	thirdPlaceTime.y = display.contentHeight - 130
	
	levelSelectBtn = widget.newButton{
		label="Select Level",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=164, height=35,
		onRelease = onLevelSelectBtnRelease	-- event listener function
	}
	levelSelectBtn:setReferencePoint( display.CenterReferencePoint )
	levelSelectBtn.x = display.contentWidth*0.5
	levelSelectBtn.y = display.contentHeight - 25
	
		-- create a widget button (which will loads level selection on release)
	mainMenuBtn = widget.newButton{
		label="Play Level",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=164, height=35,
		onRelease = onPlayLevelBtnRelease	-- event listener function
	}
	mainMenuBtn:setReferencePoint( display.CenterReferencePoint )
	mainMenuBtn.x = display.contentWidth*0.5
	mainMenuBtn.y = display.contentHeight - 65
	
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( title )
	group:insert( firstPlace )
	group:insert( firstPlaceTime )
	group:insert( secondPlace )
	group:insert( secondPlaceTime )
	group:insert( thirdPlace )
	group:insert( thirdPlaceTime )
	group:insert( levelSelectBtn )
	group:insert( mainMenuBtn )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view


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
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
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