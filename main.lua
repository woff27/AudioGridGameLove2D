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
	t = t + dt/2
	if t > 15/bpm then 
		t = 0
		playcolR = (playcolR + 1) % colEndR
		playcolU = (playcolU + 1) % colEndU
		playcolL = (playcolL + 1) % colEndL
		playcolD = (playcolD + 1) % colEndD
		if playcolR == 0 then
			playcolR = 1
			if startbtn >= 1 then
				love.audio.play(rSound) 
			end
		end
		if playcolU == 0 then playcolU = 1 end
		if playcolL == 0 then playcolL = 1 end
		if playcolD == 0 then 
			playcolD = 1
			if startbtn >= 1 then
				love.audio.play(dSound)
			end
		end
	end 
end

function love.draw()
	CreateBoard(8,8)

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
					colEndR = Board_x-((v.x-x_Coord)/gridSize)+1
					colEndU = Board_y-((v.y-y_Coord)/gridSize)+1
					colEndL = Board_x-((v.x-x_Coord)/gridSize)+1
					colEndD = Board_y-((v.y-y_Coord)/gridSize)+1

					v.startCnt = 1
					startbtn = 1
				end
			end
		end
	end
    function drawStart()
    	if startCnt < 1 then
	    	for i,v in ipairs(Board) do
	    		if v.startCnt == 1 then
					love.graphics.draw(startimg, quad, v.x, v.y)
		
					love.graphics.setColor(0, 100, 50, Pulse)
	    			love.graphics.rectangle('fill', (playcolR-1+v.x/gridSize)*gridSize, v.y, 50, 50)

					love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', (playcolR-1+v.x/gridSize)*gridSize+4, v.y+4, 50-8, 50-8)

	    			love.graphics.setColor(0, 100, 50, Pulse)
	    			love.graphics.rectangle('fill', v.x, (playcolU-1+v.y/gridSize)*gridSize, 50, 50)

	    			love.graphics.setColor(0, 255, 50, 50)
	    			love.graphics.rectangle('fill', v.x+4, (playcolU-1+v.y/gridSize)*gridSize+4, 50-8, 50-8)

	    			--[[love.graphics.setColor(255, 255, 255, 50)
	    			love.graphics.rectangle('fill', (playcolL-1+v.x/gridSize)*gridSize+4, v.y+4, 50-8, 50-8)

	    			love.graphics.setColor(255, 255, 255, 50)
	    			love.graphics.rectangle('fill', v.x+4, (playcolD+1+v.y/gridSize)*gridSize+4, 50-8, 50-8)]]
				end
			end
		end
	end
	drawStart()
end






