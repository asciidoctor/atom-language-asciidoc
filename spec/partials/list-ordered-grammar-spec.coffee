describe 'Should tokenizes ordered list bullets when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'use dot', ->
    tokens = grammar.tokenizeLines '''
                                    . Level 1
                                    .. Level 2
                                    ... Level 3
                                    .... Level 4
                                    ..... Level 5
                                    '''
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: '.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' Level 1', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[1][0]).toEqual value: '..', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1][1]).toEqual value: ' Level 2', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 2
    expect(tokens[2][0]).toEqual value: '...', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[2][1]).toEqual value: ' Level 3', scopes: ['source.asciidoc']
    expect(tokens[3]).toHaveLength 2
    expect(tokens[3][0]).toEqual value: '....', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[3][1]).toEqual value: ' Level 4', scopes: ['source.asciidoc']
    expect(tokens[4]).toHaveLength 2
    expect(tokens[4][0]).toEqual value: '.....', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[4][1]).toEqual value: ' Level 5', scopes: ['source.asciidoc']

  it 'use arabic', ->
    tokens = grammar.tokenizeLines '''
                                    1. foobar
                                    2. foobar
                                    3. foobar
                                    4. foobar
                                    5. foobar
                                    '''
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: '1.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[1][0]).toEqual value: '2.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 2
    expect(tokens[2][0]).toEqual value: '3.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[2][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[3]).toHaveLength 2
    expect(tokens[3][0]).toEqual value: '4.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[3][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[4]).toHaveLength 2
    expect(tokens[4][0]).toEqual value: '5.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[4][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']

  it 'use loweralpha', ->
    tokens = grammar.tokenizeLines '''
                                    a. foobar
                                    b. foobar
                                    c. foobar
                                    d. foobar
                                    e. foobar
                                    '''
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: 'a.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[1][0]).toEqual value: 'b.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 2
    expect(tokens[2][0]).toEqual value: 'c.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[2][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[3]).toHaveLength 2
    expect(tokens[3][0]).toEqual value: 'd.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[3][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[4]).toHaveLength 2
    expect(tokens[4][0]).toEqual value: 'e.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[4][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']

  it 'use upperalpha', ->
    tokens = grammar.tokenizeLines '''
                                    A. foobar
                                    B. foobar
                                    C. foobar
                                    D. foobar
                                    E. foobar
                                    '''
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: 'A.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[1][0]).toEqual value: 'B.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 2
    expect(tokens[2][0]).toEqual value: 'C.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[2][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[3]).toHaveLength 2
    expect(tokens[3][0]).toEqual value: 'D.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[3][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[4]).toHaveLength 2
    expect(tokens[4][0]).toEqual value: 'E.', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[4][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']

  it 'use lowerroman', ->
    tokens = grammar.tokenizeLines '''
                                    i) foobar
                                    ii) foobar
                                    iii) foobar
                                    iv) foobar
                                    vi) foobar
                                    '''
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: 'i)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[1][0]).toEqual value: 'ii)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 2
    expect(tokens[2][0]).toEqual value: 'iii)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[2][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[3]).toHaveLength 2
    expect(tokens[3][0]).toEqual value: 'iv)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[3][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[4]).toHaveLength 2
    expect(tokens[4][0]).toEqual value: 'vi)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[4][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']

  it 'use upperroman', ->
    tokens = grammar.tokenizeLines '''
                                    I) foobar
                                    II) foobar
                                    III) foobar
                                    IV) foobar
                                    VI) foobar
                                    '''
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: 'I)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[1][0]).toEqual value: 'II)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 2
    expect(tokens[2][0]).toEqual value: 'III)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[2][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[3]).toHaveLength 2
    expect(tokens[3][0]).toEqual value: 'IV)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[3][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
    expect(tokens[4]).toHaveLength 2
    expect(tokens[4][0]).toEqual value: 'VI)', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[4][1]).toEqual value: ' foobar', scopes: ['source.asciidoc']
