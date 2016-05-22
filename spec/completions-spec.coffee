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
        expect(completions.length).toBe 41

    it 'is in an attribute reference', ->
      editor.setText '{b}'
      editor.setCursorBufferPosition([0, 2])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 4

        expect(completions[0].text).toBe 'backend'
        expect(completions[0].displayText).toBe 'backend'
        expect(completions[0].type).toBe 'variable'
        expect(completions[0].replacementPrefix).toBeUndefined()
        expect(completions[0].description).toBe 'Backend used to render document'
        expect(completions[0].descriptionMoreURL).toBe 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'

        expect(completions[1].text).toBe 'backslash'
        expect(completions[1].displayText).toBe 'backslash'
        expect(completions[1].type).toBe 'variable'
        expect(completions[1].replacementPrefix).toBeUndefined()
        expect(completions[1].description).toBeUndefined()
        expect(completions[1].descriptionMoreURL).toBe 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'

        expect(completions[2].text).toBe 'backtick'
        expect(completions[2].displayText).toBe 'backtick'
        expect(completions[2].type).toBe 'variable'
        expect(completions[2].replacementPrefix).toBeUndefined()
        expect(completions[2].description).toBeUndefined()
        expect(completions[2].descriptionMoreURL).toBe 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'

        expect(completions[3].text).toBe 'brvbar'
        expect(completions[3].displayText).toBe 'brvbar'
        expect(completions[3].type).toBe 'variable'
        expect(completions[3].replacementPrefix).toBeUndefined()
        expect(completions[3].description).toBeUndefined()
        expect(completions[3].descriptionMoreURL).toBe 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'

    it 'with a local attribute definition', ->
      editor.setText '''
        :zzzzz:

        {zz}
        '''
      editor.setCursorBufferPosition([2, 3])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 2

        expect(completions[0].text).toBe 'zwsp'
        expect(completions[0].displayText).toBe 'zwsp'
        expect(completions[0].type).toBe 'variable'
        expect(completions[0].replacementPrefix).toBeUndefined()
        expect(completions[0].description).toBeUndefined()
        expect(completions[0].descriptionMoreURL).toBe 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'

        expect(completions[1].text).toBe 'zzzzz'
        expect(completions[1].displayText).toBe 'zzzzz'
        expect(completions[1].type).toBe 'variable'
        expect(completions[1].replacementPrefix).toBeUndefined()
        expect(completions[1].description).toBeUndefined()
        expect(completions[1].descriptionMoreURL).toBe 'http://asciidoctor.org/docs/user-manual/#using-attributes-set-assign-and-reference'

    it 'with a local attribute definition after the current position', ->
      editor.setText '''
        {zz}

        :zzzzz:
        '''
      editor.setCursorBufferPosition([0, 3])

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs ->
        expect(completions.length).toBe 1

        expect(completions[0].text).toBe 'zwsp'
        expect(completions[0].displayText).toBe 'zwsp'
        expect(completions[0].type).toBe 'variable'
        expect(completions[0].replacementPrefix).toBeUndefined()
        expect(completions[0].description).toBeUndefined()
        expect(completions[0].descriptionMoreURL).toBe 'http://asciidoctor.org/docs/user-manual/#attribute-catalog'

  describe 'should not provide completion when', ->

    it 'editor does not contains text', ->
      editor.setText ''

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs -> expect(completions.length).toBe 0

    it 'is not in an attribute reference', ->
      editor.setText 'a'

      waitsForPromise -> getCompletions().then (c) -> completions = c
      runs -> expect(completions.length).toBe 0
