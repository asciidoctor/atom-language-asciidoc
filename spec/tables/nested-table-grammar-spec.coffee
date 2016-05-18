describe 'Should tokenizes nested table when', ->
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

  it 'contains several lines', ->
    tokens = grammar.tokenizeLines '''
      !===
       !1      >s!2   !3        !4
      ^!5 2.2+^.^!6      .3+<.>m!7
      ^!8
       !9     2+>!10
      !===
      '''
    expect(tokens).toHaveLength 6
    expect(tokens[0]).toHaveLength 1
    expect(tokens[0][0]).toEqualJson value: '!===', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.delimiter.asciidoc']
    expect(tokens[1]).toHaveLength 10
    expect(tokens[1][0]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[1][1]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[1][2]).toEqualJson value: '1      ', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[1][3]).toEqualJson value: '>s', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[1][4]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[1][5]).toEqualJson value: '2   ', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[1][6]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[1][7]).toEqualJson value: '3        ', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[1][8]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[1][9]).toEqualJson value: '4', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[2]).toHaveLength 9
    expect(tokens[2][0]).toEqualJson value: '^', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[2][1]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[2][2]).toEqualJson value: '5 ', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[2][3]).toEqualJson value: '2.2+^.^', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[2][4]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[2][5]).toEqualJson value: '6      ', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[2][6]).toEqualJson value: '.3+<.>m', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[2][7]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[2][8]).toEqualJson value: '7', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[3]).toHaveLength 3
    expect(tokens[3][0]).toEqualJson value: '^', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[3][1]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[3][2]).toEqualJson value: '8', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[4]).toHaveLength 6
    expect(tokens[4][0]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[4][1]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[4][2]).toEqualJson value: '9     ', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[4][3]).toEqualJson value: '2+>', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[4][4]).toEqualJson value: '!', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[4][5]).toEqualJson value: '10', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.content.asciidoc']
    expect(tokens[5]).toHaveLength 1
    expect(tokens[5][0]).toEqualJson value: '!===', scopes: ['source.asciidoc', 'markup.table.nested.asciidoc', 'markup.table.delimiter.asciidoc']
