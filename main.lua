push = require "lib/push"
bump = require "lib/bump"
Class = require "lib/class"

require "src/Player"
require "src/EnemyBase"
require "src/Enemy1"
require "src/Enemy2"
require "src/Enemy3"
require "src/Bullet"
require "src/Border"

require 'lib/StateMachine'
require 'src/states/BaseState'
require 'src/states/Menu'
require 'src/states/Level1'
require 'src/states/Level2'
require 'src/states/Level3'
require 'src/states/Lose'

GAME_WIDTH, GAME_HEIGHT = 1600, 900
local WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH*0.8, WINDOW_HEIGHT*0.8

---------------------------------------------------------------------------------------------------------

function love.load()
  push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  math.randomseed(os.time())

  gGameState = StateMachine {
    ["menu"] = function() return Menu() end,
    ["level1"] = function() return Level1() end,
    ["level2"] = function() return Level2() end,
    ["level3"] = function() return Level3() end,
    ["lose"] = function() return Lose() end,
  }
  gGameState:change("menu")


  inputTable = {}

end

---------------------------------------------------------------------------------------------------------

function love.update(dt)
  gGameState:update(dt)

  inputTable = {}

end

---------------------------------------------------------------------------------------------------------

function love.draw()
  push:start()

  gGameState:render()

  push:finish()

end

---------------------------------------------------------------------------------------------------------

function love.resize(w, h)

  push:resize(w, h)

end

---------------------------------------------------------------------------------------------------------

function love.keypressed(key, scancode, isrepeat)
  inputTable[key] = true
end

---------------------------------------------------------------------------------------------------------
