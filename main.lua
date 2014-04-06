require "func"
BoardH = true
BoardW = false
GameStart = false
Current = "House"

--Love2D call loads these first
function love.load()	
	--Images for background and starting square.
	quad = love.graphics.newQuad(0,0,50,50,50,50)
	bg = love.graphics.newImage("assets/images/BG.png")
	startimg = love.graphics.newImage("assets/images/StartGrid.png")

	--Mouse position when clicked
	mPosX = 0
	mPosY = 0
	
	--Counters so that too many squares are not placed
	startCnt = 0
	startbtn = 0

	--Variables for animation of squares. t refers to speed based on time, BPM as well. Pls is for color changing (Pulse)
	t = 0
	f = 0
	bpm = 60.25
	Pls = 25
end

--Love2D call, update each frame
function love.update(dt)
	if GameStart == true then
		--Setting up Pulse effect for animations
		Pls = Pls + (dt*500) 
		if Pls >= 128 then 
			Pls = 0
		end

		x_Coord = (((love.graphics.getWidth()/Brd.grdSz) - Brd.x)/2)*Brd.grdSz
		y_Coord = (((love.graphics.getHeight()/Brd.grdSz) - Brd.y)/2)*Brd.grdSz 

		Squares(dt)

		--Flashing animaitons around the edge of the board when the square meets the edge
		FlashSq(dt)
	end
end

--Love2D call for drawing all objects
function love.draw()
	if GameStart == true then
		love.graphics.setColor(255,255,255)
		love.graphics.print(Current, 700, 10)
		love.graphics.print("Press C to change style", 530, 525)
		--Mouse position on left click
	    if love.mouse.isDown("l") then
			mPosX, mPosY = love.mouse.getPosition()  
			--Used to place the starting square and figure out square position based on mouse position
			MouseClick()	
		end
		--Creates the board that is automatically centered on screen based on width and height 
		CreateBoard(Brd.x, Brd.y)

		if startbtn > 0 then
			if Brd.plyCol.l == 1 then
				FlashLeft()
			end
			if Brd.plyCol.u == 1 then
				FlashUp()
			end
			if Brd.plyCol.r == 1 then
				FlashRight()
			end
			if Brd.plyCol.d == 1 then
				FlashDown()
			end
			if Brd.plyCol.d == 1 and Brd.plyCol.r == 1 and Brd.plyCol.u == 1 and Brd.plyCol.l == 1 then
				FlashCent()
			end
		end
		function love.keypressed(music)
		if music == "c" then
			if Play.u == HSnd.u then
				Current = "Dubstep"
				Play.u = DSnd.u
				Play.r = DSnd.r
				Play.d = DSnd.d
				Play.l = DSnd.l
				Play.a = DSnd.a
			elseif Play.u == DSnd.u then
				Current = "House"
				Play.u = HSnd.u
				Play.r = HSnd.r
				Play.d = HSnd.d
				Play.l = HSnd.l
				Play.a = HSnd.a
			end
		end
	end
		--function draws the squares on the board based on width and height as the flashing anims
		drawStart()
	end
	if BoardH == true then
		BoardHeight()
	end
	if BoardW == true then
		BoardWidth()
	end
end






