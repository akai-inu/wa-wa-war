###
# プレイヤーベースクラス
#
# 自・他プレイヤーの動作、描画などを処理する
#
###
PlayerBase = enchant.Class.create enchant.Group,
	initialize: (assetName) ->
		enchant.Group.call @

		asset = game.assets[RESOURCES[assetName]]
		@sprite = new Sprite asset.width, asset.height
		@sprite.image = asset
		@originX = Math.floor asset.width / 2
		@originY = Math.floor asset.height / 2

		@addChild @sprite
		return

	onenterframe: ->
		if @beforeMove?
			@beforeMove()

		@move()

		if @afterMove?
			@afterMove()
		return

