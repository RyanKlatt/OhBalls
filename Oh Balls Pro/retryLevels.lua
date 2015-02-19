--retryLevels.lua

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"

local sceneName = storyboard.getPrevious()



-- 'onRelease' event listener for levelSelectBtn
local function onLevelSelectBtnRelease()
	storyboard.gotoScene( levelSelect, "fade", 500 )
	return true	-- indicates successful touch
end

local function onResetLevelBtnRelease()
	storyboard.gotoScene( sceneName, "fade", 500 )
	return true	-- indicates successful touch
end

local function onMainMenuBtnRelease()
	storyboard.gotoScene( "menu", "fade", 500 )
	return true	-- indicates successful touch
end


function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "retryBackground1.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	-- create a widget button (which will loads level selection on release)
	local resetLevelBtn = widget.newButton{
		label="Reset Level",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=164, height=35,
		onRelease = onResetLevelBtnRelease	-- event listener function
	}
	resetLevelBtn:setReferencePoint( display.CenterReferencePoint )
	resetLevelBtn.x = display.contentWidth*0.5
	resetLevelBtn.y = display.contentHeight - 175
	
	local levelSelectBtn = widget.newButton{
		label="Select Level",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=164, height=35,
		onRelease = onLevelSelectBtnRelease	-- event listener function
	}
	levelSelectBtn:setReferencePoint( display.CenterReferencePoint )
	levelSelectBtn.x = display.contentWidth*0.5
	levelSelectBtn.y = display.contentHeight - 135
	
	local mainMenuBtn = widget.newButton{
		label="Main Menu",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=164, height=35,
		onRelease = onMainMenuBtnRelease	-- event listener function
	}
	mainMenuBtn:setReferencePoint( display.CenterReferencePoint )
	mainMenuBtn.x = display.contentWidth*0.5
	mainMenuBtn.y = display.contentHeight - 95
	
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( resetLevelBtn )
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