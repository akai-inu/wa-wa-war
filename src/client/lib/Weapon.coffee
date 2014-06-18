Weapon = Class.create
	initialize: (@offset) ->
		@speed = Math.random() * 2 + 10
		@rate = 200
		@interval = 0
		@lastNow = performance.now()
		return

	shoot: (x, y, vx, vy) ->
		if @interval <= 0
			b = new Bullet @offset + x, @offset + y, vx, vy, @speed
			BulletManager.singleton().addBullet b
			@interval = @rate

	update: ->
		now = performance.now()
		@interval = Math.clamp @interval - (now - @lastNow), 0, 1000000
		@lastNow = now
