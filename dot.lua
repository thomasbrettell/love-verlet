local Object = require "classic"

Dot = Object:extend()
Object.r = 5

function Dot:new(x, y)
	self.position_x = x
	self.position_y = y

	self.prev_position_x = x
	self.prev_position_y = y
	
	self.acceleration_x = 0
	self.acceleration_y = 0
end

function Dot:updatePosition(dt)
	local velocity_x = self.position_x - self.prev_position_x
	local velocity_y = self.position_y - self.prev_position_y

	self.prev_position_x = self.position_x
	self.prev_position_y = self.position_y

	self.position_x = self.position_x + velocity_x + self.acceleration_x * dt * dt
	self.position_y = self.position_y + velocity_y + self.acceleration_y * dt * dt

	self.acceleration_x = 0
	self.acceleration_y = 0
end

function Dot:accelerate(acc_x, acc_y)
	self.acceleration_x = self.acceleration_x + acc_x
	self.acceleration_y = self.acceleration_y + acc_y
end

function Dot:draw()
	love.graphics.circle("fill", self.position_x, self.position_y, self.r)
end

return Dot