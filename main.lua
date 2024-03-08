function love.load()
	io.stdout:setvbuf("no")
	Object = require("libs.classic")
	require("game")
	success = love.window.setMode(600, 600, {})
	font = love.graphics.newFont(14)
	love.graphics.setFont(font)
	if not success then
		print("UNABLE TO RESIZE")
		love.event.quit(1)
	end
	game = Game()
end

function love.update(dt)
	game:update()
end

function love.draw()
	game:draw()
end
