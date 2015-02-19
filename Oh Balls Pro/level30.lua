-----------------------------------------------------------------------------------------
--
-- level30.lua
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
levelSelect = "levelSelect2"

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
		storyboard.gotoScene (  "lvlComplete2" , {effect = "fade", time = 800} )
		lvl1Time = number
		levelNumber = 30
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
	storyboard.gotoScene (  "lvlComplete2" , {effect = "fade", time = 800} )
	lvl1Time = number
	levelNumber = 30
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
	blueBall:applyLinearImpulse( -1.2, 0, blueBall.x, blueBall.y )
	end
	if collision.myName == "greenBall" then
	event.contact.isEnabled = true
	greenBall:applyLinearImpulse( -1.2, 0, greenBall.x, greenBall.y )
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
	blueTarget.x, blueTarget.y = 30, 200
	physics.addBody( blueTarget, "static", {isSensor=true, radius=10})
	blueTarget:addEventListener("collision", onBlueCollision)
	group:insert( blueTarget )
	
	blueRedTarget = display.newImageRect( "redTarget.png", 20, 20 )
	blueRedTarget.x, blueRedTarget.y = 30, 200
	physics.addBody( blueRedTarget, "static", {isSensor=true, radius=10})
	blueRedTarget.isVisible = false
	group:insert( blueRedTarget )
	
	greenTarget = display.newImageRect( "greenTarget.png", 20, 20 )
	greenTarget.x, greenTarget.y = 160, 140
	physics.addBody( greenTarget, "static", {isSensor=true, radius=10})
	greenTarget:addEventListener("collision", onGreenCollision)
	group:insert( greenTarget )
	
	greenRedTarget = display.newImageRect( "redTarget.png", 20, 20 )
	greenRedTarget.x, greenRedTarget.y = 160, 140
	physics.addBody( greenRedTarget, "static", {isSensor=true, radius=10})
	greenRedTarget.isVisible = false
	group:insert( greenRedTarget )
	
	-- make a ball
	blueBall = display.newCircle( 235, 15, 8 )
	blueBall:setFillColor( 0, 0, 255)
	blueBall.myName = "blueBall"
	physics.addBody( blueBall, { density=0.8, friction=0.5, bounce=0.5, radius=8 } )
	blueBall.isSleepingAllowed = false
	group:insert( blueBall )
	
		-- make a ball
	greenBall = display.newCircle( 245, 25, 8)
	greenBall:setFillColor( 0, 255, 0)
	greenBall.myName = "greenBall"
	physics.addBody( greenBall, { density=0.8, friction=0.5, bounce=0.5, radius=8 } )
	greenBall.isSleepingAllowed = false
	group:insert( greenBall )
	
	
	local accelLeft = display.newImageRect( "accelUp.png", 25, 25 )
	accelLeft.x, accelLeft.y = 45, 70
	accelLeft.rotation = 270
	physics.addBody( accelLeft, "static", { isSensor=true, radius = 11} )
	accelLeft.isSleepingAllowed = false
	accelLeft:addEventListener("collision", onLeftGravityCollision)
	accelLeft:addEventListener( "touch", onTouch )
	group:insert( accelLeft )
	
		local redBall = display.newCircle( 375, 145, 4)
	redBall:setFillColor( 128, 0, 0)
	physics.addBody( redBall, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall.gravityScale = -2
	group:insert( redBall )
	
	local redBall2 = display.newCircle( 375, 170, 8)
	redBall2:setFillColor( 128, 0, 0)
	physics.addBody( redBall2, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall2.gravityScale = -2
	group:insert( redBall2 )
	
	local redBall3 = display.newCircle( 375, 120, 4)
	redBall3:setFillColor( 128, 0, 0)
	physics.addBody( redBall3, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall3.gravityScale = -2
	group:insert( redBall3 )
	
	local redBall4 = display.newCircle( 375, 95, 8)
	redBall4:setFillColor( 128, 0, 0)
	physics.addBody( redBall4, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall4.gravityScale = -2
	group:insert( redBall4 )
	
	local redBall5 = display.newCircle( 375, 195, 4)
	redBall5:setFillColor( 128, 0, 0)
	physics.addBody( redBall5, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall5.gravityScale = -2
	group:insert( redBall5 )
	
	local redBall6 = display.newCircle( 285, 195, 8)
	redBall6:setFillColor( 128, 0, 0)
	physics.addBody( redBall6, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall6.gravityScale = -2
	group:insert( redBall6 )
	
	local redBall7 = display.newCircle( 285, 95, 4)
	redBall7:setFillColor( 128, 0, 0)
	physics.addBody( redBall7, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall7.gravityScale = -2
	group:insert( redBall7 )
	
	local redBall8 = display.newCircle( 285, 120, 8)
	redBall8:setFillColor( 128, 0, 0)
	physics.addBody( redBall8, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall8.gravityScale = -2
	group:insert( redBall8 )
	
	local redBall9 = display.newCircle( 285, 170, 4)
	redBall9:setFillColor( 128, 0, 0)
	physics.addBody( redBall9, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall9.gravityScale = -2
	group:insert( redBall9 )
	
	local redBall10 = display.newCircle( 285, 145, 8)
	redBall10:setFillColor( 128, 0, 0)
	physics.addBody( redBall10, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall10.gravityScale = -2
	group:insert( redBall10 )
	
	local redBall11 = display.newCircle( 195, 145, 4)
	redBall11:setFillColor( 128, 0, 0)
	physics.addBody( redBall11, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall11.gravityScale = -2
	group:insert( redBall11 )
	
	local redBall12 = display.newCircle( 195, 170, 8)
	redBall12:setFillColor( 128, 0, 0)
	physics.addBody( redBall12, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall12.gravityScale = -2
	group:insert( redBall12 )
	
	local redBall13 = display.newCircle( 195, 195, 4)
	redBall13:setFillColor( 128, 0, 0)
	physics.addBody( redBall13, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall13.gravityScale = -2
	group:insert( redBall13 )
	
	local redBall14 = display.newCircle( 195, 120, 8)
	redBall14:setFillColor( 128, 0, 0)
	physics.addBody( redBall14, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall14.gravityScale = -2
	group:insert( redBall14 )
	
	local redBall15 = display.newCircle( 195, 95, 4)
	redBall15:setFillColor( 128, 0, 0)
	physics.addBody( redBall15, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall15.gravityScale = -2
	group:insert( redBall15 )
	
	local redBall16 = display.newCircle( 105, 95, 8)
	redBall16:setFillColor( 128, 0, 0)
	physics.addBody( redBall16, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall16.gravityScale = -2
	group:insert( redBall16 )
	
	local redBall17 = display.newCircle( 105, 120, 4)
	redBall17:setFillColor( 128, 0, 0)
	physics.addBody( redBall17, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall17.gravityScale = -2
	group:insert( redBall17 )
	
	local redBall18 = display.newCircle( 105, 145, 8)
	redBall18:setFillColor( 128, 0, 0)
	physics.addBody( redBall18, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall18.gravityScale = -2
	group:insert( redBall18 )
	
	local redBall19 = display.newCircle( 105, 170, 8)
	redBall19:setFillColor( 128, 0, 0)
	physics.addBody( redBall19, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall19.gravityScale = -2
	group:insert( redBall19 )
	
	local redBall20 = display.newCircle( 105, 195, 4)
	redBall20:setFillColor( 128, 0, 0)
	physics.addBody( redBall20, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall20.gravityScale = -2
	group:insert( redBall20 )
	
	local redBall21 = display.newCircle( 385, 145, 4)
	redBall21:setFillColor( 128, 0, 0)
	physics.addBody( redBall21, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall21.gravityScale = 2
	group:insert( redBall21 )
	
	local redBall22 = display.newCircle( 385, 170, 8)
	redBall22:setFillColor( 128, 0, 0)
	physics.addBody( redBall22, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall22.gravityScale = 2
	group:insert( redBall22 )
	
	local redBall23 = display.newCircle( 385, 120, 4)
	redBall23:setFillColor( 128, 0, 0)
	physics.addBody( redBall23, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall23.gravityScale = 2
	group:insert( redBall23 )
	
	local redBall24 = display.newCircle( 385, 95, 8)
	redBall24:setFillColor( 128, 0, 0)
	physics.addBody( redBall24, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall24.gravityScale = 2
	group:insert( redBall24 )
	
	local redBall25 = display.newCircle( 385, 195, 4)
	redBall25:setFillColor( 128, 0, 0)
	physics.addBody( redBall25, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall25.gravityScale = 2
	group:insert( redBall25 )
	
	local redBall26 = display.newCircle( 295, 195, 8)
	redBall26:setFillColor( 128, 0, 0)
	physics.addBody( redBall26, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall26.gravityScale = 2
	group:insert( redBall26 )
	
	local redBall27 = display.newCircle( 295, 95, 4)
	redBall27:setFillColor( 128, 0, 0)
	physics.addBody( redBall27, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall27.gravityScale = 2
	group:insert( redBall27 )
	
	local redBall28 = display.newCircle( 295, 120, 8)
	redBall28:setFillColor( 128, 0, 0)
	physics.addBody( redBall28, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall28.gravityScale = 2
	group:insert( redBall28 )
	
	local redBall29 = display.newCircle( 295, 170, 4)
	redBall29:setFillColor( 128, 0, 0)
	physics.addBody( redBall29, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall29.gravityScale = 2
	group:insert( redBall29 )
	
	local redBall30 = display.newCircle( 295, 145, 8)
	redBall30:setFillColor( 128, 0, 0)
	physics.addBody( redBall30, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall30.gravityScale = 2
	group:insert( redBall30 )
	
	local redBall31 = display.newCircle( 205, 145, 4)
	redBall31:setFillColor( 128, 0, 0)
	physics.addBody( redBall31, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall31.gravityScale = 2
	group:insert( redBall31 )
	
	local redBall32 = display.newCircle( 205, 170, 8)
	redBall32:setFillColor( 128, 0, 0)
	physics.addBody( redBall32, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall32.gravityScale = 2
	group:insert( redBall32 )
	
	local redBall33 = display.newCircle( 205, 195, 4)
	redBall33:setFillColor( 128, 0, 0)
	physics.addBody( redBall33, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall33.gravityScale = 2
	group:insert( redBall33 )
	
	local redBall34 = display.newCircle( 205, 120, 8)
	redBall34:setFillColor( 128, 0, 0)
	physics.addBody( redBall34, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall34.gravityScale = 2
	group:insert( redBall34 )
	
	local redBall35 = display.newCircle( 205, 95, 4)
	redBall35:setFillColor( 128, 0, 0)
	physics.addBody( redBall35, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall35.gravityScale = 2
	group:insert( redBall35 )
	
	local redBall36 = display.newCircle( 115, 95, 8)
	redBall36:setFillColor( 128, 0, 0)
	physics.addBody( redBall36, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall36.gravityScale = 2
	group:insert( redBall36 )
	
	local redBall37 = display.newCircle( 115, 120, 4)
	redBall37:setFillColor( 128, 0, 0)
	physics.addBody( redBall37, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall37.gravityScale = 2
	group:insert( redBall37 )
	
	local redBall38 = display.newCircle( 115, 145, 8)
	redBall38:setFillColor( 128, 0, 0)
	physics.addBody( redBall38, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall38.gravityScale = 2
	group:insert( redBall38 )
	
	local redBall39 = display.newCircle( 115, 170, 8)
	redBall39:setFillColor( 128, 0, 0)
	physics.addBody( redBall39, { density=1.0, friction=0.5, bounce=1, radius=8 } )
	redBall39.gravityScale = 2
	group:insert( redBall39 )
	
	local redBall40 = display.newCircle( 115, 195, 4)
	redBall40:setFillColor( 128, 0, 0)
	physics.addBody( redBall40, { density=1.0, friction=0.5, bounce=1, radius=4 } )
	redBall40.gravityScale = 2
	group:insert( redBall40 )
	
	local staticPart1 = display.newImageRect( "staticPart1.png", 240, 7 )
	staticPart1.x, staticPart1.y = 10, 130
	staticPart1.rotation = 90
	physics.addBody( staticPart1, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart1 )
	
	local staticPart2 = display.newImageRect( "staticPart1.png", 240, 7 )
	staticPart2.x, staticPart2.y = 470, 130
	staticPart2.rotation = 90
	physics.addBody( staticPart2, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart2 )
	
	local staticPart4 = display.newImageRect( "staticPart1.png", 460, 7 )
	staticPart4.x, staticPart4.y = 240, 1
	staticPart4.rotation = 0
	physics.addBody( staticPart4, "static" ,{ density= 0.1, friction=0.1, bounce=.2 } )
	group:insert( staticPart4 )

	
	local smallLevelPart = display.newImageRect( "smallLevelPart.png", 150, 20 )
	smallLevelPart.x, smallLevelPart.y = 360, 245
	smallLevelPart.rotation = 0
	physics.addBody( smallLevelPart, "static", { density= 0.1, friction=0.1, bounce=1 } )
	smallLevelPart:addEventListener( "touch", onTouch )
	group:insert( smallLevelPart )
	
	local smallLevelPart2 = display.newImageRect( "smallLevelPart.png", 55, 20 )
	smallLevelPart2.x, smallLevelPart2.y = 390, 195
	smallLevelPart2.rotation = 35
	physics.addBody( smallLevelPart2, "static", { density= 0.1, friction=0.1, bounce=2 } )
	smallLevelPart2:addEventListener( "touch", onTouch )
	group:insert( smallLevelPart2 )
	
	local smallLevelPart3 = display.newImageRect( "smallLevelPart.png", 75, 20 )
	smallLevelPart3.x, smallLevelPart3.y = 240, 80
	smallLevelPart3.rotation = 80
	physics.addBody( smallLevelPart3, "static", { density= 0.1, friction=0.1, bounce=1 } )
	smallLevelPart3:addEventListener( "touch", onTouch )
	group:insert( smallLevelPart3 )



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