module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		path: # 各種フォルダパス、メインファイルパス設定
			src: __dirname + '/src'
			development: __dirname + '/development'
			release: __dirname + '/release'

			srcClient: '<%= path.src %>/client'
			srcClientLib: '<%= path.srcClient %>/lib'
			srcPublic: '<%= path.src %>/public'
			srcPublicVendor: '<%= path.srcPublic %>/vendor'
			srcServer: '<%= path.src %>/server'
			srcServerMst: '<%= path.srcServer %>/mst'
			srcServerLib: '<%= path.srcServer %>/lib'
			srcSharedLib: '<%= path.src %>/shared-lib'

			devPublic: '<%= path.development %>/public'
			devPublicVendor: '<%= path.devPublic %>/vendor'
			devServer: '<%= path.development %>/server'
			devServerMst: '<%= path.devServer %>/mst'
			devServerLib: '<%= path.devServer %>/lib'

			relPublic: '<%= path.release %>/public'
			relPublicVendor: '<%= path.relPublic %>/vendor'
			relServer: '<%= path.release %>/server'
			relServerMSt: '<%= path.relServer %>/mst'
			relServerLib: '<%= path.relServer %>/lib'

		coffee:
			options:
				bare: true
			devClient: # クライアントMainとLibとSharedLibをコンパイル
				files: [
					{ dest: '<%= path.devPublic %>/app.js', src: '<%= path.srcClient %>/*.coffee'}
					{ dest: '<%= path.devPublic %>/lib.js', src: ['<%= path.srcClientLib %>/*.coffee', '<%= path.srcSharedLib %>/*.coffee']}
				]

			devServer: # サーバMainをコンパイル
				files: [
					{ dest: '<%= path.devServer %>/app.js', src: '<%= path.srcServer %>/*.coffee'}
					{
						expand: true
						cwd: '<%= path.srcServerLib %>'
						src: '*.coffee'
						dest: '<%= path.devServerLib %>'
						ext: '.js'
					}
					{
						expand: true
						cwd: '<%= path.srcSharedLib %>'
						src: '*.coffee'
						dest: '<%= path.devServerLib %>'
						ext: '.js'
					}
				]

		uglify:
			relClient: # クライアントjsをuglify
				files: [
					{ dest: '<%= path.relPublic %>/app.js', src: '<%= path.devPublic %>/app.js'}
					{ dest: '<%= path.relPublic %>/lib.js', src: '<%= path.devPublic %>/lib.js'}
				]

		copy:
			relServer: # サーバMainをコピー
				files: [
					{ dest: '<%= path.relServer %>/app.js', src: '<%= path.devServer %>/app.js'}
				]
			relServerLib: # サーバLibとSharedLibをコピー
				files: [
					expand: true
					cwd: '<%= path.devServerLib %>'
					src: '*.js'
					dest: '<%= path.relServerLib %>'
					ext: '.js'
				]

			devMst: # マスタjsonファイルをdevにコピー
				files: [
					expand: true
					cwd: '<%= path.srcServerMst %>'
					src: '*.json'
					dest: '<%= path.devServerMst %>'
				]
			relMst: # マスタjsonファイルをrelにコピー
				files: [
					expand: true
					cwd: '<%= path.devServerMst %>'
					src: '*.json'
					dest: '<%= path.relServerMst %>'
				]

			devVendor: # vendorファイルをdevにコピー
				files: [
					expand: true
					cwd: '<%= path.srcPublicVendor %>'
					src: '**'
					dest: '<%= path.devPublicVendor %>'
				]
			relVendor: # vendorファイルをrelにコピー
				files: [
					expand: true
					cwd: '<%= path.devPublicVendor %>'
					src: '**'
					dest: '<%= path.relPublicVendor %>'
				]

		jade:
			devPublic: # jadeファイルをdevにコピー
				options:
					pretty: true
					data:
						debug: true
						timestamp: '<%= grunt.template.today() %>'
				files: [
					expand: true
					cwd: '<%= path.srcPublic %>'
					src: '*.jade'
					dest: '<%= path.devPublic %>'
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
					cwd: '<%= path.srcPublic %>'
					src: '*.jade'
					dest: '<%= path.relPublic %>'
					ext: '.html'
				]

		cssmin:
			devPublic: # cssファイルをdevにコピー
				files: [
					{ dest: '<%= path.devPublic %>/style.css', src: '<%= path.srcPublic %>/*.css'}
				]
			relPublic: # cssファイルをrelにコピー
				files: [
					{ dest: '<%= path.relPublic %>/style.css', src: '<%= path.srcPublic %>/*.css'}
				]

		clean:
			devClean: # devフォルダを削除
				'<%= path.development %>'
			relClean: # relフォルダを削除
				'<%= path.release %>'

		watch:
			files: ['<%= path.src %>**/*.coffee', '<%= path.src %>**/*.jade', '<%= path.src %>**/*.css']
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
		'jade:relPublic'
		'cssmin:relPublic'
	]

	grunt.registerTask 'default', ['development']
