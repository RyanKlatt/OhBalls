--highScores.lua

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"

local resetLevelBtn
local levelSelectBtn

-- 'onRelease' event listener for levelSelectBtn
local function onLevelSelectBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "lvlHighScores", "fade", 500 )
	return true	-- indicates successful touch
end

local function onMainMenuBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "menu", "fade", 500 )
	return true	-- indicates successful touch
end


function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "highScoresBackground.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	local title = display.newText( "Name     Time(seconds)", 0, 0, "Helvetica", 20 )
	title.x = 265
	title.y = display.contentHeight - 205
	
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
		label="Main Menu",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=164, height=35,
		onRelease = onMainMenuBtnRelease	-- event listener function
	}
	mainMenuBtn:setReferencePoint( display.CenterReferencePoint )
	mainMenuBtn.x = display.contentWidth*0.5
	mainMenuBtn.y = display.contentHeight - 65
	
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( title )
	group:insert( levelSelectBtn )
	group:insert( mainMenuBtn )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	storyboard.removeAll()
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