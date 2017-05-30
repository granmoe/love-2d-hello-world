local bump = require('dependencies.bump')
local constants = require('constants')
local Brick = require('brick')

local lg = love.graphics
local lk = love.keyboard
local world = bump.newWorld(64)

local paddle = {
  isPaddle = true,
  hasBall = false
}
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
    local brick = Brick:new(nextX, nextY, brickWidth, brickHeight, math.ceil(i / constants.BRICKS_PER_ROW), col, i, bricks, world)
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
    brick:destroy()
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

function collideBall (dt)
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
      if (lk.isDown('space')) then
        paddle.hasBall = true
        ball.frozenVx, ball.frozenVy = ball.vx, ball.vy
        ball.vy, ball.vx = 0, 0
      end
    end
  end

  ball.vx = clampValue(ball.vx, -constants.MAX_BALL_VELOCITY, constants.MAX_BALL_VELOCITY)
  ball.vy = clampValue(ball.vy, -constants.MAX_BALL_VELOCITY, constants.MAX_BALL_VELOCITY)
end

function releaseBall ()
  paddle.hasBall = false
  if lk.isDown('left') then
    ball.vx = ball.frozenVx - 50
  elseif lk.isDown('right') then
    ball.vx = ball.frozenVx + 50
  end
  ball.vy = ball.frozenVy
  ball.frozenVx, ball.frozenVy = nil, nil
end

function love.update (dt)
  if gameProgress == 'playing' then
    if #bricks == 0 then
      gameProgress = 'won'
    elseif ball.y >= height - (ball.radius * 2) then
      gameProgress = 'lost'
    end

    if paddle.hasBall then
      if not lk.isDown('space') then
        releaseBall()
      end
    else
      collideBall(dt)
    end

    if lk.isDown('left') then
      paddle.x = math.max(paddle.x - 5, 0)
      world:update(paddle, paddle.x, paddle.y)
      if paddle.hasBall and paddle.x ~= 0 then
        ball.x = math.max(ball.x - 5, 0)
        world:update(ball, ball.x, ball.y)
      end
    elseif lk.isDown('right') then
      paddle.x = math.min(paddle.x + 5, width - paddle.width)
      world:update(paddle, paddle.x, paddle.y)
      if paddle.hasBall and paddle.x ~= width - paddle.width then
        ball.x = math.min(ball.x + 5, width - ball.radius * 2)
        world:update(ball, ball.x, ball.y)
      end
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
    lg.circle('fill', ball.x + ball.radius, ball.y + ball.radius, ball.radius)

    if (lk.isDown('space')) then
      lg.setColor(255, 0, 0)
      lg.rectangle('line', paddle.x - 2, paddle.y - 2, paddle.width + 4, paddle.height + 4)
    end

    for _, brick in pairs(bricks) do
      brick:draw()
    end
  end,

  ['won'] = function () lg.print('You won! Press R to play again.', 50, height / 10) end,

  ['lost'] = function () lg.print('You lost. Press R to play again.', 50, height / 10) end
}

function love.draw()
  drawFunctions[gameProgress]()
end

-- when ball hits paddle, if space is down, set hasBall = true
-- else do normal stuff
-- then on next update, immediately check hasBall
-- if hasBall and space is up, release ball w saved v
-- user can only contribute velocity by "throwing" the ball off the paddle
