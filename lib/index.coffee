{CompositeDisposable, TextEditor} = require 'atom'

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
    @subscriptions = new CompositeDisposable()

    # Subscribe to opening files
    @subscriptions.add atom.workspace.observePaneItems (item) => @checkGrammar(item)

    # Trigger check grammar if all packages are loaded (custom languages)
    @subscriptions.add atom.packages.onDidActivateInitialPackages =>
      for item in atom.workspace.getPaneItems()
        @checkGrammar item

    # Register command that toggles this view
    # @subscriptions.add atom.grammars.onDidAddGrammar (e) => @updateConfigGrammar(e)
    # @subscriptions.add atom.grammars.onDidUpdateGrammar (e) => @updateConfigGrammar(e)
    # @updateConfigGrammar()

  deactivate: ->
    @subscriptions.dispose()

  # updateConfigGrammar: (grammar) ->
  #   if grammar isnt undefined
  #     @config.defaultLanguage.enum.push grammar.name
  #   else
  #     for grammar, i in atom.grammars.grammars
  #       if grammar isnt atom.grammars.nullGrammar
  #         @config.defaultLanguage.enum.push grammar.name

  checkGrammar: (item) ->
    # Enable grammar check in TextEditor only
    if TextEditor.prototype.isPrototypeOf item

      if item.getGrammar() is atom.grammars.nullGrammar
        newGrammar = atom.config.get('default-language.defaultLanguage')

        if newGrammar isnt 'Disabled'

          for grammar in atom.grammars.grammars
            if grammar.name && grammar.name.toLowerCase().replace(/\ /g, '') is newGrammar.toLowerCase().replace(/\ /g, '')
              item.setGrammar(grammar)
              break
