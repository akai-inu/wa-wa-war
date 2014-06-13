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

		@addChild @sprite
		return

	onenterframe: ->
		if @beforeMove?
			@beforeMove()

		@move()

		if @afterMove?
			@afterMove()
		return

