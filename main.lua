Gamestate = require "libraries/gamestate"
local game = require"game"
local menu = require"menu"

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(game)
end