local lg = love.graphics

local Brick = {
  draw = function(self)
    lg.setColor(self.r / 255, self.g / 255, self.b / 255, (255 * (self.health / 100)) / 255)
    lg.rectangle('fill', self.x, self.y, self.width, self.height)
  end,

  takeDamage = function(self)
    self.health = self.health - 50
    if self.health <= 0 then
      self:destroy()
    end
  end,

  destroy = function(self)
    self.world:remove(self)
    self.bricks[self.index] = nil
    self = nil
  end
}

function createBrick(x, y, width, height, row, col, index, bricks, world)
  local brick = {
    x = x,
    y = y,
    health = 100,
    r = math.floor(math.random()*256),
    g = math.floor(math.random()*256),
    b = math.floor(math.random()*256),
    row = row,
    col = col,
    isBrick = true,
    index = index,
    bricks = bricks,
    world = world,
    width = width,
    height = height
  }
  
  setmetatable(brick, { __index = Brick })

  return brick
end

return createBrick