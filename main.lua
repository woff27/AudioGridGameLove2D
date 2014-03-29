function love.load()
	--Aspects of Game Board (width, height, x "squares" wide, y "squares" tall, size of grid in pixels)
	Brd = {}
	Brd.w = 0
	Brd.h = 0
	Brd.x = 7
	Brd.y = 7
	Brd.grdSz = 50

	--plyCol is the current playing column/row in each direction
	Brd.plyCol = {}
	Brd.plyCol.r = 1
	Brd.plyCol.l = 1
	Brd.plyCol.d = 1
	Brd.plyCol.u = 1

	--colEnd is how "far" the square will go before reseting (hitting a wall)
	Brd.colEnd = {}
	Brd.colEnd.r = 1
	Brd.colEnd.l = 1
	Brd.colEnd.u = 1
	Brd.colEnd.d = 1
	
	--Images for background and starting square.
	quad = love.graphics.newQuad(0,0,50,50,50,50)
	bg = love.graphics.newImage("assets/images/BG.png")
	startimg = love.graphics.newImage("assets/images/StartGrid.png")

	--Sounds played when square touches wall (Start, Left, Right, Up, Down, All)
	Snd = {}
	Snd.s = love.audio.newSource("assets/audio/StartSound.mp3", static)
	Snd.s:setLooping(true)
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

	--Variables for animation of squares. T refers to speed based on time, BPM as well. Pls is for color changing (Pulse)
	t = 0
	bpm = 60.25
	Pls = 25

	--Creates the board that is automatically centered on screen based on width and height 
	--@param x == width, @param y == board height
	--xCoord and yCoord are the origin points where board is drawn. Based on window w/h.
	function CreateBoard(x, y)
		Brd.w = Brd.x * Brd.grdSz
		Brd.h = Brd.y * Brd.grdSz

		xCoord = (((love.graphics.getWidth()/Brd.grdSz) - x)/2)*Brd.grdSz
		yCoord = (((love.graphics.getHeight()/Brd.grdSz) - y)/2)*Brd.grdSz

		bgquad = love.graphics.newQuad(xCoord, yCoord, Brd.w, Brd.h, 800, 800)
		--Board image (changes posiiton slightly depending on board w/h)
		love.graphics.setColor(255,255,255,255)
		if Brd.x % 2 == 0 and Brd.y % 2 == 0 then
			bgquad = love.graphics.newQuad(xCoord, yCoord, Brd.w, Brd.h, 800, 800)
		elseif Brd.x % 2 ~= 0 and Brd.y %2 == 0 then
			bgquad = love.graphics.newQuad(xCoord+(Brd.grdSz/2), yCoord, Brd.w, Brd.h, 800, 800)
		elseif Brd.x % 2 == 0 and Brd.y %2 ~= 0 then
			bgquad = love.graphics.newQuad(xCoord, yCoord+(Brd.grdSz/2), Brd.w, Brd.h, 800, 800)
		elseif Brd.x % 2 ~=0 and Brd.y %2 ~= 0 then
			bgquad = love.graphics.newQuad(xCoord+(Brd.grdSz/2), yCoord+(Brd.grdSz/2), Brd.w, Brd.h, 800, 800)		
		end
		love.graphics.draw(bg, bgquad, xCoord, yCoord)
		--Creates invisible grid system over board image
		for h = 1, Brd.y do
			for w = 1, Brd.x do
				Grid = {}
				Grid.x = xCoord
				Grid.y = yCoord 
				Grid.Img = startimg
				table.insert(Brd, Grid)
				xCoord = xCoord + Brd.grdSz
			end
			xCoord = (((love.graphics.getWidth()/Brd.grdSz) - Brd.x)/2)*Brd.grdSz
			yCoord = yCoord + Brd.grdSz
		end
		xCoord = (((love.graphics.getWidth()/Brd.grdSz) - Brd.x)/2)*Brd.grdSz
		yCoord = (((love.graphics.getHeight()/Brd.grdSz) - Brd.y)/2)*Brd.grdSz
	end
end

function love.update(dt)
	--Setting up Pulse effect for animations
	Pls = Pls + (dt*500) 
	if Pls >= 128 then 
		Pls = 0
	end

	x_Coord = (((love.graphics.getWidth()/Brd.grdSz) - Brd.x)/2)*Brd.grdSz
	y_Coord = (((love.graphics.getHeight()/Brd.grdSz) - Brd.y)/2)*Brd.grdSz
	if startbtn > 0 then
		--t = speed of animation based on dt 
		t = t + dt/2
		if t > 15/bpm then 
			t = 0
			--Square's movement along board by grid (ex: plyCol+2 skips columns)
			Brd.plyCol.r = (Brd.plyCol.r + 1) 
			Brd.plyCol.d = (Brd.plyCol.d + 1) 
			Brd.plyCol.u = (Brd.plyCol.u - 1) 
			Brd.plyCol.l = (Brd.plyCol.l - 1) 
			--When col # == end # the square starts at the beginning
			if Brd.plyCol.r == Brd.colEnd.r then
				Brd.plyCol.r = 1
				--Plays sound when hitting edge
				if Brd.plyCol.r == 1 then
					love.audio.play(Snd.r) 
				end
			end
			if Brd.plyCol.u == -Brd.colEnd.u then 
				Brd.plyCol.u= 1 
				if Brd.plyCol.u == 1 then
					love.audio.play(Snd.u) 
				end
			end
			if Brd.plyCol.l == -Brd.colEnd.l then 
				Brd.plyCol.l = 1
				if Brd.plyCol.l == 1 then
					love.audio.play(Snd.l)
				end
			end
			if Brd.plyCol.d == Brd.colEnd.d then 
				Brd.plyCol.d = 1
				if Brd.plyCol.d == 1 then
					love.audio.play(Snd.d)
				end
			end
			--Plays reset loop
			if Brd.plyCol.d == 1 or Brd.plyCol.r == 1 or Brd.plyCol.u == 1 or Brd.plyCol.l == 1 then
				--love.audio.play(Snd.s)
			end
			--Plays sound when all squares hit the edge
			if Brd.plyCol.d == 1 and Brd.plyCol.r == 1 and Brd.plyCol.u == 1 and Brd.plyCol.l == 1 then
				love.audio.play(Snd.a)
			end
		end
	end 
