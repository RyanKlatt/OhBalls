-----------------------------------------------------------------------------------------
--
-- level10.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--physics.setDrawMode("hybrid")


local widget = require "widget"
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

local prevFrameTime, currentFrameTime --both nil
local deltaFrameTime = 0
local totalTime = 0
local number = 0
levelSelect = "levelSelect"

local function roundDec(n, X)
		local d = 10 ^ X  
   
		return math.round(n * d) / d 
	end


	local function enterFrame(e)
     local currentFrameTime = system.getTimer() 

    --if this is still nil, then it is the first frame 
    --so no need to perform calculation 
    if prevFrameTime then 
        --calculate how many milliseconds since last frame 
        deltaFrameTime = currentFrameTime - prevFrameTime
     end 
    prevFrameTime = currentFrameTime 
    --this is the total time in milliseconds 
    totalTime = totalTime + deltaFrameTime 

    --multiply by 0.001 to get time in seconds 
    txt_counter.text = roundDec(totalTime * 0.001, 3)
	number = tonumber(txt_counter.text)
	
	txt_counter:setReferencePoint(display.TopLeftReferencePoint)
	
	txt_counter.x = 170
	txt_counter.y = 288
	
end

local function buttonBack(event)
	storyboard.gotoScene ( event.target.destination, {effect = "slideUp"} )
	print( event.target.destination)
		return true
end

local function buttonStart(event)
	physics.setGravity(0, 9.8)
	physics.start()
	
end

local function buttonRetry(event)
	storyboard.gotoScene ( event.target.destination, {effect = "slideUp"} )
	print( event.target.destination)
		return true
end

local function onBlueCollision(event)
	local collision = event.other
    if collision.myName == "blueBall" then
        event.contact.isEnabled = true
		blueRedTarget.isVisible = true
		blueBall:removeSelf()
		blueBallRemoved = true
    end
	if (greenBallRemoved == true) and (blueBallRemoved == true) then
		storyboard.gotoScene (  "lvlComplete" , {effect = "fade", time = 800} )
		lvl1Time = number
		levelNumber = 10
		return lvl1Time
	end
return true
end

local function onGreenCollision(event)
	local collision = event.other
    if collision.myName == "greenBall" then
        event.contact.isEnabled = true
		greenRedTarget.isVisible = true
		greenBall:removeSelf()
		greenBallRemoved = true
    end
	if (greenBallRemoved == true) and (blueBallRemoved == true) then
	storyboard.gotoScene (  "lvlComplete" , {effect = "fade", time = 800} )
	lvl1Time = number
	levelNumber = 10
	return lvl1Time
	end
return true
end

