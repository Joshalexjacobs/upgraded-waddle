-- box_factory.lua

require "adventures/box_factory/box"
require "adventures/box_factory/entity"
require "adventures/box_factory/events"

local adventure = {
  name = "box_factory.adv", -- name of our adventure
  state = "enter", -- determines which function to call (unused rn)
  enter = nil, -- our load function
  update = nil, -- update function
  draw = nil, -- draw function
  input = nil, -- input function
  changeState = nil, -- change current state function
  timers = {} -- adventure timers
}

local assets = { -- a list of paths for our assets
  employeeID = "adventures/box_factory/img/employeeID.png",
  background = "adventures/box_factory/img/background4.png",
  shadowOverlay = "adventures/box_factory/img/shadowOverlay3.png"
}

local boxTally = 0

adventure.enter = function(adventure)
  -- load all entities
  addEntity(0, 271, "conveyorBelt")
  addEntity(64, 271, "conveyorBelt")
  addEntity(128, 271, "conveyorBelt")
  addEntity(192, 271, "conveyorBelt")
  addEntity(256, 271, "conveyorBelt")
  addEntity(320, 271, "conveyorBelt")
  addEntity(384, 271, "conveyorBelt")
  addEntity(448, 271, "conveyorBelt")

  addEntity(30, 207, "PRU", true)

  addTimer(3.0, "pause", adventure.timers) -- add a timer that blocks user input
  setLineMax(3) -- set our line max to 3, make room for images/graphics

  -- set up scenario:
  addLine("Loading Adventure: '" .. adventure.name .. "'. . .", 1.0)
  addLine(adventure.name .. " Loaded!", 2.0)

  pauseLines() -- and all future lines

  addLine("Your daily duties include:")
  addLine("Logging all incoming packages to your Portable Receiving Unit.")
  addLine("Shipping labels will contain the following:")
  addLine("1. Delivery ID Number")
  addLine("2. Corporation")
  addLine("3. Weight (lbs)", 0.0, false, false, {true, "boxGen"})

  -- load images:
  assets.employeeID = maid64.newImage(assets.employeeID)
  assets.background = maid64.newImage(assets.background)
  assets.shadowOverlay = maid64.newImage(assets.shadowOverlay)
end

adventure.update = function(dt, adventure)
  updateTimer(dt, "pause", adventure.timers) -- update pause timer

  if adventure.state == "boxGen" and boxTally % 3 == 0 and boxTally ~= 0 then
    activateEvent(true)
    boxTally = boxTally + 1
    adventure.state = "event" .. tostring(boxTally)
    loadRoomEvents()
  elseif adventure.state == "boxGen" then
    addBox()
    boxTally = boxTally + 1
    adventure.state = "box" .. tostring(boxTally)
  end

  updateBoxFactEvents(dt) -- needs to come before updateBox

  updateBox(boxTally, dt)

  updateEntities(dt)
end

adventure.draw = function(adventure)
  maid64.start() -- start maid64 (only run maid64 for images, we don't want to apply it to text)
  love.graphics.draw(assets.background, 0, 90)

  drawEntities() -- draw all entities (that appear under our boxes)

  maid64.finish() -- end maid64

  -- draw a box
  if adventure.state ~= "enter" then
    drawBox()
  end

  maid64.start()

  love.graphics.draw(assets.shadowOverlay, 0, 90)

  drawPriorityEntities() -- draw entities that must draw over our boxes

  -- employee ID
  if adventure.state == "enter" then
    love.graphics.draw(assets.employeeID, 110, 150)
  end

  maid64.finish() -- end maid64

  -- draw a box
  if adventure.state == "box" .. tostring(boxTally) then
    drawLabel()
  end

  love.graphics.setColor({0, 0, 0, 255})
  love.graphics.rectangle("line", 1, 90, love.graphics.getWidth() - 2, 245)

  love.graphics.setColor({255, 255, 255, 255})
end

adventure.input = function(adventure, input)
  if isTimerDone("pause", adventure.timers) and adventure.state ~= "box" .. tostring(boxTally) and adventure.state ~= "event" .. tostring(boxTally) then
    unpauseLines() -- this'll work for now
  elseif adventure.state == "box" .. tostring(boxTally) then -- might need more on this if..
    checkBox(input)
  elseif adventure.state == "event" .. tostring(boxTally) then
    passEventInput(input)
  end
end

adventure.changeState = function(newState) -- takes 1 string
  adventure.state = newState
end

return adventure

--[[

1) there's going to be a ton of text to output, i should consider storing that in a seperate file somewhere and store that
somewhere inside our adventure (should figure out a good file type, def not .txt and maybe avoid .lua).

2) first event box doesnt have a shipping label

3) last event box has a guy in it



local event = { -- contains all info needed for the play to experience an event box
  -- functions, possible commands, results, etc...
}

--]]