end

function love.draw()
	--Mouse position on left click
    if love.mouse.isDown("l") then
		mPosX, mPosY = love.mouse.getPosition()    
		MouseClick()	
	end
	--Used to place the starting square and figure out square position based on mouse position
    function MouseClick()
    	if startbtn < 1 then
    		--Checks invisible grid board for position to place square
			for i,v in ipairs(Brd) do
				if mPosX > v.x and mPosX < v.x + Brd.grdSz and mPosY > v.y and mPosY < v.y + Brd.grdSz then
					--Calculating "end" of square animation based on board size and square position
					Brd.colEnd.r = Brd.x-((v.x-x_Coord)/Brd.grdSz)+1 
					Brd.colEnd.d = Brd.y-((v.y-y_Coord)/Brd.grdSz)+1
					Brd.colEnd.l = Brd.x-(Brd.x-((v.x-x_Coord)/Brd.grdSz))
					Brd.colEnd.u = Brd.y-(Brd.y-((v.y-y_Coord)/Brd.grdSz))

					v.startCnt = 1
					startbtn = 1
				end
			end
		end
	end
CreateBoard(Brd.x, Brd.y)
	--Flashing animaitons around the edge of the board when the square meets the edge
	if startbtn > 0 then
		if Brd.plyCol.l == 1 then
	    	love.graphics.setColor(0, Pls+150, Pls+25, Pls)
	   		love.graphics.rectangle('fill', 0, 0, x_Coord, 600) 
	 	end
	 	if Brd.plyCol.u == 1 then
	    	love.graphics.setColor(0, Pls+150, Pls+25, Pls)
	   		love.graphics.rectangle('fill', 0, 0, 800, y_Coord) 
	 	end
	 	if Brd.plyCol.r == 1 then
	    	love.graphics.setColor(0, Pls+150, Pls+25, Pls)
	   		love.graphics.rectangle('fill', x_Coord+(Brd.x*Brd.grdSz), 0, x_Coord, 600) 
	 	end
	 	if Brd.plyCol.d == 1 then
	    	love.graphics.setColor(0, Pls+150, Pls+25, Pls)
	   		love.graphics.rectangle('fill', 0, (y_Coord+Brd.y*Brd.grdSz), 800, y_Coord) 
	 	end
	 	if Brd.plyCol.d == 1 and Brd.plyCol.r == 1 and Brd.plyCol.u == 1 and Brd.plyCol.l == 1 then
	 		love.graphics.setColor(Pls+100, Pls+150, Pls+25, Pls)
	   		love.graphics.rectangle('fill', 0, 0, 800, 600) 
	   	end
	end
	--function draws the squares on the board based on width and height as the flashing anims
    function drawStart()
    	if startCnt < 1 then
	    	for i,v in ipairs(Brd) do
	    		if v.startCnt == 1 then
	    			--Starting green square
		    		love.graphics.draw(startimg, quad, v.x, v.y)
		    		--Flashing right square
					love.graphics.setColor(0, 100, 0, Pls)
	    			love.graphics.rectangle('fill', (Brd.plyCol.r-1+v.x/Brd.grdSz)*Brd.grdSz, v.y, 50, 50)
	    			--Colored right square
					love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', (Brd.plyCol.r-1+v.x/Brd.grdSz)*Brd.grdSz+4, v.y+4, 50-8, 50-8)
	    			--Flashing down square
	    			love.graphics.setColor(0, 100, 0, Pls)
	    			love.graphics.rectangle('fill', v.x, (Brd.plyCol.d-1+v.y/Brd.grdSz)*Brd.grdSz, 50, 50)
	    			--Colored down square
	    			love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', v.x+4, (Brd.plyCol.d-1+v.y/Brd.grdSz)*Brd.grdSz+4, 50-8, 50-8)
	    			--Flashing left square
					love.graphics.setColor(0, 100, 0, Pls)
	    			love.graphics.rectangle('fill', (Brd.plyCol.l-1+v.x/Brd.grdSz)*Brd.grdSz, v.y, 50, 50)
	    			--Colored left square
	    			love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', (Brd.plyCol.l-1+v.x/Brd.grdSz)*Brd.grdSz+4, v.y+4, 50-8, 50-8)
	    			--Flashing up square
					love.graphics.setColor(0, 100, 0, Pls)
	    			love.graphics.rectangle('fill', v.x, (Brd.plyCol.u-1+v.y/Brd.grdSz)*Brd.grdSz, 50, 50)
	    			--Colored up square
	    			love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', v.x+4, (Brd.plyCol.u-1+v.y/Brd.grdSz)*Brd.grdSz+4, 50-8, 50-8)
				end
			end
		end
	end
	drawStart()
end






