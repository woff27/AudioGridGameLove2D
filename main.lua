function love.load()
	gridSize = 50
	mPosX = 0
	mPosY = 0
	startCnt = 0
	--CreateBoard(14, 10) max = 16x12 grid for 800x600 display
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
	end
	
	function checkMouse()
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
	end

	Board = {}	
			
	startimg = love.graphics.newImage("assets/StartGrid.png")
	blankimg = love.graphics.newImage("assets/BlankGrid.png")

	quad = love.graphics.newQuad(0,0,50,50,50,50)

	CreateBoard(6, 6)
end

function love.update(dt)
	if love.mouse.isDown("l") then
		mPosX, mPosY = love.mouse.getPosition()    
		checkMouse()	
	end
end

function love.draw()
	for i,v in ipairs(Board) do
		love.graphics.draw(v.Img, quad, v.x, v.y)
    end
end



