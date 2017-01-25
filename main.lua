--main.lua

Gamestate = require "lib/Gamestate"
require "lib/maid64" -- used for correct scaling
require "lib/timer"
require "lines" -- lines.lua
require "commands/commands" -- commands.lua

require "states/boot"
require "states/terminal"
require "header"

-- global copy function
function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function love.load(arg)
  math.randomseed(os.time()) -- seed love.math.rand() using os time
  love.graphics.setDefaultFilter("nearest", "nearest") -- set nearest pixel distance

  --love.window.setMode(480, 432, {resizable=true, vsync=true, minwidth=160, minheight=144, msaa=0}) -- set the window mode
  love.window.setMode(256 * 2, 180 * 2, {resizable=false, borderless=true, vsync=true, msaa=0}) -- set the window mode

  terminalFont = love.graphics.newFont("lib/Monaco.dfont", 16)
  bigTerminalFont = love.graphics.newFont("lib/Monaco.dfont", 20)
  love.graphics.setFont(terminalFont)

  headerLoad()

  Gamestate.registerEvents()
  Gamestate.switch(terminal) -- swtich to game screen
  --Gamestate.switch(boot)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    headerClicked(x, y)
  end
end

function love.update(dt)
  headerUpdate()
end

function love.draw()
  headerDraw()
end

-- see if there is a love.moveWindow() function
-- that way the player can move the terminal around when clicking and dragging the header

--[[ -- when maid64 is implemented in the near future
function love.resize(w, h)
    -- this is used to resize the screen correctly
    maid64.resize(w, h)
    camera = Camera(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + player.y - 80)
    camera.smoother = Camera.smooth.upwardDamped(1)
end
]]
