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

    it 'is in an attribute reference', ->
      editor.setText '{b}'
      # row, column
      editor.setCursorBufferPosition([0, 3])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 41
        for completion in completions
          expect(completion.text.length).toBeGreaterThan 0
          expect(completion.type.length).toBeGreaterThan 0
          expect(completion.descriptionMoreURL.length).toBeGreaterThan 0

    it 'with a local attribute definition', ->
      editor.setText '''
        :zzzzz:

        {zz}
        '''
      editor.setCursorBufferPosition([2, 4])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 42
        expect(completions[41].text).toBe 'zzzzz'
        expect(completions[41].displayText).toBe 'zzzzz'
        expect(completions[41].type).toBe 'variable'
        expect(completions[41].replacementPrefix).toBeUndefined()
        expect(completions[41].description).toBeUndefined()
        expect(completions[41].descriptionMoreURL).toBe 'http://asciidoctor.org/docs/user-manual/#using-attributes-set-assign-and-reference'

    it 'with a local attribute definition after the current position', ->
      editor.setText '''
        {zz}

        :zzzzz:
        '''
      editor.setCursorBufferPosition([0, 3])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 41

  describe 'should not provide completion when', ->

    it 'editor does not contains text', ->
      editor.setText ''

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs -> expect(completions.length).toBe 0

    it 'is not in an attribute reference', ->
      editor.setText 'a'

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs -> expect(completions.length).toBe 0
