Menu = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Menu:enter()
  menuSelector = 0 --only be 0, 1

  --positions of UI texts
  UI = {
    title = {GAME_WIDTH/2-250, GAME_HEIGHT/2-200},
    line1 = {GAME_WIDTH/2-300, GAME_HEIGHT/2+100},
    line2 = {GAME_WIDTH/2-300, GAME_HEIGHT/2+200},
    selector = {GAME_WIDTH/2-350, GAME_HEIGHT/2+100,
      GAME_WIDTH/2-350, GAME_HEIGHT/2+140,
      GAME_WIDTH/2-320, GAME_HEIGHT/2+120},
  }

end

---------------------------------------------------------------------------------------------------------

function Menu:update(dt)
  --update menuSelector
  if inputTable["up"] then
    menuSelector = (menuSelector - 1) % 2
  end
  if inputTable["down"] then
    menuSelector = (menuSelector + 1) % 2
  end
  UI.selector = {GAME_WIDTH/2-350, GAME_HEIGHT/2+100 +100*menuSelector,
      GAME_WIDTH/2-350, GAME_HEIGHT/2+140 +100*menuSelector,
      GAME_WIDTH/2-320, GAME_HEIGHT/2+120 +100*menuSelector}

  --select what menuSelector's value is
  if inputTable["c"] then
    if menuSelector == 0 then
      gGameState:change("select")
    elseif menuSelector == 1 then
      love.event.quit()
    else
      error(string.format("Invalid input, menuSelector = %d", menuSelector))
    end
  end

end

---------------------------------------------------------------------------------------------------------

function Menu:render()
  --print title
  love.graphics.setColor(0.1, 0.8, 0.3, 1)
  love.graphics.setFont(lFont)
  love.graphics.print("Welcome", UI.title[1], UI.title[2])

  --print menu
  love.graphics.setColor(0.7, 0.8, 0.9, 1)
  love.graphics.setFont(mFont)
  love.graphics.print("Start the game", UI.line1[1], UI.line1[2])
  love.graphics.print("Exit", UI.line2[1], UI.line2[2])

  love.graphics.setColor(0.9, 0.8, 0.9, 1)
  love.graphics.polygon("fill", UI.selector)

end

---------------------------------------------------------------------------------------------------------
