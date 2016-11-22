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

    if @isAttributeReferenceScope scopes, editor, bufferPosition
      new Promise (resolve, reject) =>

        localAttributes = @extractLocalAttributes editor

        suggestions = _.chain @attributes
          .map (attribute, key) ->
            suggestion =
                type: 'variable'
                text: key
                displayText: key
                rightLabel: 'asciidoc'
                description: attribute.description or key
                descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'
          .concat localAttributes
          .filter (attribute) ->
            if prefix.match /^[\w]/ then firstCharsEqual(attribute.text, prefix) else true
          .sortBy (attribute) -> attribute.text.toLowerCase()
          .value()

        resolve(suggestions)
    else
      Promise.resolve([])


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
          description: 'Local attribute'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#using-attributes-set-assign-and-reference'
      .value()

  isAttributeReferenceScope: (scopes, editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    beginPattern = /^\{.*/g
    endPattern =  /^.*\}$/g
    matchPrefix = beginPattern.test(line) and not endPattern.test(line)

    scopes.includes('markup.substitution.attribute-reference.asciidoc') and matchPrefix

  loadCompletions: ->
    completionsFilePath = path.resolve __dirname, '..', 'completions', 'attribute-completions.json'
    new Promise (resolve, reject) ->
      CSON.readFile completionsFilePath, (error, data) ->
        if error? then reject error else resolve data
    .then (data) =>
      {@attributes} = data

firstCharsEqual = (str1, str2) ->
  str1[0].toLowerCase() is str2[0].toLowerCase()
