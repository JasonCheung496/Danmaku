Level2 = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Level2:enter(playerAttri)
  -- new world
  world = bump.newWorld()
  gameScore = gameScore or 0

  -- new player
  local newPlayerAttri = playerAttri or {}
  newPlayerAttri.x, newPlayerAttri.y = GAME_WIDTH/2 - 100, GAME_HEIGHT - 200
  player = Player(newPlayerAttri)

  -- 2 new enemies of type 2
  local newEnemyAttri = { x = GAME_WIDTH/2 - 400, y = 100, HP = 1000 }
  enemy1 = Enemy2(newEnemyAttri)
  local newEnemyAttri = { x = GAME_WIDTH/2 + 200, y = 200, HP = 1000 }
  enemy2 = Enemy2(newEnemyAttri)

  curRoom = Border(10, 10, GAME_WIDTH-20, GAME_HEIGHT-20)

  items = world:getItems()

  --HUD init
  levelHUD = {}
  HUD.init(levelHUD, player, gameScore)

end

---------------------------------------------------------------------------------------------------------

function Level2:update(dt)
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
    gGameState:change("level2")
  elseif player.HP <= 0 then
    gGameState:change("lose", gameScore)
  elseif inputTable["o"] then
    gGameState:change("level1")
  elseif enemiesNumber == 0 and inputTable["c"] then
    gGameState:change("level3", {HP = player.HP, type = player.type})
  elseif inputTable["p"] then
    gGameState:change("level3", {HP = player.HP, type = player.type})
  end


end

---------------------------------------------------------------------------------------------------------

function Level2:render()
  -- render all items
  for key, item in pairs(items) do
    item:render()
  end

  -- HUD display
  HUD.render(levelHUD)

end

---------------------------------------------------------------------------------------------------------
