describe 'Should tokenizes CSV table when', ->
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
      ,===
      Artist,Track,Genre

      Tool,Stinkfist,Metal
      ,===
      '''
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toHaveLength 1
    expect(tokens[0][0]).toEqualJson value: ',===', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'markup.table.delimiter.asciidoc']
    expect(tokens[1]).toHaveLength 5
    expect(tokens[1][0]).toEqualJson value: 'Artist', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc']
    expect(tokens[1][1]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[1][2]).toEqualJson value: 'Track', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc']
    expect(tokens[1][3]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[1][4]).toEqualJson value: 'Genre', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqualJson value: '', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc']
    expect(tokens[3]).toHaveLength 5
    expect(tokens[3][0]).toEqualJson value: 'Tool', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc']
    expect(tokens[3][1]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[3][2]).toEqualJson value: 'Stinkfist', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc']
    expect(tokens[3][3]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc', 'markup.table.cell.delimiter.asciidoc']
    expect(tokens[3][4]).toEqualJson value: 'Metal', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'string.unquoted.asciidoc']
    expect(tokens[4]).toHaveLength 1
    expect(tokens[4][0]).toEqualJson value: ',===', scopes: ['source.asciidoc', 'markup.table.csv.asciidoc', 'markup.table.delimiter.asciidoc']
