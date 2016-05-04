describe 'Should tokenizes explicit paragraph when', ->
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

  it 'use "normal" keyword', ->
    {tokens} = grammar.tokenizeLine '[normal]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'normal', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "literal" keyword', ->
    {tokens} = grammar.tokenizeLine '[literal]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'literal', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "listing" keyword', ->
    {tokens} = grammar.tokenizeLine '[listing]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'listing', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "TIP" keyword', ->
    {tokens} = grammar.tokenizeLine '[TIP]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'TIP', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "NOTE" keyword', ->
    {tokens} = grammar.tokenizeLine '[NOTE]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'NOTE', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "IMPORTANT" keyword', ->
    {tokens} = grammar.tokenizeLine '[IMPORTANT]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'IMPORTANT', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "WARNING" keyword', ->
    {tokens} = grammar.tokenizeLine '[WARNING]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'WARNING', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "CAUTION" keyword', ->
    {tokens} = grammar.tokenizeLine '[CAUTION]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'CAUTION', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "partintro" keyword', ->
    {tokens} = grammar.tokenizeLine '[partintro]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'partintro', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "comment" keyword', ->
    {tokens} = grammar.tokenizeLine '[comment]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'comment', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "example" keyword', ->
    {tokens} = grammar.tokenizeLine '[example]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'example', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "WARNING" keyword', ->
    {tokens} = grammar.tokenizeLine '[WARNING]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'WARNING', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "sidebar" keyword', ->
    {tokens} = grammar.tokenizeLine '[sidebar]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'sidebar', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "source" keyword', ->
    {tokens} = grammar.tokenizeLine '[source]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'source', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "music" keyword', ->
    {tokens} = grammar.tokenizeLine '[music]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'music', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "latex" keyword', ->
    {tokens} = grammar.tokenizeLine '[latex]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'latex', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']

  it 'use "graphviz" keyword', ->
    {tokens} = grammar.tokenizeLine '[graphviz]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toEqual value: 'graphviz', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']


  it 'simple title with example block', ->
    tokens = grammar.tokenizeLines '''
      [example]
      ====
      foobar
      ====
      '''
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toHaveLength 3
    expect(tokens[0][0]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[0][1]).toEqual value: 'example', scopes: ['source.asciidoc', 'markup.explicit.asciidoc', 'support.constant.asciidoc']
    expect(tokens[0][2]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.explicit.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: '====', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqual value: 'foobar', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqual value: '====', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
