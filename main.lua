local vector = require "vector"
local Dot = require "dot"

local fps
local dots = {}
local window_width = love.graphics:getWidth()
local window_height = love.graphics:getHeight()
local sub_steps = 8
local gravity = vector(0, 1000)
local contraint_position = vector(window_width/2, window_height/2)
local contraint_radius = window_height / 2 - 50
local interval = 0

local function applyGravity()
	for i, dot in ipairs(dots) do
		dot:accelerate(gravity)
	end
end

local function updatePositions(dt)
	for i, dot in ipairs(dots) do
		dot:updatePosition(dt)
	end
end

local function applyConstraint()
	for i, dot in ipairs(dots) do
		local to_obj = dot.position - contraint_position
		local dist = to_obj:len()
		
		if dist > contraint_radius - dot.r then
			local n = to_obj / dist
			dot.position = contraint_position + n * (contraint_radius - dot.r)
		end
	end
end

local function solveCollisions()
    for i = 1, #dots do
		local dot_1 = dots[i]

		for k = i+1, #dots do
			local dot_2 = dots[k]

            local collision_axis = dot_1.position - dot_2.position
            local dist = collision_axis:len()
			local min_dist = dot_1.r + dot_2.r

            if dist < min_dist then
				local n = collision_axis / dist
				local delta = min_dist - dist
				dot_1.position = dot_1.position + 0.5 * delta * n
				dot_2.position = dot_2.position - 0.5 * delta * n
			end
        end
    end
end

function love.load()
end

function love.update(dt)
    interval = interval + dt;
	if interval > 0.2 then
		interval = 0
		table.insert(dots, Dot(window_width/2 - 100, window_height/2))
	end

    fps = math.floor(1 / dt + 0.5)

    local sub_step_dt = dt / sub_steps
	for i = 1, sub_steps do
        applyGravity()
        applyConstraint()
        solveCollisions()
        updatePositions(sub_step_dt)
    end
end

function love.draw()
    love.graphics.print(fps, 5, 5)
    love.graphics.print("Ojects: " .. #dots, 5, 20)

    for i, dot in ipairs(dots) do
		dot:draw()
	end
end

