BulletManager = Class.create Group,
	initialize: ->
		Group.call @
		return

	addBullet: (bullet) ->
		@addChild bullet

BulletManager.singleton = ->
	if !BulletManager._instance?
		BulletManager._instance = new BulletManager()
	return BulletManager._instance
