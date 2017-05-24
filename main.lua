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
local gameProgress
local MAX_BALL_VELOCITY = 400
local NUM_BRICKS = 24
local BRICKS_PER_ROW = 8

function init ()
  gameProgress = 'playing'
  paddle.width = width / 6
  paddle.height = height / 40
  paddle.x = (width / 2) - (paddle.width / 2)
  paddle.y = height - (paddle.height * 3)
  paddle.isPaddle = true

  ball.radius = width / 100
  ball.x = (width / 2) - (ball.radius / 2)
  ball.y = (height / 2) - (ball.radius / 2)
  ball.vy = 300
  ball.vx = -40
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

  brickWidth = width / BRICKS_PER_ROW
  brickHeight = height / NUM_BRICKS
  local nextX = 0
  local nextY = brickHeight * 2

  for i = 1, NUM_BRICKS, 1 do
    local brick = createBrick(nextX, nextY)
    world:add(brick, brick.x, brick.y, brickWidth, brickHeight)
    table.insert(bricks, brick)
    nextX = nextX + brickWidth
    if (nextX == width) then
      nextX = 0
      nextY = nextY + brickHeight
    end
  end
end

function cleanup ()
  world:remove(paddle)
  world:remove(ball)
  for idx, brick in pairs(bricks) do
    world:remove(brick)
    bricks[idx] = nil
  end
end

function love.load(arg)
  if arg[#arg] == '-debug' then require('mobdebug').start() end

  height = lg.getHeight()
  width = lg.getWidth()

  init()

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

  if goalX ~= actualX then ball.vx = ball.vx * -1 end
  if goalY ~= actualY then ball.vy = ball.vy * -1 end

  for i=1, len do
    local other = cols[i].other

    if other.isBrick then
      other.health = other.health - 50
    elseif other.isBottomWall then
      print()
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

  ball.vx = clampValue(ball.vx, -MAX_BALL_VELOCITY, MAX_BALL_VELOCITY)
  ball.vy = clampValue(ball.vy, -MAX_BALL_VELOCITY, MAX_BALL_VELOCITY)
end

function removeBricks ()
  for index, brick in pairs(bricks) do
    if brick.health <= 0 then
      world:remove(brick)
      table.remove(bricks, index)
    end
  end

end

function updateGameProgress ()
  if #bricks == 0 then
    gameProgress = 'won'
  elseif ball.y >= height - (ball.radius * 2) then
    gameProgress = 'lost'
  end
end

function love.update(dt)
  -- lurker.update()
  if gameProgress == 'playing' then
    updateGameProgress()
    collideBall(ball, dt)
    removeBricks()

    if lk.isDown('left') then
      paddle.x = math.max(paddle.x - 5, 0)
      world:update(paddle, paddle.x, paddle.y)
    elseif lk.isDown('right') then
      paddle.x = math.min(paddle.x + 5, width - paddle.width)
      world:update(paddle, paddle.x, paddle.y)
    end
  else
    if lk.isDown('r') then
      cleanup()
      init()
    end
  end
end

drawFunctions = {
  ['playing'] = function ()
    lg.setColor(255, 255, 255)
    lg.rectangle('fill', paddle.x, paddle.y, paddle.width, paddle.height)
    lg.circle('fill', ball.x, ball.y, ball.radius)

    for _, brick in pairs(bricks) do
      lg.setColor(brick.r, brick.g, brick.b, (255 * (brick.health / 100)))
      lg.rectangle('fill', brick.x, brick.y, brickWidth, brickHeight)
    end
  end,

  ['won'] = function ()
    lg.print('You won! Press R to play again.', 50, height / 10)
  end,

  ['lost'] = function ()
    lg.print('You lost. Press R to play again.', 50, height / 10)
  end
}

function love.draw()
  drawFunctions[gameProgress]()
end
