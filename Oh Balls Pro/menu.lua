-----------------------------------------------------------------------------------------
--
-- menu.lua
--Oh Balls Game
--Created by Ryan Klatt
--Date: 10/29/2013
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local levelSelectBtn
local howToBtn

-- 'onRelease' event listener for levelSelectBtn
local function onLevelSelectBtnRelease()
	
	
	storyboard.gotoScene( "levelSelect", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onHowToBtnRelease()
	
	storyboard.gotoScene( "howTo", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onAboutBtnRelease()
	
	storyboard.gotoScene( "about", "fade", 500 )
	
	return true	-- indicates successful touch
end


-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "mainOhBallsBackground.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	
	-- create a widget button (which will loads level selection on release)
	levelSelectBtn = widget.newButton{
		label="Select Level",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=154, height=40,
		onRelease = onLevelSelectBtnRelease	-- event listener function
	}
	levelSelectBtn:setReferencePoint( display.CenterReferencePoint )
	levelSelectBtn.x = display.contentWidth*0.5
	levelSelectBtn.y = display.contentHeight - 165
	
	howToBtn = widget.newButton{
		label="How to Play",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=154, height=40,
		onRelease = onHowToBtnRelease	-- event listener function
	}
	howToBtn:setReferencePoint( display.CenterReferencePoint )
	howToBtn.x = display.contentWidth*0.5
	howToBtn.y = display.contentHeight - 115
	
	aboutBtn = widget.newButton{
		label="About",
		labelColor = { default={255}, over={128} },
		defaultFile="mainButton2.png",
		overFile="mainButtonOver.png",
		width=154, height=40,
		onRelease = onAboutBtnRelease	-- event listener function
	}
	aboutBtn:setReferencePoint( display.CenterReferencePoint )
	aboutBtn.x = display.contentWidth*0.5
	aboutBtn.y = display.contentHeight - 65
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( levelSelectBtn )
	group:insert( howToBtn )
	group:insert( aboutBtn )
	
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
	
	if levelSelectBtn then
		levelSelectBtn:removeSelf()	-- widgets must be manually removed
		levelSelectBtn = nil
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