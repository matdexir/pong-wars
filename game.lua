Game = Object:extend()

function Game:new()
	self.screen_height = love.graphics.getHeight() - 100
	self.screen_width = love.graphics.getWidth()
	self.SQUARE_SIZE = 25
	self.MIN_SPEED = 5
	self.MAX_SPEED = 10

	self.DAY_SCORE = 0
	self.NIGHT_SCORE = 0

	self.DAY_COLOR = {
		r = 204,
		g = 204,
		b = 255,
	}
	self.NIGHT_COLOR = {
		r = 0,
		g = 51,
		b = 51,
	}

	self.squaresCountX = math.floor(self.screen_width / self.SQUARE_SIZE)
	self.squaresCountY = math.floor(self.screen_height / self.SQUARE_SIZE)
	-- print(SquaresCountX, SquaresCountY)

	self.field = {}
	for i = 1, self.squaresCountX do
		self.field[i] = {}
		for j = 1, self.squaresCountY do
			if i <= math.floor(self.squaresCountX / 2) then
				self.field[i][j] = self.DAY_COLOR
				self.DAY_SCORE = self.DAY_SCORE + 1
			else
				self.field[i][j] = self.NIGHT_COLOR
				self.NIGHT_SCORE = self.NIGHT_SCORE + 1
			end
		end
	end

	self.balls = {
		{
			x = math.floor(self.screen_width / 4),
			y = math.floor(self.screen_height / 2),
			dx = 8,
			dy = -8,
			reverseColor = self.DAY_COLOR,
			color = self.NIGHT_COLOR,
		},

		{
			x = math.floor((self.screen_width / 4) * 3),
			y = math.floor(self.screen_height / 2),
			dx = -8,
			dy = 8,
			reverseColor = self.NIGHT_COLOR,
			color = self.DAY_COLOR,
		},
	}
end

function Game:update()
	self.DAY_SCORE = 0
	self.NIGHT_SCORE = 0
	for i = 1, self.squaresCountX do
		for j = 1, self.squaresCountY do
			if self.field[i][j] == self.DAY_COLOR then
				self.DAY_SCORE = self.DAY_SCORE + 1
			else
				self.NIGHT_SCORE = self.NIGHT_SCORE + 1
			end
		end
	end

	for _, ball in ipairs(self.balls) do
		self:checkSquareCollision(ball)
		self:checkBoundaryCollision(ball)
		ball.x = ball.x + ball.dx --[[ * dt ]]
		ball.y = ball.y + ball.dy --[[ * dt ]]
		self:addRandomness(ball)
	end
end

function Game:draw()
	for i = 1, self.squaresCountX do
		for j = 1, self.squaresCountY do
			love.graphics.setColor(Color(self.field[i][j]))
			love.graphics.rectangle(
				"fill",
				(i - 1) * self.SQUARE_SIZE,
				(j - 1) * self.SQUARE_SIZE,
				self.SQUARE_SIZE,
				self.SQUARE_SIZE
			)
		end
	end
	for _, ball in ipairs(self.balls) do
		love.graphics.setColor(Color(ball.color))
		love.graphics.circle("fill", ball.x, ball.y, self.SQUARE_SIZE / 2)
	end
	love.graphics.print(self.DAY_SCORE .. " : " .. self.NIGHT_SCORE, 240, 630)
end

function Game:checkBoundaryCollision(ball)
	if
		ball.x + ball.dx > self.screen_width - (self.SQUARE_SIZE / 2)
		or ball.x + ball.dx < self.SQUARE_SIZE / 2
	then
		ball.dx = -ball.dx
	end
	if
		ball.y + ball.dy > self.screen_height - (self.SQUARE_SIZE / 2)
		or ball.y + ball.dy < self.SQUARE_SIZE / 2
	then
		ball.dy = -ball.dy
	end
end

function Game:checkSquareCollision(ball)
	for angle = 0, math.pi * 2, math.pi / 4 do
		local checkX = ball.x + math.cos(angle) * (self.SQUARE_SIZE / 2)
		local checkY = ball.y + math.sin(angle) * (self.SQUARE_SIZE / 2)

		local i = math.floor(checkX / self.SQUARE_SIZE) + 1
		local j = math.floor(checkY / self.SQUARE_SIZE) + 1

		if
			i >= 0
			and i <= self.squaresCountX
			and j >= 0
			and j <= self.squaresCountY
		then
			if self.field[i][j] ~= ball.reverseColor then
				self.field[i][j] = ball.reverseColor

				if math.abs(math.cos(angle)) > math.abs(math.sin(angle)) then
					ball.dx = -ball.dx
				else
					ball.dy = -ball.dy
				end
			end
		end
	end
end

function Game:addRandomness(ball)
	ball.dx = ball.dx + love.math.random() * 0.01 - 0.005
	ball.dy = ball.dy + love.math.random() * 0.01 - 0.005

	ball.dx = math.min(self.MAX_SPEED, math.max(ball.dx, -self.MAX_SPEED))
	ball.dy = math.min(self.MAX_SPEED, math.max(ball.dy, -self.MAX_SPEED))

	if math.abs(ball.dx) < self.MIN_SPEED then
		if ball.dx < 0 then
			ball.dx = -self.MIN_SPEED
		else
			ball.dx = self.MIN_SPEED
		end
	end

	if math.abs(ball.dy) < self.MIN_SPEED then
		if ball.dy < 0 then
			ball.dy = -self.MIN_SPEED
		else
			ball.dy = self.MIN_SPEED
		end
	end
end

function Color(field)
	return love.math.colorFromBytes(field.r, field.g, field.b)
end
