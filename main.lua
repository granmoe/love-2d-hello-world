lurker = require('lurker/lurker')

local lg = love.graphics
local lk = love.keyboard
local paddle = {}
local ball = {}
local bricks = {}
local height
local width

function love.load()
  height = lg.getHeight()
  width = lg.getWidth()

  paddle.width = width / 6
  paddle.height = height / 40
  paddle.x = (width / 2) - (paddle.width / 2)
  paddle.y = height - (paddle.height * 3)
  paddle.vx = 0
  ball.radius = width / 100
  ball.x = (width / 2) - (ball.radius / 2)
  ball.y = (height / 2) - (ball.radius / 2)
  ball.vy = 0
  ball.vx = 0

  local function createBrick(x, y)
    return {
      x = x,
      y = y,
      health = 100,
      r = math.floor(math.random()*256),
      g = math.floor(math.random()*256),
      b = math.floor(math.random()*256)
    }
  end

  brickWidth = width / 10
  brickHeight = height / 30
  local nextX = 0
  local nextY = brickHeight * 2

  for i = 0, 29, 1 do
    table.insert(bricks, createBrick(nextX, nextY))
    nextX = nextX + brickWidth
    if (nextX == width) then nextX = 0 end
    if i == 10 then nextY = nextY + brickHeight end
  end
end


function love.update()
  lurker.update()
  local function clampPosition (obj)
    local maxHeight = height - obj.height
    local maxWidth = width - obj.width
    if (obj.x > maxWidth) then obj.x = maxWidth end
    if (obj.y > maxHeight) then obj.y = maxHeight end
    if (obj.x < 0) then obj.x = 0 end
    if (obj.y < 0) then obj.y = 0 end
  end

  if lk.isDown('left') then
    paddle.x = paddle.x - 5
  end

  if lk.isDown('right') then
    paddle.x = paddle.x + 5
  end

  clampPosition(paddle)
-- collide ball with walls
  -- if it hits 'floor' lose game
-- collide ball with bricks
-- collide ball with paddle
end


function love.draw()
  lg.setColor(255, 255, 255)
  lg.rectangle('fill', paddle.x, paddle.y, paddle.width, paddle.height)
  lg.circle('fill', ball.x, ball.y, ball.radius)
  -- draw bricks
  for _, brick in pairs(bricks) do
    lg.setColor(brick.r, brick.g, brick.b)
    lg.rectangle('fill', brick.x, brick.y, brickWidth, brickHeight)
  end
end
