Lose = Class{__includes = BaseState}

---------------------------------------------------------------------------------------------------------

function Lose:enter(score)
  self.score = score or 0

end

---------------------------------------------------------------------------------------------------------

function Lose:update(dt)
  if inputTable["c"] then
    gGameState:change("menu")
  end


end

---------------------------------------------------------------------------------------------------------

function Lose:render()
  love.graphics.setColor(0.5, 0.5, 0.3, 1)
  love.graphics.setFont(mFont)
  love.graphics.print("You lose", 400, 200)
  love.graphics.print("Your score: " .. tostring(self.score), 400, 300)
  love.graphics.print("Press c to continue", 400, 600)

end

---------------------------------------------------------------------------------------------------------
