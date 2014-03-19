function love.load()
	Board = {}

	gridSize = 50
	mPosX = 0
	mPosY = 0
	startCnt = 0

	bpm = 120
	playcol = 1
	--[[CreateBoard(14, 10) max = 16x12 grid for 800x600 display
	function CreateBoard(x, y) -- x = width # of squares, y = height # of squares 
		Boardx = x
		Boardy = y

		xcord = (((love.graphics.getWidth()/gridSize) - Boardx)/2)*gridSize
		ycord = (((love.graphics.getHeight()/gridSize) - Boardy)/2)*gridSize

		for h = 1, y do
			for w = 1, x do
				Grid = {}
				Grid.Img = blankimg
				Grid.x = xcord 
				Grid.y = ycord 
				table.insert(Board, Grid)
				xcord = xcord + gridSize
			end
			xcord = (((love.graphics.getWidth()/gridSize) - Boardx)/2)*gridSize
			ycord = ycord + gridSize
		end
	end]]

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
				table.insert(Board, Grid)
				xCoord = xCoord + gridSize
			end
			xCoord = (((love.graphics.getWidth()/gridSize) - Board_x)/2)*gridSize
			yCoord = yCoord + gridSize
		end
		xCoord = (((love.graphics.getWidth()/gridSize) - Board_x)/2)*gridSize
		yCoord = (((love.graphics.getHeight()/gridSize) - Board_y)/2)*gridSize
	end
	
	--[[function checkMouse()
		if startCnt < 1 then
			for i,v in ipairs(Board) do
				if v.Img == startimg then
					break
				elseif mPosX > v.x and mPosX < v.x + gridSize and mPosY > v.y and mPosY < v.y + gridSize then
					v.Img = startimg
				end
			end
			startCnt = 1
		end
	end]]

	function MouseClick()
		for i,v in ipairs(Board) do
			if mPosX > v.x and mPosX < v.x + gridSize and mPosY > v.y and mPosY < v.y + gridSize then

	end
			
	bg = love.graphics.newImage("assets/BG.png")
	startimg = love.graphics.newImage("assets/StartGrid.png")
	--blankimg = love.graphics.newImage("assets/BlankGrid.png")
end

function love.update(dt)
	if love.mouse.isDown("l") then
		mPosX, mPosY = love.mouse.getPosition()    
		MouseClick()	
	end
end

function love.draw()
	CreateBoard(4,4)
	--[[for i,v in ipairs(Board) do
		love.graphics.draw(v.Img, quad, v.x, v.y)
    end]]

end

function bpmUpdate(dt)
	t = t + dt
		if t >15/bpm then
			t = 0
			playcol = (playcol + 1) % 17
			if playcol == 0 then playcol = 1 end
		end
end

function drawStart()
	
	
	love.graphics.setColor(255, 255, 255, 200)
    love.graphics.rectangle('fill', --[[(playcol-1)*gridSize-4]] xCoord+4, yCoord+4, 50-8+gridSize, 50-8)
end

