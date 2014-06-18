PlayerMe = Class.create PlayerBase,
	initialize: () ->
		PlayerBase.call @, 0
		@moveInputVector = new Vector 0, 0 # 操作量(-1～1)
		@rotatePower = 0.0 # 回転量(-1～1)
		@rotationVal = 0

		@weapon = new Weapon(@sprite.width / 2)

	move: ->
		rotateInput = 0
		rotateInput += 1 if game.input.right
		rotateInput -= 1 if game.input.left
		@updateRotate rotateInput
		@rotationVal += @rotatePower * PlayerMe.ROTATE_SPEED
		@rotationVal %= 360
		@sprite.rotation = @rotationVal + 90

		moveInputH = 0
		moveInputH += 1 if game.input.D
		moveInputH -= 1 if game.input.A

		moveInputV = 0
		moveInputV += 1 if game.input.W
		moveInputV -= 1 if game.input.S

		@updateMove moveInputH, moveInputV

		@updateAttack game.input.Space

		return

	afterMove: ->
		@weapon.update()

	# 回転情報を更新する
	updateRotate: (inputValue) ->
		@rotatePower = @addVelocity(inputValue, @rotatePower, PlayerMe.ROTATE_POWER)

	# 移動情報を更新する
	updateMove: (moveInputH, moveInputV) ->
		h = @addVelocity(moveInputH, @moveInputVector.x, PlayerMe.MOVE_POWER)
		v = @addVelocity(moveInputV, @moveInputVector.y, PlayerMe.MOVE_POWER)

		diagonal = if h isnt 0 and v isnt 0 then 0.7071067823 else 1

		@moveInputVector.x = h
		@moveInputVector.y = v

		forward = Vector.getForward @rotationVal
		left = Vector.getLeft -@rotationVal
		@x += (h * left.x + v * forward.x) * PlayerMe.MOVE_SPEED * diagonal
		@y += (h * left.y + v * forward.y) * PlayerMe.MOVE_SPEED * diagonal

	# 攻撃する
	updateAttack: (trigger) ->
		if trigger
			forward = Vector.getForward @rotationVal
			@weapon.shoot(@_offsetX, @_offsetY, forward.x, forward.y)

	addVelocity: (input, target, power) ->
		if input > 0
			target += power
		else if input < 0
			target -= power
		else if -power < target < power
			target = 0
		else
			target *= (1 - power)
		target = Math.clamp target, -1, 1
		return target



PlayerMe.ROTATE_SPEED = 6
PlayerMe.ROTATE_POWER = 0.1
PlayerMe.MOVE_SPEED = 3
PlayerMe.MOVE_POWER = 0.1
PlayerMe.SIDE_SPEED = 0.9
PlayerMe.BACK_SPEED = 0.6
