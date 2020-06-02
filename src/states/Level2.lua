Level2 = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Level2:enter(playerAttri)
  world = bump.newWorld()
  gameScore = gameScore or 0

  local newPlayerAttri = playerAttri or {}
  newPlayerAttri.x, newPlayerAttri.y = GAME_WIDTH/2 - 100, GAME_HEIGHT - 200
  player = Player(newPlayerAttri)

  local newEnemyAttri = { x = GAME_WIDTH/2 - 400, y = 100, HP = 1000 }
  enemy1 = Enemy2(newEnemyAttri)
  local newEnemyAttri = { x = GAME_WIDTH/2 + 200, y = 200, HP = 1000 }
  enemy2 = Enemy2(newEnemyAttri)

  curRoom = Border(10, 10, GAME_WIDTH-20, GAME_HEIGHT-20)

  items = world:getItems()

  --HUD init
  HUD = {
    playerHP = {x = 100, y = 10, width = 50, height = 300, barY = 10, barHeight = 300, max = playerSet[player.type].maxHP},
    score = {x = 1200, y = 10, val = gameScore}
  }

end

---------------------------------------------------------------------------------------------------------

function Level2:update(dt)
  items = world:getItems()

  for key, item in pairs(items) do
    item:update(dt)
  end

  --HUD update
  HUD.playerHP.barHeight = HUD.playerHP.height*player.HP/HUD.playerHP.max
  HUD.playerHP.barY = HUD.playerHP.y + HUD.playerHP.height - HUD.playerHP.barHeight
  HUD.score.val = gameScore

  if inputTable["r"] then
    gGameState:change("level2")
  elseif player.HP <= 0 then
    gGameState:change("lose", gameScore)
  elseif inputTable["o"] then
    gGameState:change("level1")
  end


end

---------------------------------------------------------------------------------------------------------

function Level2:render()
  love.graphics.setColor(0.1, 0.8, 0.3, 1)
  love.graphics.setFont(love.graphics.newFont(40))
  --love.graphics.print("This is level2")

  for key, item in pairs(items) do
    item:render()
  end

  --HUD display
  love.graphics.setColor(0.8, 0.7, 0.5, 0.7)
  love.graphics.rectangle("fill", HUD.playerHP.x, HUD.playerHP.barY, HUD.playerHP.width, HUD.playerHP.barHeight)
  love.graphics.setColor(0.8, 0.9, 0.7, 1)
  love.graphics.rectangle("line", HUD.playerHP.x, HUD.playerHP.y, HUD.playerHP.width, HUD.playerHP.height)

  love.graphics.setColor(0.1, 0.8, 0.3, 1)
  love.graphics.print("Score: " .. tostring(HUD.score.val), HUD.score.x, HUD.score.y)


end

---------------------------------------------------------------------------------------------------------
