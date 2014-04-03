require "func"

--Love2D call loads these first
function love.load()	
	--Images for background and starting square.
	quad = love.graphics.newQuad(0,0,50,50,50,50)
	bg = love.graphics.newImage("assets/images/BG.png")
	startimg = love.graphics.newImage("assets/images/StartGrid.png")

	--Sounds played when square touches wall (Start, Left, Right, Up, Down, All)
	Snd = {}
	Snd.s = love.audio.newSource("assets/audio/StartSound.mp3", static)
	Snd.r = love.audio.newSource("assets/audio/RightSound.mp3", static)
	Snd.d = love.audio.newSource("assets/audio/DownSound.mp3", static)
	Snd.l = love.audio.newSource("assets/audio/LeftSound.mp3", static)
	Snd.u = love.audio.newSource("assets/audio/UpSound.mp3", static)
	Snd.a = love.audio.newSource("assets/audio/AllSound.mp3", static)

	--Mouse position when clicked
	mPosX = 0
	mPosY = 0
	
	--Counters so that too many squares are not placed
	startCnt = 0
	startbtn = 0

	--Variables for animation of squares. t refers to speed based on time, BPM as well. Pls is for color changing (Pulse)
	t = 0
	bpm = 60.25
	Pls = 25
end

--Love2D call, update each frame
function love.update(dt)
	--Setting up Pulse effect for animations
	Pls = Pls + (dt*500) 
	if Pls >= 128 then 
		Pls = 0
	end

	x_Coord = (((love.graphics.getWidth()/Brd.grdSz) - Brd.x)/2)*Brd.grdSz
	y_Coord = (((love.graphics.getHeight()/Brd.grdSz) - Brd.y)/2)*Brd.grdSz 

	Squares(dt)
end

--Love2D call for drawing all objects
function love.draw()
	--Mouse position on left click
    if love.mouse.isDown("l") then
		mPosX, mPosY = love.mouse.getPosition()  
		--Used to place the starting square and figure out square position based on mouse position
		MouseClick()	
	end
	--Creates the board that is automatically centered on screen based on width and height 
	CreateBoard(Brd.x, Brd.y)

	--Flashing animaitons around the edge of the board when the square meets the edge
	FlashSq()
	
	--function draws the squares on the board based on width and height as the flashing anims
	drawStart()
end






