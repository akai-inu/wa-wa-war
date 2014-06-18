Bullet = Class.create Entity,
	initialize: (x, y, @vx, @vy, @speed) ->
		Entity.call @
		@x = x
		@y = y
		@width = 3
		@height = 3
		@backgroundColor = "#fff"
		return

	onenterframe: ->
		@x += @vx * @speed
		@y += @vy * @speed

		if @x < 0 or GAME_WIDTH < @x
			@visible = false
		else
			@visible = true

		if @age > GAME_FPS * 3
			@remove()
