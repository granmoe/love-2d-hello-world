local lg = love.graphics

local Brick = {}
Brick.__index = Brick

function Brick:new (x, y, width, height, row, col, index, bricks, world)
  local brick = setmetatable({
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
  }, Brick)

  return brick
end

function Brick:draw ()
  lg.setColor(self.r, self.g, self.b, (255 * (self.health / 100)))
  lg.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Brick:takeDamage ()
  self.health = self.health - 50
  if self.health <= 0 then
    self:destroy()
  end
end

function Brick:destroy ()
  self.world:remove(self)
  self.bricks[self.index] = nil
  self = nil
end

return Brick