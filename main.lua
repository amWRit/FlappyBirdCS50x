push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Flappy BirdX')

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		resizable = true,
		fullscreen = false
	})
end

function love.resize(w,h)
	push:resize(w,h)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.update()

end

function love.draw()
	-- similar to push:apply('start') -- old way
	push:start()
	love.graphics.draw(background, 0, 0)

	--love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
	love.graphics.draw(ground, 0, VIRTUAL_HEIGHT-16)
	-- similar to push:apply('finish')
	push:finish()
end