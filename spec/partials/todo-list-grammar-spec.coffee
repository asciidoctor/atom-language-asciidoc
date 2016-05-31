describe 'Should tokenize todo lists', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'when todo', ->
    {tokens} = grammar.tokenizeLine '- [ ] todo 1'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.todo.asciidoc']
    expect(tokens[2]).toEqual value: '[ ]', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.todo.box.asciidoc']
    expect(tokens[3]).toEqual value: ' todo 1', scopes: ['source.asciidoc']

  it 'when [*] done', ->
    {tokens} = grammar.tokenizeLine('- [*] todo 1')
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.todo.asciidoc']
    expect(tokens[2]).toEqual value: '[*]', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.todo.box.asciidoc']
    expect(tokens[3]).toEqual value: ' todo 1', scopes: ['source.asciidoc']

  it 'when [x] done', ->
    {tokens} = grammar.tokenizeLine('- [x] todo 1')
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.todo.asciidoc']
    expect(tokens[2]).toEqual value: '[x]', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.todo.box.asciidoc']
    expect(tokens[3]).toEqual value: ' todo 1', scopes: ['source.asciidoc']

  it 'when a varied todo-list', ->
    tokens = grammar.tokenizeLines('''
                                    - [ ] todo 1
                                    - normal item
                                     - [x] done x
                                    - [*] done *
                                    ''')
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toHaveLength 4
    expect(tokens[0][0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[0][1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.todo.asciidoc']
    expect(tokens[0][2]).toEqual value: '[ ]', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.todo.box.asciidoc']
    expect(tokens[0][3]).toEqual value: ' todo 1', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 2
    expect(tokens[1][0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[1][1]).toEqual value: ' normal item', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 5
    expect(tokens[2][0]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.todo.asciidoc']
    expect(tokens[2][1]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[2][2]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.todo.asciidoc']
    expect(tokens[2][3]).toEqual value: '[x]', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.todo.box.asciidoc']
    expect(tokens[2][4]).toEqual value: ' done x', scopes: ['source.asciidoc']
    expect(tokens[3]).toHaveLength 4
    expect(tokens[3][0]).toEqual value: '-', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.list.bullet.asciidoc']
    expect(tokens[3][1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.todo.asciidoc']
    expect(tokens[3][2]).toEqual value: '[*]', scopes: ['source.asciidoc', 'markup.todo.asciidoc', 'markup.todo.box.asciidoc']
    expect(tokens[3][3]).toEqual value: ' done *', scopes: ['source.asciidoc']
