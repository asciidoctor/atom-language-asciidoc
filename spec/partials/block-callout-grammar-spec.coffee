describe 'Should tokenizes callout in code block when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify tokens, null, ' ')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'contains simple callout', ->
    tokens = grammar.tokenizeLines '''
                                      [source, js]
                                      ----
                                      var http = require('http'); <1>
                                      http.createServer(function (req, res) { <2>
                                        res.end('Hello World\n'); <3>
                                      }).listen(1337, '127.0.0.1');
                                      ----
                                      '''
    expect(tokens).toHaveLength 8
    expect(tokens[0]).toHaveLength 1
    expect(tokens[0][0]).toEqual value: '[source, js]', scopes: ['source.asciidoc', 'support.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: '----', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'support.asciidoc']
    expect(tokens[2]).toHaveLength 4
    expect(tokens[2][0]).toEqual value: 'var http = require(\'http\'); ', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[2][1]).toEqual value: '<', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[2][2]).toEqual value: '1', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[2][3]).toEqual value: '>', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[3]).toHaveLength 4
    expect(tokens[3][0]).toEqual value: 'http.createServer(function (req, res) { ', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[3][1]).toEqual value: '<', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[3][2]).toEqual value: '2', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[3][3]).toEqual value: '>', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[4]).toHaveLength 1
    expect(tokens[4][0]).toEqual value: '  res.end(\'Hello World', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[5]).toHaveLength 4
    expect(tokens[5][0]).toEqual value: '\'); ', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[5][1]).toEqual value: '<', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[5][2]).toEqual value: '3', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[5][3]).toEqual value: '>', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[6]).toHaveLength 1
    expect(tokens[6][0]).toEqual value: '}).listen(1337, \'127.0.0.1\');', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[7]).toHaveLength 2
    expect(tokens[7][0]).toEqual value: '----', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'support.asciidoc']
    expect(tokens[7][1]).toEqual value: '', scopes: ['source.asciidoc']
