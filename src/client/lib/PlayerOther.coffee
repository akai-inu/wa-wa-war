PlayerOther = enchant.Class.create PlayerBase,
	initialize: ->
		PlayerBase.call @, 0
		@x = 100

	move: ->
