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

      localAttributes = @extractLocalAttributes editor

      suggestions = _.chain @attributes
        .map (attribute, key) ->
          suggestion =
              type: 'variable'
              text: key
              displayText: key
              rightLabel: 'asciidoc'
              description: attribute.description
              descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#using-attributes-set-assign-and-reference'
        .concat localAttributes
        .sortBy (attribute) -> attribute.text.toLowerCase()
        .value()

      resolve(suggestions)

  extractLocalAttributes: (editor) ->
    pattern = /^:([\w\-]+)(?:!)?:/
    textLines = editor.getBuffer().getLines()
    currentRow = editor.getCursorScreenPosition().row

    _.chain textLines
      .take currentRow
      .filter (line) -> pattern.test(line)
      .map (rawAttribute) -> pattern.exec(rawAttribute)[1]
      .uniq()
      .map (attribute) ->
        suggestion =
          type: 'variable'
          text: attribute
          displayText: attribute
          rightLabel: 'local'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#using-attributes-set-assign-and-reference'
      .value()

  loadCompletions: ->
    completionsFilePath = path.resolve __dirname, '..', 'completions', 'attribute-completions.json'
    new Promise (resolve, reject) ->
      CSON.readFile completionsFilePath, (error, data) ->
        if error? then reject error else resolve data
    .then (data) =>
      {@attributes} = data
