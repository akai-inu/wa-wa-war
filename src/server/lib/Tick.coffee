util = require 'util'
c = require './constants'
Logger = require './Logger'
SnapshotHolder = require './SnapshotHolder'
LogicWorld = require './wwwar/LogicWorld'

class Tick
	constructor: ->
		@isRunning = false
		@timeoutId = -1
		@currentTick = -1
		@tickTime = -1
		@elapsedTime = -1
		@startTime = []
		@currentWorld = null
		return

	startTick: ->
		@isRunning = true
		@currentTick = 0
		@tickTime = 0
		@elapsedTime = 0
		@startTime = process.hrtime()
		@currentWorld = new LogicWorld()
		me = @
		snapshot = SnapshotHolder.singleton()
		snapshot.generate(me.currentWorld)

		tick = ->
			tickStartTime = process.hrtime()
			s = snapshot.getLast()
			tickTime = process.hrtime(me.startTime)
			me.tickTime = Math.floor(tickTime[0] * 1000 + tickTime[1] / 1000000)
			me.elapsedTime = me.tickTime - s[0][1]

			# world tick処理
			me.currentWorld.tick()
			me.currentWorld.meta.tickNo = me.currentTick
			me.currentWorld.meta.tickTime = me.tickTime
			me.currentWorld.meta.elapsedTime = me.elapsedTime
			snapshot.generate(me.currentWorld)

			tickElapsedTime = process.hrtime(tickStartTime)

			# 処理時間だけタイムアウト時間を減らす
			processTime = Math.floor(tickElapsedTime[0] * 1000 + tickElapsedTime[1] / 1000000)
			timeoutTime = c.TICK_MS - processTime
			if timeoutTime < 0
				timeoutTime = 0
				Logger.info 'Tick has delayed : no=%s, time=%s, elapsed=%s', me.currentTick, me.tickTime, me.elapsedTime
			Logger.debug 'Tick : no=%s, time=%s, elapsed=%s, processTime=%s', me.currentTick, me.tickTime, me.elapsedTime, processTime
			me.timeoutId = setTimeout(tick, timeoutTime)
			me.currentTick++
		tick()
		return

	stopTick: ->
		if !@isRunning or @timeoutId is -1
			@isRunning = false
			console.log 'Tick isnt running.'
			return

		@isRunning = false
		clearTimeout @timeoutId
		return

	@singleton: ->
		if !Tick._instance?
			Tick._instance = new Tick()
		return Tick._instance

module.exports = Tick
