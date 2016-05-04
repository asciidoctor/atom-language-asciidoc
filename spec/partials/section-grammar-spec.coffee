describe 'Should tokenizes section title when', ->
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

  it 'use "abstract" keyword', ->
    {tokens} = grammar.tokenizeLine '[abstract]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'abstract', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "preface" keyword', ->
    {tokens} = grammar.tokenizeLine '[preface]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'preface', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "colophon" keyword', ->
    {tokens} = grammar.tokenizeLine '[colophon]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'colophon', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "dedication" keyword', ->
    {tokens} = grammar.tokenizeLine '[dedication]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'dedication', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "glossary" keyword', ->
    {tokens} = grammar.tokenizeLine '[glossary]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'glossary', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "bibliography" keyword', ->
    {tokens} = grammar.tokenizeLine '[bibliography]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'bibliography', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "synopsis" keyword', ->
    {tokens} = grammar.tokenizeLine '[synopsis]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'synopsis', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "appendix" keyword', ->
    {tokens} = grammar.tokenizeLine '[appendix]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'appendix', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "index" keyword', ->
    {tokens} = grammar.tokenizeLine '[index]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'index', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "sect1" keyword', ->
    {tokens} = grammar.tokenizeLine '[sect1]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'sect1', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "sect2" keyword', ->
    {tokens} = grammar.tokenizeLine '[sect2]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'sect2', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "sect3" keyword', ->
    {tokens} = grammar.tokenizeLine '[sect3]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'sect3', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']

  it 'use "sect4" keyword', ->
    {tokens} = grammar.tokenizeLine '[sect4]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toEqual value: 'sect4', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']


  it 'simple section with text', ->
    tokens = grammar.tokenizeLines '''
      [sect1]
      This is an section.
      '''
    expect(tokens).toHaveLength 2
    expect(tokens[0]).toHaveLength 3
    expect(tokens[0][0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[0][1]).toEqual value: 'sect1', scopes: ['source.asciidoc', 'markup.section.asciidoc', 'support.constant.asciidoc']
    expect(tokens[0][2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.section.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: 'This is an section.', scopes: ['source.asciidoc']











#