local function onUpGravityCollision(event)
	local collision = event.other
	if collision.myName == "blueBall" then
	event.contact.isEnabled = true
	blueBall:applyLinearImpulse( 0, -1.3, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( 0, -1.3, greenBall.x, greenBall.y )
	end
	
end

local function onDownGravityCollision(event)
	local collision = event.other
	if collision.myName == "blueBall" then
	event.contact.isEnabled = true
	blueBall:applyLinearImpulse( 0, 0.6, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( 0, 0.6, greenBall.x, greenBall.y )
	end
	
end

local function onRightGravityCollision(event)
	local collision = event.other
	if collision.myName == "blueBall" then
	event.contact.isEnabled = true
	blueBall:applyLinearImpulse( 0.6, 0, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( 0.6, 0, greenBall.x, greenBall.y )
	end
	
end

local function onLeftGravityCollision(event)
	local collision = event.other
	if collision.myName == "blueBall" then
	event.contact.isEnabled = true
	blueBall:applyLinearImpulse( -0.6, 0, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( -0.6, 0, greenBall.x, greenBall.y )
	end
	
end

local function onTouch( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		-- Make target the top-most object
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )

		-- Spurious events can be sent to the target, e.g. the user presses 
		-- elsewhere on the screen and then moves the finger over the target.
		-- To prevent this, we add this flag. Only when it's true will "move"
		-- events be sent to the target.
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			t.x = event.x - t.x0
			t.y = event.y - t.y0
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end

	-- Important to return true. This tells the system that the event
	-- should not be propagated to listeners of any objects underneath.
	return true
end

	

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "level1Background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	group:insert( background )
	
	blueTarget = display.newImageRect( "blueTarget.png", 20, 20 )
	blueTarget.x, blueTarget.y = 125, 240
	physics.addBody( blueTarget, "static", {isSensor=true, radius=10})
	blueTarget:addEventListener("collision", onBlueCollision)
	group:insert( blueTarget )
	
	blueRedTarget = display.newImageRect( "redTarget.png", 20, 20 )
	blueRedTarget.x, blueRedTarget.y = 125, 240
	physics.addBody( blueRedTarget, "static", {isSensor=true, radius=10})
	blueRedTarget.isVisible = false
	group:insert( blueRedTarget )
	
	greenTarget = display.newImageRect( "greenTarget.png", 20, 20 )
	greenTarget.x, greenTarget.y = 435, 235
	physics.addBody( greenTarget, "static", {isSensor=true, radius=10})
	greenTarget:addEventListener("collision", onGreenCollision)
	group:insert( greenTarget )
	
	greenRedTarget = display.newImageRect( "redTarget.png", 20, 20 )
	greenRedTarget.x, greenRedTarget.y = 435, 235
	physics.addBody( greenRedTarget, "static", {isSensor=true, radius=10})
	greenRedTarget.isVisible = false
	group:insert( greenRedTarget )
	
	-- make a ball
	blueBall = display.newCircle( 65, 15, 8 )
	blueBall:setFillColor( 0, 0, 255)
	blueBall.myName = "blueBall"
	physics.addBody( blueBall, { density=0.8, friction=0.5, bounce=0.5, radius=8 } )
	blueBall.isBullet = true
	blueBall.isSleepingAllowed = false
	group:insert( blueBall )
	
		-- make a ball
	greenBall = display.newCircle( 430, 15, 8)
	greenBall:setFillColor( 0, 255, 0)
	greenBall.myName = "greenBall"
	physics.addBody( greenBall, { density=0.8, friction=0.5, bounce=0.5, radius=8 } )
	greenBall.isBullet = true
	greenBall.isSleepingAllowed = false
	group:insert( greenBall )
	
	local staticPart1 = display.newImageRect( "staticPart1.png", 220, 7 )
	staticPart1.x, staticPart1.y = 50, 110
	staticPart1.rotation = 90
	physics.addBody( staticPart1, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart1 )
	
	local staticPart2 = display.newImageRect( "staticPart1.png", 220, 7 )
	staticPart2.x, staticPart2.y = 445, 110
	staticPart2.rotation = 90
	physics.addBody( staticPart2, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart2 )
	
	local staticPart3 = display.newImageRect( "staticPart1.png", 310, 7 )
	staticPart3.x, staticPart3.y = 260, 225
	staticPart3.rotation = 0
	physics.addBody( staticPart3, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart3 )
	
	local staticPart4 = display.newImageRect( "staticPart1.png", 385, 7 )
	staticPart4.x, staticPart4.y = 248, 2
	staticPart4.rotation = 0
	physics.addBody( staticPart4, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart4 )
	
	local staticPart5 = display.newImageRect( "staticPart1.png", 165, 7 )
	staticPart5.x, staticPart5.y = 135, 40
	staticPart5.rotation = 0
	physics.addBody( staticPart5, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart5 )
	
	local staticPart6 = display.newImageRect( "staticPart1.png", 120, 7 )
	staticPart6.x, staticPart6.y = 340, 40
	staticPart6.rotation = 0
	physics.addBody( staticPart6, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart6 )
	
	local staticPart7 = display.newImageRect( "staticPart1.png", 120, 7 )
	staticPart7.x, staticPart7.y = 340, 85
	staticPart7.rotation = 0
	physics.addBody( staticPart7, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart7 )
	
	local staticPart8 = display.newImageRect( "staticPart1.png", 130, 7 )
	staticPart8.x, staticPart8.y = 155, 85
	staticPart8.rotation = 0
	physics.addBody( staticPart8, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart8 )
	
	local staticPart9 = display.newImageRect( "staticPart1.png", 50, 7 )
	staticPart9.x, staticPart9.y = 250, 30
	staticPart9.rotation = 90
	physics.addBody( staticPart9, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart9 )
	
	local staticPart10 = display.newImageRect( "staticPart1.png", 100, 7 )
	staticPart10.x, staticPart10.y = 250, 140
	staticPart10.rotation = 90
	physics.addBody( staticPart10, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart10 )

	
	local staticPart12 = display.newImageRect( "staticPart1.png", 70, 7 )
	staticPart12.x, staticPart12.y = 395, 125
	staticPart12.rotation = 90
	physics.addBody( staticPart12, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart12 )
	
	local staticPart13 = display.newImageRect( "staticPart1.png", 160, 7 )
	staticPart13.x, staticPart13.y = 360, 190
	staticPart13.rotation = 0
	physics.addBody( staticPart13, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart13 )
	
	local staticPart14 = display.newImageRect( "staticPart1.png", 25, 7 )
	staticPart14.x, staticPart14.y = 345, 170
	staticPart14.rotation = 90
	physics.addBody( staticPart14, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart14 )
	
	local staticPart15 = display.newImageRect( "staticPart1.png", 37, 7 )
	staticPart15.x, staticPart15.y = 276, 120
	staticPart15.rotation = 0
	physics.addBody( staticPart15, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart15 )
	
	local staticPart16 = display.newImageRect( "staticPart1.png", 45, 7 )
	staticPart16.x, staticPart16.y = 300, 140
	staticPart16.rotation = 90
	physics.addBody( staticPart16, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart16 )
	
	local staticPart17 = display.newImageRect( "staticPart1.png", 100, 7 )
	staticPart17.x, staticPart17.y = 220, 140
	staticPart17.rotation = 90
	physics.addBody( staticPart17, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart17 )
	
	local staticPart18 = display.newImageRect( "staticPart1.png", 37, 7 )
	staticPart18.x, staticPart18.y = 218, 195
	staticPart18.rotation = 0
	physics.addBody( staticPart18, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart18 )
	
	local staticPart19 = display.newImageRect( "staticPart1.png", 50, 7 )
	staticPart19.x, staticPart19.y = 80, 145
	staticPart19.rotation = 90
	physics.addBody( staticPart19, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart19 )
	
	local staticPart20 = display.newImageRect( "staticPart1.png", 90, 7 )
	staticPart20.x, staticPart20.y = 110, 195
	staticPart20.rotation = 0
	physics.addBody( staticPart20, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart20 )
	
	local staticPart21 = display.newImageRect( "staticPart1.png", 80, 7 )
	staticPart21.x, staticPart21.y = 180, 160
	staticPart21.rotation = 90
	physics.addBody( staticPart21, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart21 )
	
	local staticPart22 = display.newImageRect( "staticPart1.png", 40, 7 )
	staticPart22.x, staticPart22.y = 130, 130
	staticPart22.rotation = 0
	physics.addBody( staticPart22, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart22 )
	
	local staticPart23 = display.newImageRect( "staticPart1.png", 30, 7 )
	staticPart23.x, staticPart23.y = 130, 150
	staticPart23.rotation = 90
	physics.addBody( staticPart23, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart23 )
	
	local staticPart24 = display.newImageRect( "staticPart1.png", 25, 7 )
	staticPart24.x, staticPart24.y = 130, 95
	staticPart24.rotation = 90
	physics.addBody( staticPart24, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart24 )
	
	local staticPart25 = display.newImageRect( "staticPart1.png", 25, 7 )
	staticPart25.x, staticPart25.y = 360, 50
	staticPart25.rotation = 90
	physics.addBody( staticPart25, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart25 )
	
	local accelUp = display.newImageRect( "accelUp.png", 25, 25 )
	accelUp.x, accelUp.y = 15, 10
	accelUp.rotation = 360
	physics.addBody( accelUp, "static", { isSensor=true, radius = 11} )
	accelUp.isSleepingAllowed = false
	accelUp:addEventListener("collision", onUpGravityCollision)
	accelUp:addEventListener( "touch", onTouch )
	group:insert( accelUp )
	
	local accelRight = display.newImageRect( "accelUp.png", 25, 25 )
	accelRight.x, accelRight.y = 15, 40
	accelRight.rotation = 90
	physics.addBody( accelRight, "static", { isSensor=true, radius = 11} )
	accelRight.isSleepingAllowed = false
	accelRight:addEventListener("collision", onRightGravityCollision)
	accelRight:addEventListener( "touch", onTouch )
	group:insert( accelRight )
	
	local accelRight2 = display.newImageRect( "accelUp.png", 25, 25 )
	accelRight2.x, accelRight2.y = 15, 100
	accelRight2.rotation = 90
	physics.addBody( accelRight2, "static", { isSensor=true, radius = 11} )
	accelRight2.isSleepingAllowed = false
	accelRight2:addEventListener("collision", onRightGravityCollision)
	accelRight2:addEventListener( "touch", onTouch )
	group:insert( accelRight2 )
	
	local accelLeft = display.newImageRect( "accelUp.png", 25, 25 )
	accelLeft.x, accelLeft.y = 15, 70
	accelLeft.rotation = 270
	physics.addBody( accelLeft, "static", { isSensor=true, radius = 11} )
	accelLeft.isSleepingAllowed = false
	accelLeft:addEventListener("collision", onLeftGravityCollision)
	accelLeft:addEventListener( "touch", onTouch )
	group:insert( accelLeft )
	
	local accelLeft2 = display.newImageRect( "accelUp.png", 25, 25 )
	accelLeft2.x, accelLeft2.y = 15, 130
	accelLeft2.rotation = 270
	physics.addBody( accelLeft2, "static", { isSensor=true, radius = 11} )
	accelLeft2.isSleepingAllowed = false
	accelLeft2:addEventListener("collision", onLeftGravityCollision)
	accelLeft2:addEventListener( "touch", onTouch )
	group:insert( accelLeft2 )
	
	local accelLeft3 = display.newImageRect( "accelUp.png", 25, 25 )
	accelLeft3.x, accelLeft3.y = 15, 160
	accelLeft3.rotation = 270
	physics.addBody( accelLeft3, "static", { isSensor=true, radius = 11} )
	accelLeft3.isSleepingAllowed = false
	accelLeft3:addEventListener("collision", onLeftGravityCollision)
	accelLeft3:addEventListener( "touch", onTouch )
	group:insert( accelLeft3 )
	
	local whiteCircle = display.newCircle( 240, 140, 20)
	whiteCircle.strokeWidth = 2
	whiteCircle:setStrokeColor( 255, 255, 255)
	whiteCircle:setFillColor( 0, 0, 0)
	physics.addBody( whiteCircle, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	whiteCircle:addEventListener( "touch", onTouch )
	group:insert( whiteCircle )
	
	local whiteCircle2 = display.newCircle( 240, 180, 20)
	whiteCircle2.strokeWidth = 2
	whiteCircle2:setStrokeColor( 255, 255, 255)
	whiteCircle2:setFillColor( 0, 0, 0)
	physics.addBody( whiteCircle2, "static", { density=10.0, friction=0.5, bounce=0, radius=20 } )
	whiteCircle2:addEventListener( "touch", onTouch )
	group:insert( whiteCircle2 )

	
	-- create a grass object and add physics (with custom shape)
	local levelFloor = display.newImageRect( "staticFloor.png", 1200, 65 )
	levelFloor.x, levelFloor.y = 0, 290
	physics.addBody( levelFloor, "static", { friction=0.3 } )
	group:insert( levelFloor )
	
	local startBtn = display.newImageRect(  "startBtn.png", 50, 50 )
	startBtn.x = 450
	startBtn.y = display.contentHeight  - 30
	startBtn:addEventListener("tap", buttonStart)
	group:insert( startBtn)
	
	local retryBtn = display.newImageRect(  "retryOrExit.png", 50, 50 )
	retryBtn.x = display.screenOriginX + 30
	retryBtn.y = display.contentHeight  - 30
	retryBtn.destination = "retryLevels"
	retryBtn:addEventListener("tap",  buttonRetry)
	group:insert( retryBtn )

	local testBtn = display.newImageRect(  "testGravity.png", 50, 50 )
	testBtn.x = 390
	testBtn.y = display.contentHeight  - 30
	testBtn:addEventListener("tap", buttonStart)
	group:insert( testBtn)
	
	txt_counter = display.newText( number, 0, 0, native.systemFont, 20 )
	txt_counter.x = 170
	txt_counter.y = 300
	txt_counter:setTextColor( 255, 255, 255 )
	group:insert( txt_counter )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	storyboard.removeAll()
	lvl1Time = 0
		
	Runtime:addEventListener( "enterFrame", enterFrame )
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	
	blueBallRemoved = false
	greenBallRemoved = false
	
	Runtime:removeEventListener( "enterFrame", enterFrame )
	
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