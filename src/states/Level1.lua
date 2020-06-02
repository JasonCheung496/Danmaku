Level1 = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Level1:enter(playerAttri)
  -- new world
  world = bump.newWorld()
  gameScore = 0

  -- new player
  local newPlayerAttri = playerAttri or {}
  newPlayerAttri.x, newPlayerAttri.y = GAME_WIDTH/2 - 100, GAME_HEIGHT - 200
  player = Player(newPlayerAttri)

  -- 2 new enemies of type 1
  local newEnemyAttri = { x = GAME_WIDTH/2 - 100, y = 200, HP = 1000 }
  enemy1 = Enemy1(newEnemyAttri)
  local newEnemyAttri = { x = GAME_WIDTH/2 + 100, y = 200, HP = 1000 }
  enemy2 = Enemy1(newEnemyAttri)

  curRoom = Border(300, 50, 1000, 800)

  items = world:getItems()

  --HUD init
  levelHUD = {}
  HUD.init(levelHUD, player, gameScore)

end

---------------------------------------------------------------------------------------------------------

function Level1:update(dt)
  items = world:getItems()

  -- update all items
  enemiesNumber = 0
  for key, item in pairs(items) do
    item:update(dt)
    if item.__group and item.__group == "enemy" then
      enemiesNumber = enemiesNumber + 1
    end
  end

  -- HUD update
  HUD.update(levelHUD, player, gameScore)

  if inputTable["r"] then
    gGameState:change("level1")
  elseif player.HP <= 0 then
    gGameState:change("lose", gameScore)
  elseif enemiesNumber == 0 and inputTable["c"] then
    gGameState:change("level2", {HP = player.HP, type = player.type})
  elseif inputTable["p"] then
    gGameState:change("level2", {HP = player.HP, type = player.type})
  end


end

---------------------------------------------------------------------------------------------------------

function Level1:render()
  -- render all items
  local i = 1
  for key, item in pairs(items) do
    item:render()
    --love.graphics.print(tostring(item), 0, i*50)
    i = i + 1
  end

  -- HUD display
  HUD.render(levelHUD)

end

---------------------------------------------------------------------------------------------------------
