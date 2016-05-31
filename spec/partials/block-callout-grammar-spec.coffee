describe 'Should tokenizes callout in code block when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

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
    expect(tokens[0]).toHaveLength 5
    expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'markup.heading.asciidoc']
    expect(tokens[0][1]).toEqualJson value: 'source', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[0][2]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'markup.heading.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[0][3]).toEqualJson value: ' js', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[0][4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'markup.heading.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqualJson value: '----', scopes: ['source.asciidoc', 'markup.code.js.asciidoc']
    expect(tokens[2]).toHaveLength 5
    expect(tokens[2][0]).toEqualJson value: 'var http = require(\'http\');', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[2][1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc']
    expect(tokens[2][2]).toEqualJson value: '<', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[2][3]).toEqualJson value: '1', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[2][4]).toEqualJson value: '>', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[3]).toHaveLength 5
    expect(tokens[3][0]).toEqualJson value: 'http.createServer(function (req, res) {', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[2][1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc']
    expect(tokens[3][2]).toEqualJson value: '<', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[3][3]).toEqualJson value: '2', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[3][4]).toEqualJson value: '>', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[4]).toHaveLength 1
    expect(tokens[4][0]).toEqualJson value: '  res.end(\'Hello World', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[5]).toHaveLength 5
    expect(tokens[5][0]).toEqualJson value: '\');', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[2][1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc']
    expect(tokens[5][2]).toEqualJson value: '<', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[5][3]).toEqualJson value: '3', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[5][4]).toEqualJson value: '>', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js', 'callout.source.code.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[6]).toHaveLength 1
    expect(tokens[6][0]).toEqualJson value: '}).listen(1337, \'127.0.0.1\');', scopes: ['source.asciidoc', 'markup.code.js.asciidoc', 'source.embedded.js']
    expect(tokens[7]).toHaveLength 2
    expect(tokens[7][0]).toEqualJson value: '----', scopes: ['source.asciidoc', 'markup.code.js.asciidoc']
    expect(tokens[7][1]).toEqualJson value: '', scopes: ['source.asciidoc', 'markup.code.js.asciidoc']
