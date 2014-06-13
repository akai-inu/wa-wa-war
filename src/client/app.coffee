enchant('next')
# global objects
game = null
time = null
debugBox = null

window.addEventListener 'load', ->
	game = new Game GAME_WIDTH, GAME_HEIGHT
	game.fps = GAME_FPS
	game.preload RESOURCES
	game.on 'load', ->
		time = new Time()
		debugBox = new DebugBox(@)
		debugBox.addTime time
		game.currentScene.addChild time
		game.currentScene.addChild debugBox

		p = new PlayerOther()
		game.currentScene.addChild p

		p = new PlayerMe()
		game.currentScene.addChild p
	game.start()
