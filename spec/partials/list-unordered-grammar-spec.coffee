describe 'Should tokenizes unordered list bullets when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'use asterisks', ->
    tokens = grammar.tokenizeLines '''
                                    * Level 1
                                    ** Level 2
                                    *** Level 3
                                    **** Level 4
                                    ***** Level 5
                                    '''
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' Level 1', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[1][0]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1][1]).toEqual value: ' Level 2', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 2
    expect(tokens[2][0]).toEqual value: '***', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[2][1]).toEqual value: ' Level 3', scopes: ['source.asciidoc']
    expect(tokens[3]).toHaveLength 2
    expect(tokens[3][0]).toEqual value: '****', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[3][1]).toEqual value: ' Level 4', scopes: ['source.asciidoc']
    expect(tokens[4]).toHaveLength 2
    expect(tokens[4][0]).toEqual value: '*****', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[4][1]).toEqual value: ' Level 5', scopes: ['source.asciidoc']


  it 'use hyphen', ->
    tokens = grammar.tokenizeLines '''
                                    - foobar
                                    - foobar foobar
                                    - foobar foobar foobar
                                    '''
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1][1]).toEqual value: ' foobar foobar', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[2][1]).toEqual value: ' foobar foobar foobar', scopes: ['source.asciidoc']

  it 'use hyphen with several levels (invalid context)', ->
    tokens = grammar.tokenizeLines '''
                                    - foobar
                                    -- foobar
                                    --- foobar
                                    '''
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: '-- foobar', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqual value: '--- foobar', scopes: ['source.asciidoc']
