c = require './constants'
Logger = require './Logger'

class SnapshotHolder
	constructor: ->
		@snapshotList = []
		return

	generate: (logicWorld) ->
		@snapshotList.push logicWorld.serialize()
		return

	getLast: ->
		if @snapshotList.length is 0
			Logger.error 'SnapshotHolder has no snapshot.'
			return
		return @snapshotList[@snapshotList.length-1]

	@singleton: ->
		if !SnapshotHolder._instance?
			SnapshotHolder._instance = new SnapshotHolder()
		return SnapshotHolder._instance

module.exports = SnapshotHolder
