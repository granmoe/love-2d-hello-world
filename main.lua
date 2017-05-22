local lurker = require('dependencies.dev.lurker.lurker')
local bump = require('dependencies.bump')

local lg = love.graphics
local lk = love.keyboard
local world = bump.newWorld(64)

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
  paddle.isPaddle = true

  ball.radius = width / 100
  ball.x = (width / 2) - (ball.radius / 2)
  ball.y = (height / 2) - (ball.radius / 2)
  ball.vy = 100
  ball.vx = 0
  ball.isBall = true

  world:add(paddle, paddle.x, paddle.y, paddle.width, paddle.height)
  world:add(ball, ball.x, ball.y, ball.radius, ball.radius)

  local function createBrick(x, y)
    return {
      x = x,
      y = y,
      health = 100,
      r = math.floor(math.random()*256),
      g = math.floor(math.random()*256),
      b = math.floor(math.random()*256),
      isBrick = true
    }
  end

  brickWidth = width / 10
  brickHeight = height / 30
  local nextX = 0
  local nextY = brickHeight * 2

  for i = 0, 29, 1 do
    local brick = createBrick(nextX, nextY)
    world:add(brick, brick.x, brick.y, brickWidth, brickHeight)
    table.insert(bricks, brick)
    nextX = nextX + brickWidth
    if (nextX == width) then nextX = 0 end
    if i == 10 then nextY = nextY + brickHeight end
  end
end

function collideBall (ball, dt)
  local function ballFilter (other)
    return 'bounce'
  end

  local goalX, goalY = ball.x + (ball.vx * dt), ball.y + (ball.vy * dt)
  local actualX, actualY, cols, len = world:move(ball, goalX, goalY, ballFilter)
  ball.x, ball.y = actualX, actualY

  for i=1, len do
    local other = cols[i].other
    if other.isBrick then
      other.health = other.health - 50
    elseif other.isPaddle then
      -- adjust ball.vx based on where it hit the paddle
      -- compensate for corner collisions that bump handled
    -- elseif other.isFloor
      -- lose life or lose game
    -- elseif other.isWall
      -- do stuff
    end
  end
end

function love.update(dt)
  lurker.update()

  collideBall(ball, dt)
  -- removeBricks (from bricks table and from world)
  -- updateGameProgress (win/lose/lives/score)

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
end


function love.draw()
  lg.setColor(255, 255, 255)
  lg.rectangle('fill', paddle.x, paddle.y, paddle.width, paddle.height)
  lg.circle('fill', ball.x, ball.y, ball.radius)

  for _, brick in pairs(bricks) do
    lg.setColor(brick.r, brick.g, brick.b, (255 * (brick.health / 100)))
    lg.rectangle('fill', brick.x, brick.y, brickWidth, brickHeight)
  end
end
