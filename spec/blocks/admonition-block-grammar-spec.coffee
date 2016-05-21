describe 'Admonition block', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

# - Admonition block
# - Admonition paragraph
# - Admonition inline paragraph

  describe 'Should tokenizes when', ->

    it 'contains section title and bulleted list', ->
      tokens = grammar.tokenizeLines '''
        [IMPORTANT]
        .Feeding the Werewolves
        ====
        While werewolves are hardy community members, keep in mind the following dietary concerns:

        * They are allergic to cinnamon.
        * More than two glasses of orange juice in 24 hours makes them howl in harmony with alarms and sirens.
        * Celery makes them sad.
        ====
        foobar
        '''
      expect(tokens).toHaveLength 10
      numLine = 0
      expect(tokens[numLine]).toHaveLength 3
      expect(tokens[numLine][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[numLine][1]).toEqualJson value: 'IMPORTANT', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[numLine][2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 2
      expect(tokens[numLine][0]).toEqualJson value: '.', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[numLine][1]).toEqualJson value: 'Feeding the Werewolves', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.heading.blocktitle.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: '====', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: 'While werewolves are hardy community members, keep in mind the following dietary concerns:', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: '', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 2
      expect(tokens[numLine][0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[numLine][1]).toEqualJson value: ' They are allergic to cinnamon.', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 2
      expect(tokens[numLine][0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[numLine][1]).toEqualJson value: ' More than two glasses of orange juice in 24 hours makes them howl in harmony with alarms and sirens.', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 2
      expect(tokens[numLine][0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[numLine][1]).toEqualJson value: ' Celery makes them sad.', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 2
      expect(tokens[numLine][0]).toEqualJson value: '====', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[numLine][1]).toEqualJson value: '', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']
      numLine++
      expect(numLine).toBe 10

  describe 'Should not tokenizes when', ->

    it 'beginning with space', ->
      tokens = grammar.tokenizeLines '''
         [IMPORTANT]
        .Feeding the Werewolves
        ====
        While werewolves are hardy community members, keep in mind the following dietary concerns:
        ...
        ====
        foobar
        '''
      expect(tokens).toHaveLength 7
      numLine = 0
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: ' [IMPORTANT]', scopes: ['source.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 2
      expect(tokens[numLine][0]).toEqualJson value: '.', scopes: ['source.asciidoc']
      expect(tokens[numLine][1]).toEqualJson value: 'Feeding the Werewolves', scopes: ['source.asciidoc', 'markup.heading.blocktitle.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: '====', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: 'While werewolves are hardy community members, keep in mind the following dietary concerns:', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: '...', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: '====', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      numLine++
      expect(tokens[numLine]).toHaveLength 1
      expect(tokens[numLine][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']
      numLine++
      expect(numLine).toBe 7
