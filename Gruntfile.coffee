module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		version: 'development 0.0.1'
		path: # 各種フォルダパス、メインファイルパス設定
			base: __dirname

			src:
				base: '<%= path.base %>/src'
				client: '<%= path.src.base %>/client'
				clientLib: '<%= path.src.client %>/lib'
				public: '<%= path.src.base %>/public'
				publicVendor: '<%= path.src.public %>/vendor'
				publicImg: '<%= path.src.public %>/img'
				server: '<%= path.src.base %>/server'
				serverMst: '<%= path.src.server %>/mst'
				serverLib: '<%= path.src.server %>/lib'
				sharedLib: '<%= path.src.base %>/shared-lib'

			dev:
				base: '<%= path.base %>/development'
				public: '<%= path.dev.base %>/public'
				publicVendor: '<%= path.dev.public %>/vendor'
				publicImg: '<%= path.dev.public %>/img'
				server: '<%= path.dev.base %>/server'
				serverMst: '<%= path.dev.server %>/mst'
				serverLib: '<%= path.dev.server %>/lib'

			rel:
				base: '<%= path.base %>/release'
				public: '<%= path.rel.base %>/public'
				publicVendor: '<%= path.rel.public %>/vendor'
				publicImg: '<%= path.rel.public %>/img'
				server: '<%= path.rel.base %>/server'
				serverMSt: '<%= path.rel.server %>/mst'
				serverLib: '<%= path.rel.server %>/lib'

		coffee:
			options:
				bare: true
				separator: '\n// ==============================\n'
			devClient: # クライアントMain,Lib,SharedLibをコンパイル
				files: [
					{ dest: '<%= path.dev.public %>/app.js', src: ['<%= path.src.sharedLib %>/**/*.coffee', '<%= path.src.client %>/*.coffee', '<%= path.src.clientLib %>/*.coffee']}
				]

			devServer: # サーバMain,Lib,SharedLibをコンパイル
				files: [
					{ dest: '<%= path.dev.server %>/app.js', src: '<%= path.src.server %>/*.coffee'}
					{
						expand: true
						cwd: '<%= path.src.serverLib %>'
						src: '*.coffee'
						dest: '<%= path.dev.serverLib %>'
						ext: '.js'
					}
					{
						expand: true
						cwd: '<%= path.src.sharedLib %>'
						src: '**/*.coffee'
						dest: '<%= path.dev.serverLib %>'
						ext: '.js'
					}
				]

		uglify:
			relClient: # クライアントjsをuglify
				files: [
					{ dest: '<%= path.rel.public %>/app.js', src: '<%= path.dev.public %>/app.js'}
				]

		copy:
			relServer: # サーバMainをコピー
				files: [
					{ dest: '<%= path.rel.server %>/app.js', src: '<%= path.dev.server %>/app.js'}
				]
			relServerLib: # サーバLibとSharedLibをコピー
				files: [
					expand: true
					cwd: '<%= path.dev.serverLib %>'
					src: '*.js'
					dest: '<%= path.rel.serverLib %>'
					ext: '.js'
				]

			devMst: # マスタjsonファイルをdevにコピー
				files: [
					expand: true
					cwd: '<%= path.src.serverMst %>'
					src: '*.json'
					dest: '<%= path.dev.serverMst %>'
				]
			relMst: # マスタjsonファイルをrelにコピー
				files: [
					expand: true
					cwd: '<%= path.dev.serverMst %>'
					src: '*.json'
					dest: '<%= path.rel.serverMst %>'
				]

			devVendor: # vendorファイルをdevにコピー
				files: [
					expand: true
					cwd: '<%= path.src.publicVendor %>'
					src: '**'
					dest: '<%= path.dev.publicVendor %>'
				]
			relVendor: # vendorファイルをrelにコピー
				files: [
					expand: true
					cwd: '<%= path.dev.publicVendor %>'
					src: '**'
					dest: '<%= path.rel.publicVendor %>'
				]

			devImg: # imgフォルダをdevにコピー
				files: [
					expand: true
					cwd: '<%= path.src.publicImg %>'
					src: '**'
					dest: '<%= path.dev.publicImg %>'
				]
			relImg: # imgフォルダをrelにコピー
				files: [
					expand: true
					cwd: '<%= path.dev.publicImg %>'
					src: '**'
					dest: '<%= path.rel.publicImg %>'
				]

		jade:
			devPublic: # jadeファイルをdevにコピー
				options:
					pretty: true
					data:
						version: '<%= version %>'
						timestamp: '<%= grunt.template.today("yyyy-mm-dd HH:MM:ss") %>'
				files: [
					expand: true
					cwd: '<%= path.src.public %>'
					src: '*.jade'
					dest: '<%= path.dev.public %>'
					ext: '.html'
				]
			relPublic: # jadeファイルをrelにコピー
				options:
					pretty: false
					data:
						debug: false
						timestamp: '<%= grunt.template.today() %>'
				files: [
					expand: true
					cwd: '<%= path.src.public %>'
					src: '*.jade'
					dest: '<%= path.rel.public %>'
					ext: '.html'
				]

		cssmin:
			devPublic: # cssファイルをdevにコピー
				files: [
					{ dest: '<%= path.dev.public %>/style.css', src: '<%= path.src.public %>/*.css'}
				]
			relPublic: # cssファイルをrelにコピー
				files: [
					{ dest: '<%= path.rel.public %>/style.css', src: '<%= path.src.public %>/*.css'}
				]

		clean:
			devClean: # devフォルダを削除
				'<%= path.dev.base %>'
			relClean: # relフォルダを削除
				'<%= path.rel.base %>'

		watch:
			files: ['<%= path.src.base %>**/*.coffee', '<%= path.src.base %>**/*.jade', '<%= path.src.base %>**/*.css']
			tasks: ['default']



	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-jade'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-newer'

	grunt.registerTask 'devClient', [
		'coffee:devClient'
		'jade:devPublic'
		'copy:devVendor'
		'copy:devImg'
		'cssmin:devPublic'
	]

	grunt.registerTask 'devServer', [
		'coffee:devServer'
		'copy:devMst'
	]

	grunt.registerTask 'development', [
		'devClient'
		'devServer'
	]

	grunt.registerTask 'cleanDevelopment', [
		'clean:devClean'
		'clean:relClean'
		'development'
	]

	grunt.registerTask 'test', [
		'newer:coffee:devClient'
		'newer:jade:devPublic'
		'newer:copy:devVendor'
		'newer:cssmin:devPublic'
		'newer:coffee:devServer'
		'newer:copy:devMst'
	]

	grunt.registerTask 'release', [
		'cleanDevelopment'
		'uglify:relClient'
		'copy:relServer'
		'copy:relMst'
		'copy:relVendor'
		'copy:relImg'
		'jade:relPublic'
		'cssmin:relPublic'
	]

	grunt.registerTask 'default', ['cleanDevelopment']
