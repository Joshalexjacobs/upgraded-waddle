-- entity.lua

require "adventures/box_factory/entityList"

local entity = {
  x = 0,
  y = 0,
  w = 0,
  h = 0,
  offX = 0,
  offY = 0,
  name = "",
  behaviour = nil,
  spriteSheet = "",
  spriteGrid = {x = 0, y = 0, w = 0, h = 0},
  animations = {},
  curAnim = 1,
  timers = {}
}

local priorityEntities = {}
local entities = {}

function addEntity(x, y, name, isPriority)
  isPriority = isPriority or nil
  local newEntity = copy(entity, newEntity) -- copy base entity object

  newEntity.x, newEntity.y, newEntity.name  = x, y, name
  getEntity(newEntity)

  if isPriority then
    table.insert(priorityEntities, newEntity)
  else
    table.insert(entities, newEntity)
  end
end

function updateEntities(dt)
  for _, newEntity in ipairs(entities) do
    newEntity.behaviour(dt, newEntity)

    -- update each entities' animation
    newEntity.animations[newEntity.curAnim]:update(dt)
  end

  for _, newEntity in ipairs(priorityEntities) do
    newEntity.behaviour(dt, newEntity)

    -- update each entities' animation
    newEntity.animations[newEntity.curAnim]:update(dt)
  end
end

-- need to add entity draw functions

function drawPriorityEntities()
  for _, newEntity in ipairs(priorityEntities) do
    newEntity.draw(newEntity)
    --newEntity.animations[newEntity.curAnim]:draw(newEntity.spriteSheet, newEntity.x, newEntity.y, 0, 1, 1, newEntity.offX, newEntity.offY)
  end
end

function drawEntities()
  for _, newEntity in ipairs(entities) do
    newEntity.draw(newEntity)
    --newEntity.animations[newEntity.curAnim]:draw(newEntity.spriteSheet, newEntity.x, newEntity.y, 0, 1, 1, newEntity.offX, newEntity.offY)
  end
end
