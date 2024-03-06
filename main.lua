function love.load()
	io.stdout:setvbuf("no")
	Object = require("libs.classic")
	success = love.window.setMode(600, 600, {})
	font = love.graphics.newFont(14)
	love.graphics.setFont(font)
	if not success then
		print("UNABLE TO RESIZE")
		love.event.quit(1)
	end
	Screen_height = love.graphics.getHeight()
	Screen_width = love.graphics.getWidth()
	SQUARE_SIZE = 25
	MIN_SPEED = 5
	MAX_SPEED = 10

	DAY_SCORE = 0
	NIGHT_SCORE = 0

	DAY_COLOR = {
		r = 204,
		g = 204,
		b = 255,
	}
	NIGHT_COLOR = {
		r = 0,
		g = 51,
		b = 51,
	}

	SquaresCountX = math.floor(Screen_width / SQUARE_SIZE)
	SquaresCountY = math.floor(Screen_height / SQUARE_SIZE)
	print(SquaresCountX, SquaresCountY)

	Field = {}
	for i = 1, SquaresCountX do
		Field[i] = {}
		for j = 1, SquaresCountY do
			if i <= math.floor(SquaresCountX / 2) then
				Field[i][j] = DAY_COLOR
			else
				Field[i][j] = NIGHT_COLOR
			end
		end
	end

	Balls = {
		{
			x = math.floor(Screen_width / 4),
			y = math.floor(Screen_height / 2),
			dx = 8,
			dy = -8,
			reverseColor = DAY_COLOR,
			color = NIGHT_COLOR,
		},

		{
			x = math.floor((Screen_width / 4) * 3),
			y = math.floor(Screen_height / 2),
			dx = -8,
			dy = 8,
			reverseColor = NIGHT_COLOR,
			color = DAY_COLOR,
		},
	}
end

function love.update(dt)
	DAY_SCORE = 0
	NIGHT_SCORE = 0
	for i = 1, SquaresCountX do
		for j = 1, SquaresCountY do
			if Field[i][j] == DAY_COLOR then
				DAY_SCORE = DAY_SCORE + 1
			else
				NIGHT_SCORE = NIGHT_SCORE + 1
			end
		end
	end

	for _, ball in ipairs(Balls) do
		checkSquareCollision(ball)
		checkBoundaryCollision(ball)
		ball.x = ball.x + ball.dx --[[ * dt ]]
		ball.y = ball.y + ball.dy --[[ * dt ]]
		addRandomness(ball)
	end
end

function love.draw()
	for i = 1, SquaresCountX do
		for j = 1, SquaresCountY do
			love.graphics.setColor(Color(Field[i][j]))
			love.graphics.rectangle(
				"fill",
				(i - 1) * SQUARE_SIZE,
				(j - 1) * SQUARE_SIZE,
				SQUARE_SIZE,
				SQUARE_SIZE
			)
		end
	end
	for _, ball in ipairs(Balls) do
		love.graphics.setColor(Color(ball.color))
		love.graphics.circle("fill", ball.x, ball.y, SQUARE_SIZE / 2)
	end

	-- love.graphics.print(
	-- 	NIGHT_SCORE .. " : " .. DAY_SCORE,
	-- 	Screen_width / 2 - 30,
	-- 	10,
	-- 	10,
	-- 	10
	-- )
	-- love.graphics.printf(
	-- 	"This text will be centered no matter what.\n(and you LOVE it)",
	-- 	0,
	-- 	400,
	-- 	800,
	-- 	"center"
	-- )
end

function Color(field)
	return love.math.colorFromBytes(field.r, field.g, field.b)
end

function checkBoundaryCollision(ball)
	if
		ball.x + ball.dx > Screen_width - (SQUARE_SIZE / 2)
		or ball.x + ball.dx < SQUARE_SIZE / 2
	then
		ball.dx = -ball.dx
	end
	if
		ball.y + ball.dy > Screen_height - (SQUARE_SIZE / 2)
		or ball.y + ball.dy < SQUARE_SIZE / 2
	then
		ball.dy = -ball.dy
	end
end

function checkSquareCollision(ball)
	for angle = 0, math.pi * 2, math.pi / 4 do
		local checkX = ball.x + math.cos(angle) * (SQUARE_SIZE / 2)
		local checkY = ball.y + math.sin(angle) * (SQUARE_SIZE / 2)

		local i = math.floor(checkX / SQUARE_SIZE) + 1
		local j = math.floor(checkY / SQUARE_SIZE) + 1
		-- print(ball.color, i, j, checkX, checkY)

		if i >= 0 and i < SquaresCountX and j >= 0 and j < SquaresCountY then
			if Field[i][j] ~= ball.reverseColor then
				Field[i][j] = ball.reverseColor

				if math.abs(math.cos(angle)) > math.abs(math.sin(angle)) then
					ball.dx = -ball.dx
				else
					ball.dy = -ball.dy
				end
			end
		end
	end
end

function addRandomness(ball)
	ball.dx = ball.dx + love.math.random() * 0.01 - 0.005
	ball.dy = ball.dy + love.math.random() * 0.01 - 0.005

	ball.dx = math.min(MAX_SPEED, math.max(ball.dx, -MAX_SPEED))
	ball.dy = math.min(MAX_SPEED, math.max(ball.dy, -MAX_SPEED))

	if math.abs(ball.dx) < MIN_SPEED then
		if ball.dx < 0 then
			ball.dx = -MIN_SPEED
		else
			ball.dx = MIN_SPEED
		end
	end

	if math.abs(ball.dy) < MIN_SPEED then
		if ball.dy < 0 then
			ball.dy = -MIN_SPEED
		else
			ball.dy = MIN_SPEED
		end
	end
end
