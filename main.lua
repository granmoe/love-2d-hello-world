local bump = require('dependencies.bump')
local constants = require('constants')
local createBrick = require('brick')

local lg = love.graphics
local lk = love.keyboard
local world = bump.newWorld(64)

local paddle = {}
local ball = {}
local bricks = {}
local height, width, gameProgress

function init ()
  gameProgress = 'playing'
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
  ball.vy = 300
  ball.vx = -40

  world:add(paddle, paddle.x, paddle.y, paddle.width, paddle.height)
  world:add(ball, ball.x - ball.radius, ball.y - ball.radius, ball.radius * 2, ball.radius * 2)

  brickWidth = width / constants.BRICKS_PER_ROW
  brickHeight = height / constants.NUM_BRICKS
  local nextX = 0
  local nextY = brickHeight * 2

  for i = 1, constants.NUM_BRICKS, 1 do
    local col = i % constants.BRICKS_PER_ROW > 0 and i % constants.BRICKS_PER_ROW or constants.BRICKS_PER_ROW
    local brick = createBrick(nextX, nextY, brickWidth, brickHeight, math.ceil(i / constants.BRICKS_PER_ROW), col, i, bricks, world)
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
    brick.destroy()
  end
end

function love.load(arg)
  if arg[#arg] == '-debug' then require('mobdebug').start() end
  init()
  world:add({}, -100, 0, 100, height)  -- left wall
  world:add({}, 0, -100, width, 100)   -- top wall
  world:add({}, width, 0, 100, height) -- right wall
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
  local goalX, goalY = ball.x + (ball.vx * dt), ball.y + (ball.vy * dt)
  local actualX, actualY, cols, len = world:move(ball, goalX, goalY, function () return 'bounce' end)
  ball.x, ball.y = actualX, actualY

  if goalX ~= actualX then ball.vx = ball.vx * -1 end
  if goalY ~= actualY then ball.vy = ball.vy * -1 end

  for i=1, len do
    local other = cols[i].other

    if other.isBrick then
      other:takeDamage()
    elseif other.isPaddle then
      if lk.isDown('left') then
        ball.vx = ball.vx - 30
      elseif lk.isDown('right') then
        ball.vx = ball.vx + 30
      end
    end
  end

  ball.vx = clampValue(ball.vx, -constants.MAX_BALL_VELOCITY, constants.MAX_BALL_VELOCITY)
  ball.vy = clampValue(ball.vy, -constants.MAX_BALL_VELOCITY, constants.MAX_BALL_VELOCITY)
end

function updateGameProgress ()
  if #bricks == 0 then
    gameProgress = 'won'
  elseif ball.y >= height - (ball.radius * 2) then
    gameProgress = 'lost'
  end
end

function love.update(dt)
  if gameProgress == 'playing' then
    updateGameProgress()
    collideBall(ball, dt)

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

function love.draw()
  if gameProgress == 'playing' then
    lg.setColor(255, 255, 255)
    lg.rectangle('fill', paddle.x, paddle.y, paddle.width, paddle.height)
    lg.circle('fill', ball.x + ball.radius, ball.y + ball.radius, ball.radius)

    for _, brick in pairs(bricks) do
      brick.draw()
    end
  elseif gameProgress == 'won' then
    lg.print('You won! Press R to play again.', 50, height / 10)
  elseif gameProgress == 'lost' then
    lg.print('You lost. Press R to play again.', 50, height / 10)
  end
end
