--
--levelSelect2.lua
--
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local levelstorage = require("levelStorage")
 
-- local forward references should go here --
 
levels4 =
{
1, 1, 1, 1 , 1,  --1 means level is open to 	be played (level.png)
1, 1, 1, 1, 1,   --2 means level is locked (locked.png)
1, 1, 1, 1, 1   -- 3 means level is completed (greenchecked.png)
}

 levels4 = loadLevels4()
 
images4 ={
	{ getFile = "playButton.png", types = "play"   },
	{ getFile = "lock.png", types = "locked"},
	{ getFile = "levelComplete.png", types = "done"}
}
 
local function buttonHit(event)
	storyboard.gotoScene ( event.target.destination, {effect = "fade"} )
	print( event.target.destination)
		return true
end
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
 
	local levelIndex =0
		for i=0,2 do
			for j=1,5 do
				tablePlace =   i*5 + j + 45
				levelIndex = levelIndex + 1
					local imagesId = levels4[levelIndex]
						levelImg = display.newImageRect (images4[imagesId].getFile , 45, 45 )
						levelImg.x = 45 + (j*65)
						levelImg.y  = 85+ (i*65)
						group:insert(levelImg)
 
						leveltxt = display.newText("Level "..tostring(tablePlace), 0,0, "Helvetica", 14)
						leveltxt.x = 45 + (j*65)
						leveltxt .y = 115 + (i*65)
						leveltxt:setTextColor (250, 255, 251)
						group:insert (leveltxt)
 
					    levelImg.destination = "highScores"..tostring(tablePlace)
 
						if images4[imagesId].types ~= "locked" then
						levelImg:addEventListener("tap", buttonHit)
						end
 end
 
end
 
	-- CREATE display objects and add them to 'group' here.
	-- Example use-case: Restore 'group' from previously saved state.
 
	local title = display.newText( "Level Selection", 0, 0, "Helvetica", 30 )
	title.x = display.screenOriginX + 130
	title.y = display.screenOriginY + 30
	group:insert(title)
 
	local backBtn = display.newImageRect(  "backBtn.png", 50, 50 )
	backBtn.x = display.screenOriginX + 30
	backBtn.y = display.contentHeight  - 30
	backBtn.destination = "levelSelect3"
	backBtn:addEventListener("tap", buttonHit)
	group:insert(backBtn)
	
	local moreBtn = display.newImageRect( "moreBtn.png", 50, 50 )
	moreBtn.x = display.screenOriginX + 90
	moreBtn.y = display.contentHeight - 30
	moreBtn.destination = "levelSelect5"
	moreBtn:addEventListener("tap", buttonHit)
	group:insert(moreBtn)
	
	local menuBtn = display.newImageRect( "mainMenuBtn.png", 50, 50 )
	menuBtn.x = display.screenOriginX + 150
	menuBtn.y = display.contentHeight - 30
	menuBtn.destination = "menu"
	menuBtn:addEventListener("tap", buttonHit)
	group:insert(menuBtn)

 
end
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
 
	saveLevels4()
	storyboard.removeAll()
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
 
end
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
 
	-- INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	-- Remove listeners attached to the Runtime, timers, transitions, audio tracks
 
end
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
 
	-- INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	-- Remove listeners attached to the Runtime, timers, transitions, audio tracks
 
end
 
---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )
 
-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
 
-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )
 
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
 
---------------------------------------------------------------------------------
 
return scene