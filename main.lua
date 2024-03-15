function love.load()
	io.stdout:setvbuf("no")
	Object = require("libs.classic")
	font = love.graphics.newFont("fonts/Open24DisplaySt.ttf", 18)
	love.graphics.setFont(font)
	require("game")
	game = Game()
end

function love.update(dt)
	game:update()
end

function love.draw()
	game:draw()
end
