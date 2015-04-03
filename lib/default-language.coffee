{CompositeDisposable} = require 'atom'

module.exports = DefaultLanguage =
	subscriptions: null

	config:
		defaultLanguage:
			title: 'Default language'
			description: 'Set default language if no language is detected'
			type: 'string'
			default: ''

	activate: (state) ->
		# Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
		@subscriptions = new CompositeDisposable

		# Subscribe to opening files
		@subscriptions.add atom.workspace.onDidOpen @onDidOpenFile

	deactivate: ->
		@subscriptions.dispose()

	onDidOpenFile: (event) ->
		if event.item.getGrammar() is atom.grammars.nullGrammar
			console.log "set default language"
