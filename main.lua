function love.load()
	sSound = love.audio.newSource("assets/StartSound.mp3", static)
	sSound:setLooping(true)
	rSound = love.audio.newSource("assets/RightSound.mp3", static)
	dSound = love.audio.newSource("assets/DownSound.mp3", static)
  	

	Pulse = 25
	Board = {}

	Board_x = 8
	Board_y = 8

	gridSize = 50
	mPosX = 0
	mPosY = 0
	startCnt = 0
	startbtn = 0

	bpm = 64
	playcolR = 1
	playcolL = 1
	playcolD = 1
	playcolU = 1

	t = 0

	colEndR = 1
	colEndL = 1
	colEndU = 1
	colEndD = 1

	function CreateBoard(Board_x, Board_y)
		Board_w = Board_x * gridSize
		Board_h = Board_y * gridSize

		xCoord = (((love.graphics.getWidth()/gridSize) - Board_x)/2)*gridSize
		yCoord = (((love.graphics.getHeight()/gridSize) - Board_y)/2)*gridSize

		bgquad = love.graphics.newQuad(xCoord, yCoord, Board_w, Board_h, 800, 800)

		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(bg, bgquad, xCoord, yCoord)

		for h = 1, Board_y do
			for w = 1, Board_x do
				Grid = {}
				Grid.x = xCoord
				Grid.y = yCoord 
				Grid.Img = startimg
				table.insert(Board, Grid)
				xCoord = xCoord + gridSize
			end
			xCoord = (((love.graphics.getWidth()/gridSize) - Board_x)/2)*gridSize
			yCoord = yCoord + gridSize
		end
		xCoord = (((love.graphics.getWidth()/gridSize) - Board_x)/2)*gridSize
		yCoord = (((love.graphics.getHeight()/gridSize) - Board_y)/2)*gridSize
	end

	quad = love.graphics.newQuad(0,0,50,50,50,50)
	bg = love.graphics.newImage("assets/BG.png")
	startimg = love.graphics.newImage("assets/StartGrid.png")
end

function love.update(dt)
	Pulse = Pulse + (dt*500) 
	if Pulse >= 128 then 
		Pulse = 0
	end


	x_Coord = (((love.graphics.getWidth()/gridSize) - Board_x)/2)*gridSize
	y_Coord = (((love.graphics.getHeight()/gridSize) - Board_y)/2)*gridSize
	--t = speed of animation, playcol = which column is being animated (ex: playcol+2 skips columns)
	if startbtn > 0 then
	t = t + dt/2
	if t > 15/bpm then 
		t = 0
		playcolR = (playcolR + 1) --% colEndR
		playcolD = (playcolD + 1) --% colEndD
		playcolU = (playcolU - 1) --% colEndU
		playcolL = (playcolL - 1) --% colEndL
		if playcolR == colEndR then
			playcolR = 1
			if playcolR == 1 then
				love.audio.play(rSound) 
			end
		end
		if playcolU == -colEndU then 
			playcolU= 1 
			if playcolU == 1 then
				love.audio.play(rSound) 
			end
		end
		if playcolL == -colEndL then 
			playcolL = 1
			if playcolL == 1 then
				love.audio.play(dSound)
			end
		end
		if playcolD == colEndD then 
			playcolD = 1
			if playcolD == 1 then
				love.audio.play(dSound)
			end
		end
	end
	end 
end

function love.draw()
    if love.mouse.isDown("l") then
		mPosX, mPosY = love.mouse.getPosition()    
		MouseClick()	
	end
    function MouseClick()
    	if startbtn < 1 then
    		love.audio.play(sSound)
			for i,v in ipairs(Board) do
				if mPosX > v.x and mPosX < v.x + gridSize and mPosY > v.y and mPosY < v.y + gridSize then
					drawX = v.x
					drawY = v.y
					colEndR = Board_x-((v.x-x_Coord)/gridSize)+1 --ex: 8-((300-200)/50)+1 = 5 
					colEndD = Board_y-((v.y-y_Coord)/gridSize)+1
					colEndL = Board_x-(Board_x-((v.x-x_Coord)/gridSize))
					colEndU = Board_y-(Board_y-((v.y-y_Coord)/gridSize))

					v.startCnt = 1
					startbtn = 1
				end
			end
		end
	end
CreateBoard(8,8)

	if startbtn > 0 then
		if playcolL == 1 then
	    	love.graphics.setColor(0, Pulse+150, Pulse+25, Pulse)
	   		love.graphics.rectangle('fill', 0, 0, x_Coord, 600) 
	 	end
	 	if playcolU == 1 then
	    	love.graphics.setColor(0, Pulse+150, Pulse+25, Pulse)
	   		love.graphics.rectangle('fill', 0, 0, 800, y_Coord) 
	 	end
	 	if playcolR == 1 then
	    	love.graphics.setColor(0, Pulse+150, Pulse+25, Pulse)
	   		love.graphics.rectangle('fill', x_Coord+(Board_x*gridSize), 0, x_Coord, 600) 
	 	end
	 	if playcolD == 1 then
	    	love.graphics.setColor(0, Pulse+150, Pulse+25, Pulse)
	   		love.graphics.rectangle('fill', 0, (y_Coord+Board_y*gridSize), 800, y_Coord) 
	 	end
	end


    function drawStart()
    	if startCnt < 1 then
	    	for i,v in ipairs(Board) do
	    		if v.startCnt == 1 then
		    		love.graphics.draw(startimg, quad, v.x, v.y)

					love.graphics.setColor(0, 100, 0, Pulse)
	    			love.graphics.rectangle('fill', (playcolR-1+v.x/gridSize)*gridSize, v.y, 50, 50)

					love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', (playcolR-1+v.x/gridSize)*gridSize+4, v.y+4, 50-8, 50-8)
	    			
	    			love.graphics.setColor(0, 100, 0, Pulse)
	    			love.graphics.rectangle('fill', v.x, (playcolD-1+v.y/gridSize)*gridSize, 50, 50)

	    			love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', v.x+4, (playcolD-1+v.y/gridSize)*gridSize+4, 50-8, 50-8)

					love.graphics.setColor(0, 100, 0, Pulse)
	    			love.graphics.rectangle('fill', (playcolL-1+v.x/gridSize)*gridSize, v.y, 50, 50)

	    			love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', (playcolL-1+v.x/gridSize)*gridSize+4, v.y+4, 50-8, 50-8)

					love.graphics.setColor(0, 100, 0, Pulse)
	    			love.graphics.rectangle('fill', v.x, (playcolU-1+v.y/gridSize)*gridSize, 50, 50)

	    			love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', v.x+4, (playcolU-1+v.y/gridSize)*gridSize+4, 50-8, 50-8)
				end
			end
		end
	end
	drawStart()

end






