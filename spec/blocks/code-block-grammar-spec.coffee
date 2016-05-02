describe 'Should tokenizes code block when', ->
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

  it 'is followed by others grammar parts', ->
    tokens = grammar.tokenizeLines '''
                                    [source,shell]
                                    ----
                                    ls -l
                                    cd ..
                                    ----
                                    <1> *Grammars* _definition_
                                    <2> *CoffeeLint* _rules_
                                    '''
    expect(tokens).toHaveLength 7 # Number of lines
    expect(tokens[0]).toHaveLength 1
    expect(tokens[0][0]).toEqual value: '[source,shell]', scopes: ['source.asciidoc', 'support.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: '----', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'support.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqual value: 'ls -l', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'source.embedded.shell']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqual value: 'cd ..', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'source.embedded.shell']
    expect(tokens[4]).toHaveLength 2
    expect(tokens[4][0]).toEqual value: '----', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'support.asciidoc']
    expect(tokens[4][1]).toEqual value: '', scopes: ['source.asciidoc']
    expect(tokens[5]).toHaveLength 9
    expect(tokens[5][0]).toEqual value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[5][1]).toEqual value: '1', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[5][2]).toEqual value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[5][3]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[5][4]).toEqual value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[5][5]).toEqual value: 'Grammars', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.bold.constrained.asciidoc']
    expect(tokens[5][6]).toEqual value: '*', scopes: [ 'source.asciidoc', 'callout.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[5][7]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[5][8]).toEqual value: '_definition_', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.italic.asciidoc']
    expect(tokens[5]).toHaveLength 9
    expect(tokens[6][0]).toEqual value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[6][1]).toEqual value: '2', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[6][2]).toEqual value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[6][3]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[6][4]).toEqual value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[6][5]).toEqual value: 'CoffeeLint', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.bold.constrained.asciidoc']
    expect(tokens[6][6]).toEqual value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[6][7]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[6][8]).toEqual value: '_rules_', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.italic.asciidoc']
