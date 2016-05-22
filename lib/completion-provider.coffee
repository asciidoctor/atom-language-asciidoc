_ = require 'lodash'
path = require 'path'
CSON = require 'season'

module.exports =
  # FIXME check .source.asciidoc
  selector: '.source.asciidoc'
  disableForSelector: '.source.asciidoc .comment.block.asciidoc .comment.inline.asciidoc'

  # This will take priority over the default provider, which has a priority of 0.
  # `excludeLowerPriority` will suppress any providers with a lower priority
  # i.e. The default provider will be suppressed
  inclusionPriority: 1
  excludeLowerPriority: true

  filterSuggestions: true

  attributes: {}

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->

    scopes = scopeDescriptor.getScopesArray()

    return unless scopes.includes 'markup.substitution.attribute-reference.asciidoc'

    new Promise (resolve, reject) =>
      pattern = /^:([a-zA-Z_\-!]+):/
      textLines = editor.getText().split(/\n/)
      currentRow = editor.getCursorScreenPosition().row
      counter = 0

      potentialAttributes = _.chain(textLines)
        .filter((line) ->
          counter++
          pattern.test(line) and counter<=currentRow)
        .map (rawAttribute) ->
          pattern.exec(rawAttribute)[1]
        .uniq()
        .value()

      potentialAttributes = _.map(potentialAttributes, (attribute) ->
        value =
          type: 'variable'
          text: attribute
          displayText: attribute
          rightLabel: 'local'
      )

      asciidocAttr = _.map(@attributes, (attribute, key) ->
        value =
            type: 'variable'
            text: key
            displayText: key
            rightLabel: 'asciidoc'
            description: attribute.description
      )

      potentialAttributes = potentialAttributes.concat asciidocAttr

      potentialAttributes = _.sortBy potentialAttributes, (_attribute) ->
        _attribute.text.toLowerCase()

      resolve(potentialAttributes)

  loadCompletions: ->
    completionsFilePath = path.resolve __dirname, '..', 'completions.json'
    new Promise (resolve, reject) ->
      CSON.readFile completionsFilePath, (error, data) ->
        if error? then reject error else resolve data
    .then (data) =>
      {@attributes} = data
