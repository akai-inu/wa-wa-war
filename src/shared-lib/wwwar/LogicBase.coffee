###
# Wa-Wa-War Logic Base Class
###
class LogicBase
	constructor: ->
		return

	# ユーザから受信した入力データによるデータ更新
	receive: (input) ->
		return

	# サーバ上のロジック更新処理
	tick: ->
		return

	# 送信用のスナップショット取得
	makeSnapshot: ->
		return

if module?
	module.exports = LogicBase
else
	window.wwwar = window.wwwar || {}
	window.wwwar.LogicBase = LogicBase
