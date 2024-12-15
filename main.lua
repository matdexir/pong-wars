function love.load()
	io.stdout:setvbuf("no")
	Object = require("libs.classic")
	font = love.graphics.newFont("fonts/Open24DisplaySt.ttf", 34)
	love.graphics.setFont(font)
	require("game")
	game = Game()
end

function love.update(dt)
	game:update()
end

function love.keypressed(key)
	if key == "q" or key == "escape" then
		love.event.quit()
	end
end

function love.draw()
	game:draw()
end
