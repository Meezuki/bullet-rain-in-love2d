function love.load()
    gameOver = false
    player = {
        x = 400,
        y = 550,
        width = 25,
        height = 25,
        speed = 3,
        sprite = love.graphics.newImage('sprites/mizuki.png')
    }

    -- background = love.graphics.newImage('sprites/bg.png')
    gameOverBackground = love.graphics.newImage('sprites/game_over.jpg')

    -- get width
    windowWidth, windowHeight = love.graphics.getDimensions()

    bullets = {}
    bulletImage = love.graphics.newImage('sprites/bullets.png')
    bulletTimer = 0
    bulletSpawnRate = 0.5

    score = 0

    specialBulletImage = love.graphics.newImage('sprites/special_bullet.png')


end

function spawnBullet()
    if gameOver then return end

    local isSpecial = math.random() < 0.2

    local bullet = {
        x = math.random(0, windowWidth - bulletImage:getWidth()),
        y = -bulletImage:getHeight(),
        width = bulletImage:getWidth() *0.5,
        height = bulletImage:getHeight()* 0.5,
        speed = 200,
        isSpecial = isSpecial,
    }

    if isSpecial then
        bullet.image = specialBulletImage
        -- bullet.width = specialBulletImage:getWidth()
        -- bullet.height = specialBulletImage:getHeight()
        bullet.score = -1
    else
        bullet.image = bulletImage
        -- bullet.width = bulletImage:getWidth()
        -- bullet.height = bulletImage:getHeight()
        bullet.score = 1
    end
    table.insert(bullets, bullet)
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed *dt
    end

    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed *dt
    end

    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed *dt
    end

    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed *dt
    end

    bulletTimer = bulletTimer + dt
    if bulletTimer >= bulletSpawnRate then
        spawnBullet()
        bulletTimer = 0
    end
   
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        b.y = b.y + b.speed * dt

        -- Cek tabrakan dengan pemain
        if checkCollision(player, b) then
            if b.isSpecial then
                gameOver = true
            else
            score = score + b.score
            end
            table.remove(bullets, i)

        elseif b.y > windowHeight then
            table.remove(bullets, i) 
        end
    end

end

function love.draw()
    -- love.graphics.draw(background,0,0,0,scaleX,scaleY)
    love.graphics.draw(player.sprite, player.x,player.y)

    for _, b in ipairs(bullets) do
        love.graphics.draw(b.image, b.x, b.y)
    end

    -- Gambar skor
    love.graphics.print("Score: " .. score, 10, 10)
    

    -- death
    if gameOver then
        -- love.graphics.setColor(1, 0, 0, 1)

        local bgW = gameOverBackground:getWidth()
        local bgH = gameOverBackground:getHeight()
        local bgW = gameOverBackground:getWidth()
        local bgH = gameOverBackground:getHeight()
        local scaleX = windowWidth / bgW
        local scaleY = windowHeight / bgH

        love.graphics.draw(gameOverBackground,0,0,0,scaleX,scaleY)
        love.graphics.printf(' GAME OVER ',0,windowHeight/2,windowWidth,"center")
    end
end

function checkCollision(a, b)

    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

function love.keypressed(key)
    if gameOver and key == "r" then
        love.load() -- Restart game by re-calling load()
    end
end