function love.load()
	io.stdout:setvbuf("no")
	Object = require("libs.classic")
	require("game")
	game = Game()
end

function love.update(dt)
	game:update()
end

function love.draw()
	game:draw()
end
