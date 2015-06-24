{CompositeDisposable} = require 'atom'

module.exports =
	subscriptions: null

	config:
		defaultLanguage:
			title: 'Default language'
			description: 'Set default language if no language is detected'
			type: 'string'
			default: 'Disabled'

	activate: (state) ->
		# Add enum after config load to prevent dataloss
		# @config.defaultLanguage.enum = ['Disabled'];

		# Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
		@subscriptions = new CompositeDisposable

		# Subscribe to opening files
		@subscriptions.add atom.workspace.onDidOpen (e) => @onDidOpenFile(e)

		# Register command that toggles this view
		# @subscriptions.add atom.grammars.onDidAddGrammar (e) => @updateConfigGrammar(e)
		# @subscriptions.add atom.grammars.onDidUpdateGrammar (e) => @updateConfigGrammar(e)
		# @updateConfigGrammar()

	deactivate: ->
		@subscriptions.dispose()

	# updateConfigGrammar: (grammar) ->
	# 	if grammar isnt undefined
	# 		@config.defaultLanguage.enum.push grammar.name
	# 	else
	# 		for grammar, i in atom.grammars.grammars
	# 			if grammar isnt atom.grammars.nullGrammar
	# 				@config.defaultLanguage.enum.push grammar.name

	onDidOpenFile: (event) ->
		# Disable it of uri is an internal page
		if event.uri?.substring(0, 7) isnt 'atom://'

			if event.item.getGrammar() is atom.grammars.nullGrammar
				newGrammar = atom.config.get('default-language.defaultLanguage')
				if newGrammar isnt 'Disabled'
					for grammar, i in atom.grammars.grammars
						if grammar.name.toLowerCase().indexOf(newGrammar.toLowerCase()) isnt -1
							event.item.setGrammar(grammar)
