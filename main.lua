local Dot = require "dot"
local vector = require "hump.vector-light"

local fps
local dots = {}
local window_width = love.graphics:getWidth()
local window_height = love.graphics:getHeight()
local sub_steps = 8
local gravity = {x=0, y=1000}
local contraint_position = {x=window_width/2, y=window_height/2}
local contraint_radius = window_height / 2 - 50
local interval = 0

local function applyGravity()
	for i, dot in ipairs(dots) do
		dot:accelerate(gravity.x, gravity.y)
	end
end

local function updatePositions(dt)
	for i, dot in ipairs(dots) do
		dot:updatePosition(dt)
	end
end

local function applyConstraint()
	for i, dot in ipairs(dots) do
		local to_obj_x = dot.position_x - contraint_position.x
		local to_obj_y = dot.position_y - contraint_position.y

		local dist = vector.len(to_obj_x, to_obj_y)
		
		if dist > contraint_radius - dot.r then
			local n_x = to_obj_x / dist
			local n_y = to_obj_y / dist

			dot.position_x = contraint_position.x + n_x * (contraint_radius - dot.r)
			dot.position_y = contraint_position.y + n_y * (contraint_radius - dot.r)
		end
	end
end

local function solveCollisions()
    for i = 1, #dots do
		local dot_1 = dots[i]

		for k = i+1, #dots do
			local dot_2 = dots[k]

			local collision_axis_x, collision_axis_y = vector.sub(dot_1.position_x, dot_1.position_y, dot_2.position_x, dot_2.position_y)

			local dist = vector.len(collision_axis_x, collision_axis_y)
			local min_dist = dot_1.r + dot_2.r

            if dist < min_dist then
				local n_x, n_y = vector.div(dist, collision_axis_x, collision_axis_y)
				local delta = min_dist - dist
				
				dot_1.position_x = dot_1.position_x + 0.5 * delta * n_x
				dot_1.position_y = dot_1.position_y + 0.5 * delta * n_y

				dot_2.position_x = dot_2.position_x - 0.5 * delta * n_x
				dot_2.position_y = dot_2.position_y - 0.5 * delta * n_y
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
    for i, dot in ipairs(dots) do
		dot:draw()
	end

	love.graphics.print(fps, 5, 5)
    love.graphics.print("Ojects: " .. #dots, 5, 20)
	love.graphics.print(math.floor(collectgarbage("count")), 5, 35)
end

