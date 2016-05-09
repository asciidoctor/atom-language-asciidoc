describe 'Should tokenizes text link when', ->
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

  it 'is a simple url with http', ->
    {tokens} = grammar.tokenizeLine 'http://www.docbook.org/[DocBook.org]'
    expect(tokens).toHaveLength 2
    expect(tokens[0]).toEqualJson value: 'http://www.docbook.org/', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[1]).toEqualJson value: '[DocBook.org]', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']

  it 'is a simple url with http in phrase', ->
    {tokens} = grammar.tokenizeLine 'Go on http://foobar.com now'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[2]).toEqualJson value: 'http://foobar.com', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  it 'is a simple url with https', ->
    {tokens} = grammar.tokenizeLine 'Go on https://foobar.com now'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[2]).toEqualJson value: 'https://foobar.com', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  it 'is a simple url with file', ->
    {tokens} = grammar.tokenizeLine 'Go on file://foobar.txt now'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[2]).toEqualJson value: 'file://foobar.txt', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  it 'is a simple url with ftp', ->
    {tokens} = grammar.tokenizeLine 'Go on ftp://foobar.txt now'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[2]).toEqualJson value: 'ftp://foobar.txt', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  it 'is a simple url with irc', ->
    {tokens} = grammar.tokenizeLine 'Go on irc://foobar now'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[2]).toEqualJson value: 'irc://foobar', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  it 'is a simple url with https started with "link:"', ->
    {tokens} = grammar.tokenizeLine 'Go on link:https://foobar.com now'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqualJson value: 'Go on ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: 'link:', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[2]).toEqualJson value: 'https://foobar.com', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  it 'is a simple url in a bullet list', ->
    {tokens} = grammar.tokenizeLine '* https://foobar.com now'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[2]).toEqualJson value: 'https://foobar.com', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  it 'have optional link text and attributes', ->
    {tokens} = grammar.tokenizeLine 'Go on link:url[optional link text, optional target attribute, optional role attribute] now'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqualJson value: 'Go on ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: 'link:', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[2]).toEqualJson value: 'url', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[3]).toEqualJson value: '[optional link text, optional target attribute, optional role attribute]', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[4]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  it 'is a simple mailto', ->
    {tokens} = grammar.tokenizeLine 'Go on mailto:doc.writer@example.com[] now'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqualJson value: 'Go on ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: 'mailto:', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[2]).toEqualJson value: 'doc.writer@example.com', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc', 'support.constant.link.inline.asciidoc']
    expect(tokens[3]).toEqualJson value: '[]', scopes: ['source.asciidoc', 'markup.link.inline.asciidoc']
    expect(tokens[4]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  it 'is a email', ->
    {tokens} = grammar.tokenizeLine 'foo doc.writer@example.com bar'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: 'doc.writer@example.com', scopes: ['source.asciidoc', 'markup.link.inline.email.asciidoc']
    expect(tokens[2]).toEqualJson value: ' bar', scopes: ['source.asciidoc']
