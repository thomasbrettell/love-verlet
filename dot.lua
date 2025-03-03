local vector = require "vector"
local Object = require "classic"

Dot = Object:extend()
Object.r = 5

function Dot:new(x, y)
	self.position = vector(x, y)
	self.prev_position = vector(x, y)
	self.acceleration = vector()
end

function Dot:updatePosition(dt)
	local velocity = self.position - self.prev_position

	self.prev_position = self.position

	self.position = self.position + velocity + self.acceleration * dt * dt

	self.acceleration.x = 0
	self.acceleration.y = 0
end

function Dot:accelerate(acc)
	self.acceleration = self.acceleration + acc
end

function Dot:draw()
	love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

return Dot