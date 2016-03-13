if require?
	c = require './Constants'
	Logger = require './Logger'
	_ = require 'underscore'

class SnapshotHolder
	constructor: ->
		@data = []
		@clientTimeData = [] # 各データのユーザー取得時間
		return

	# ロジックツリーをSnapshot化する(Server)
	generate: (logicRoot) ->
		if not c.IS_SERVER
			Logger.error 'Client cannot use SnapshotHolder#generate.'
			return

		@data.push logicRoot.serialize()
		return _.last @data

	# スナップショットを追加する(Client)
	add: (snapshot) ->
		if c.IS_SERVER
			Logger.error 'Server cannot use SnapshotHolder#add.'
			return

		if not _.isArray snapshot
			Logger.error 'Snapshot must be Array.'
			return

		@data.push snapshot
		@clientTimeData.push Math.round performance.now()

		if (c.IS_SERVER and @data.length > c.SERVER_SNAPSHOT_HOLD) or (not c.IS_SERVER and @data.length > c.CLIENT_SNAPSHOT_HOLD)
			@data.shift()
			@clientTimeData.shift()

		return snapshot

	# 現在のサーバ時間を予測して取得する
	getCalculatedServerTime: ->
		if c.IS_SERVER
			Logger.warning 'Server cannot use SnapshotHolder#getCalculatedServerTime.'
			return

		s = @getLatestMeta()
		if not s? then return 0

		lastTickTime = s[1] # tickTime
		gotTime = _.last @clientTimeData
		elapsed = Math.round performance.now() - gotTime
		return lastTickTime + elapsed

	# 最新のスナップショットを取得する
	getLatest: ->
		if @data.length is 0
			Logger.warning 'SnapshotHolder has no snapshot.'
			return null

		return _.last @data

	# 最新のスナップショットのメタ情報を取得する
	getLatestMeta: ->
		s = @getLatest()
		return if not s? then null else s[0]

	@singleton: ->
		if !SnapshotHolder._instance?
			SnapshotHolder._instance = new SnapshotHolder()
		return SnapshotHolder._instance

module.exports = SnapshotHolder if module?
