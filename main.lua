push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountdownState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

--local bird = Bird()
-- local pipes = {}
--local pipePairs = {}
--local spawnTimer = 0

--local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- pause the game when collision detected
local scrolling = true

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Flappy BirdX')

	smallFont = love.graphics.newFont('font.ttf', 8)
	mediumFont = love.graphics.newFont('flappy.ttf', 14)
	flappyFont = love.graphics.newFont('flappy.ttf', 28)
	hugeFont = love.graphics.newFont('flappy.ttf', 56)
	love.graphics.setFont(flappyFont)

	sounds = {
		['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
		['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
		['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
		['score'] = love.audio.newSource('sounds/score.wav', 'static'),
		['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
	}

	sounds['music']:setLooping(true)
	sounds['music']:play()

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		resizable = true,
		fullscreen = false
	})

	gStateMachine = StateMachine{
		['title'] = function() return TitleScreenState() end, 
		['play'] = function() return PlayState() end,
		['score'] = function() return ScoreState() end,
		['countdown'] = function() return CountdownState() end
	}
	gStateMachine:change('title')

	love.keyboard.keysPressed = {}
	love.mouse.pressed = false
end

function love.resize(w,h)
	push:resize(w,h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)
	love.mouse.pressed = true
end

function love.mouse.wasPressed()
	return love.mouse.pressed
end

function love.update(dt)

	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

	gStateMachine:update(dt)
	love.keyboard.keysPressed = {}
	love.mouse.pressed = false
end

function love.draw()
	-- similar to push:apply('start') -- old way
	push:start()
	
	love.graphics.draw(background, -backgroundScroll, 0)
	gStateMachine:render()
	--love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)

	-- similar to push:apply('finish')
	push:finish()
end