describe 'Should tokenizes text link when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'URL pattern', ->

    it 'is a simple url with http', ->
      {tokens} = grammar.tokenizeLine 'http://www.docbook.org/[DocBook.org]'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'http://www.docbook.org/', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[1]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[2]).toEqualJson value: 'DocBook.org', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[3]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']

    it 'is a simple url with http in phrase', ->
      {tokens} = grammar.tokenizeLine 'Go on http://foobar.com now'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[2]).toEqualJson value: 'http://foobar.com', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

    it 'is a simple url with https', ->
      {tokens} = grammar.tokenizeLine 'Go on https://foobar.com now'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[2]).toEqualJson value: 'https://foobar.com', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

    it 'is a simple url with file', ->
      {tokens} = grammar.tokenizeLine 'Go on file://foobar.txt now'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[2]).toEqualJson value: 'file://foobar.txt', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

    it 'is a simple url with ftp', ->
      {tokens} = grammar.tokenizeLine 'Go on ftp://foobar.txt now'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[2]).toEqualJson value: 'ftp://foobar.txt', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

    it 'is a simple url with irc', ->
      {tokens} = grammar.tokenizeLine 'Go on irc://foobar now'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'Go on', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[2]).toEqualJson value: 'irc://foobar', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

    it 'is a simple url in a bullet list', ->
      {tokens} = grammar.tokenizeLine '* https://foobar.com now'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[2]).toEqualJson value: 'https://foobar.com', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

    it 'contains attribute reference', ->
      {tokens} = grammar.tokenizeLine 'http://foo{uri-repo}bar.com now'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'http://foo', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[1]).toEqualJson value: '{uri-repo}', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[2]).toEqualJson value: 'bar.com', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: ' now', scopes: ['source.asciidoc']

  describe '"link:" & "mailto:" macro', ->

    it 'have optional link text and attributes', ->
      {tokens} = grammar.tokenizeLine 'Go on link:url[optional link text, optional target attribute, optional role attribute] now'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqualJson value: 'Go on ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'link', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[3]).toEqualJson value: 'url', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[4]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[5]).toEqualJson value: 'optional link text, optional target attribute, optional role attribute', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[7]).toEqualJson value: ' now', scopes: ['source.asciidoc']

    it 'is a simple mailto', ->
      {tokens} = grammar.tokenizeLine 'Go on mailto:doc.writer@example.com[] now'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'Go on ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'mailto', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[3]).toEqualJson value: 'doc.writer@example.com', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[4]).toEqualJson value: '[]', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[5]).toEqualJson value: ' now', scopes: ['source.asciidoc']

    it 'contains attribute reference', ->
      {tokens} = grammar.tokenizeLine 'Go on link:http://{uri-repo}[label] now'
      expect(tokens).toHaveLength 9
      expect(tokens[0]).toEqualJson value: 'Go on ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'link', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[3]).toEqualJson value: 'http://', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
      expect(tokens[4]).toEqualJson value: '{uri-repo}', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[5]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[6]).toEqualJson value: 'label', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[7]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[8]).toEqualJson value: ' now', scopes: ['source.asciidoc']

    it 'is a simple url with https started with "link:" with missing square brackets ending (invalid context)', ->
      {tokens} = grammar.tokenizeLine 'Go on link:https://foobar.com now'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: 'Go on link:https://foobar.com now', scopes: ['source.asciidoc']

  describe 'email pattern', ->

    it 'is a email', ->
      {tokens} = grammar.tokenizeLine 'foo doc.writer@example.com bar'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'doc.writer@example.com', scopes: ['source.asciidoc', 'markup.link.email.asciidoc']
      expect(tokens[2]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

  describe 'pure attribute reference link', ->

    it 'start at the beginning of the line', ->
      {tokens} = grammar.tokenizeLine '{uri-repo}[Asciidoctor]'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '{uri-repo}', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[1]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[2]).toEqualJson value: 'Asciidoctor', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[3]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']

    it 'start with "["', ->
      {tokens} = grammar.tokenizeLine '[{uri-repo}[Asciidoctor]'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[1]).toEqualJson value: '{uri-repo}', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[2]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[3]).toEqualJson value: 'Asciidoctor', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']

    it 'start with "("', ->
      {tokens} = grammar.tokenizeLine '({uri-repo}[Asciidoctor]'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: '(', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[1]).toEqualJson value: '{uri-repo}', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[2]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[3]).toEqualJson value: 'Asciidoctor', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']

    it 'start with "<"', ->
      {tokens} = grammar.tokenizeLine '<{uri-repo}[Asciidoctor]'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: '<', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[1]).toEqualJson value: '{uri-repo}', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[2]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[3]).toEqualJson value: 'Asciidoctor', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']

    it 'start with ">"', ->
      {tokens} = grammar.tokenizeLine '>{uri-repo}[Asciidoctor]'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: '>', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[1]).toEqualJson value: '{uri-repo}', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[2]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[3]).toEqualJson value: 'Asciidoctor', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']

    it 'is in a phrase', ->
      {tokens} = grammar.tokenizeLine 'foo {uri-repo}[Asciidoctor] bar'
      expect(tokens).toHaveLength 7
      expect(tokens[0]).toEqualJson value: 'foo', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[2]).toEqualJson value: '{uri-repo}', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[3]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[4]).toEqualJson value: 'Asciidoctor', scopes: ['source.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[5]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[6]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'attribute reference doesn\'t contains "uri-" (invalid context)', ->
      {tokens} = grammar.tokenizeLine 'foo {foo}[bar] bar'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '{foo}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[2]).toEqualJson value: '[bar] bar', scopes: ['source.asciidoc']
