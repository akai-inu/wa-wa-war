PlayerMe = enchant.Class.create PlayerBase,
	initialize: () ->
		PlayerBase.call @, 0

	move: ->
		@sprite.x += 1
