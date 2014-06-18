###
# Wa-Wa-War Logic Core Class
###

if module?
	wwwar = {}
	wwwar.LogicBase = require __dirname + '/LogicBase'
	wwwar.User = require __dirname + '/User'
	wwwar.UserManager = require __dirname + '/UserManager'
	wwwar.World = require __dirname + '/World'
	module.exports = wwwar
else
	window.wwwar = window.wwwar || {}
