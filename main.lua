local lurker = require('dependencies.dev.lurker.lurker')
local bump = require('dependencies.bump')

local lg = love.graphics
local lk = love.keyboard
local world = bump.newWorld(64)

local paddle = {}
local ball = {}
local bricks = {}
local leftWall
local topWall
local rightWall
local bottomWall
local height
local width

function love.load(arg)
  if arg[#arg] == '-debug' then require('mobdebug').start() end

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
  ball.vy = 200
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

  leftWall = {
    isWall = true,
    isLeftWall = true,
    x = 0 - 100,
    y = 0,
    height = height,
    width = 100
  }

  topWall = {
    isWall = true,
    isTopWall = true,
    x = 0,
    y = 0 - 100,
    height = 100,
    width = width
  }

  rightWall = {
    isWall = true,
    isRightWall = true,
    x = width,
    y = 0,
    height = height,
    width = 100
  }

  bottomWall = {
    isWall = true,
    isBottomWall = true,
    x = 0,
    y = height,
    height = 100,
    width = width
  }

  world:add(leftWall, leftWall.x, leftWall.y, leftWall.width, leftWall.height)
  world:add(topWall, topWall.x, topWall.y, topWall.width, topWall.height)
  world:add(rightWall, rightWall.x, rightWall.y, rightWall.width, rightWall.height)
  world:add(bottomWall, bottomWall.x, bottomWall.y, bottomWall.width, bottomWall.height)
end

function clampValue (val, min, max)
  if val < min then
    return min
  elseif val > max then
    return max
  else
    return val
  end
end

function collideBall (ball, dt)
  local function ballFilter (other)
    return 'bounce'
  end

  local goalX, goalY = ball.x + (ball.vx * dt), ball.y + (ball.vy * dt)
  local actualX, actualY, cols, len = world:move(ball, goalX, goalY, ballFilter)
  ball.x, ball.y = actualX, actualY

  -- if len > 0 and cols[1].move.x ~= 0 then ball.vx = ball.vx * -1 end
  if len > 0 and cols[1].move.y ~= 0 then ball.vy = ball.vy * -1 end

  for i=1, len do
    local other = cols[i].other

    if other.isBrick then
      other.health = other.health - 50
    elseif other.isPaddle then
      if lk.isDown('left') then
        ball.vx = ball.vx - 20
      elseif lk.isDown('right') then
        ball.vx = ball.vx
      end
      -- adjust ball.vx based on where it hit the paddle
      -- compensate for corner collisions that bump handled
    -- elseif other.isFloor
      -- lose life or lose game
    -- elseif other.isWall
      -- do stuff
    end
  end -- for cols

  ball.vx = clampValue(ball.vx, -200, 200)
  ball.vy = clampValue(ball.vy, -200, 200)
end

function love.update(dt)
  -- lurker.update()

  collideBall(ball, dt)
  -- removeBricks (from bricks table and from world)
  -- updateGameProgress (win/lose/lives/score)

  if lk.isDown('left') then
    paddle.x = math.max(paddle.x - 5, 0)
  elseif lk.isDown('right') then
    paddle.x = math.min(paddle.x + 5, width - paddle.width)
  end
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
