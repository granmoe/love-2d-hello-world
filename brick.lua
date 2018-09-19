local lg = love.graphics

function createBrick (x, y, width, height, row, col, index, bricks, world)
  local brick

  local function draw ()
    lg.setColor(brick.r / 255, brick.g / 255, brick.b / 255, (255 * (brick.health / 100)) / 255)
    lg.rectangle('fill', brick.x, brick.y, brick.width, brick.height)
  end
  
  local function takeDamage ()
    brick.health = brick.health - 50
    if brick.health <= 0 then brick.destroy() end
  end
  
  local function destroy ()
    brick.world:remove(brick)
    brick.bricks[brick.index] = nil
    brick = nil
  end

  brick = {
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
    height = height,
    draw = draw,
    takeDamage = takeDamage,
    destroy = destroy,
  }

  return brick
end

return createBrick
