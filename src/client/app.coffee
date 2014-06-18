enchant('next')
# global objects
game = null

###
# エントリポイント
###
window.addEventListener 'load', ->
	game = new Game GAME_WIDTH, GAME_HEIGHT
	game.fps = GAME_FPS
	game.preload RESOURCES

	# キーバインド
	for key, name of BINDKEYS
		game.keybind key.charCodeAt(0), name

	game.on 'load', ->
		game.replaceScene new SceneTitle()
	game.start()
