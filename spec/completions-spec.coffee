describe "AsciiDoc autocompletions", ->
  [pack, editor, provider, completions] = []

  getCompletions = (options={}) ->
    cursor = editor.getLastCursor()
    start = cursor.getBeginningOfCurrentWordBufferPosition()
    end = cursor.getBufferPosition()
    prefix = editor.getTextInRange([start, end])

    request =
      editor: editor
      bufferPosition: end
      scopeDescriptor: cursor.getScopeDescriptor()
      prefix: prefix
      activatedManually: options.activatedManually ? true
    provider.getSuggestions(request)

  beforeEach ->
    completions = null

    waitsForPromise ->
      atom.packages.activatePackage('language-asciidoc').then (p) -> pack = p

    runs ->
      provider = pack.mainModule.getCompletionProvider()

    waitsFor 'provider is loaded', ->
      Object.keys(provider.attributes).length > 0

    waitsForPromise ->
      atom.workspace.open('test.adoc').then (e) -> editor = e

  describe 'should provide completion when', ->

    it 'is in an attribute reference without letter prefix', ->
      editor.setText '{b}'
      editor.setCursorBufferPosition([0, 1])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 57

    it 'is in an attribute reference', ->
      editor.setText '{b}'
      editor.setCursorBufferPosition([0, 2])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 6

        expect(completions[0]).toEqualJson
          text: 'backend'
          displayText: 'backend'
          type: 'variable'
          description: 'Backend used to create the output file.'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'
          rightLabel: 'asciidoc'

        expect(completions[1]).toEqualJson
          text: 'backslash'
          displayText: 'backslash'
          type: 'variable'
          description: '\\'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'
          rightLabel: 'asciidoc'

        expect(completions[2]).toEqualJson
          text: 'backtick'
          displayText: 'backtick'
          type: 'variable'
          description: '`'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'
          rightLabel: 'asciidoc'

        expect(completions[3]).toEqualJson
          text: 'basebackend'
          displayText: 'basebackend'
          type: 'variable'
          description: 'The backend value minus any trailing numbers.'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'
          rightLabel: 'asciidoc'

        expect(completions[4]).toEqualJson
          text: 'blank'
          displayText: 'blank'
          type: 'variable'
          description: 'nothing'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'
          rightLabel: 'asciidoc'

        expect(completions[5]).toEqualJson
          text: 'brvbar'
          displayText: 'brvbar'
          type: 'variable'
          description: '&#166;'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'
          rightLabel: 'asciidoc'

    it 'with a local attribute definition', ->
      editor.setText '''
        :zzzzz:

        {zz}
        '''
      editor.setCursorBufferPosition([2, 3])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 2

        expect(completions[0]).toEqualJson
          text: 'zwsp'
          displayText: 'zwsp'
          type: 'variable'
          description: '&#8203;'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'
          rightLabel: 'asciidoc'

        expect(completions[1]).toEqualJson
          text: 'zzzzz'
          displayText: 'zzzzz'
          type: 'variable'
          description: 'Local attribute'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#using-attributes-set-assign-and-reference'
          rightLabel: 'local'

    it 'with a local attribute definition after the current position', ->
      editor.setText '''
        {zz}

        :zzzzz:
        '''
      editor.setCursorBufferPosition([0, 3])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 1

        expect(completions[0]).toEqualJson
          text: 'zwsp'
          displayText: 'zwsp'
          type: 'variable'
          description: '&#8203;'
          descriptionMoreURL: 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'
          rightLabel: 'asciidoc'

  describe 'should not provide completion when', ->

    it 'editor does not contains text', ->
      editor.setText ''

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs -> expect(completions.length).toBe 0

    it 'is not in an attribute reference', ->
      editor.setText 'a'

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs -> expect(completions.length).toBe 0
