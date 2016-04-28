generator = require '../lib/code-block-generator'

describe "Code block generator", ->

  describe "with AsciiDoc syntax", ->

    it 'should generate default code block', ->
      languages = []
      codeBlocks = generator.makeAsciidocBlocks(languages)
      expect(codeBlocks).toHaveLength 1 # Number of blocks
      expect(codeBlocks[0]).toEqual
        begin: '^\\s*\\[source(,[^\\],]*)?\\]$'
        beginCaptures:
          0: name: 'support.asciidoc'
        end: '(?<=----)[\\r\\n]+$'
        patterns: [
          name: 'markup.raw.asciidoc'
          begin: '^(-{4,})\\s*$'
          beginCaptures:
            0: name: 'support.asciidoc'
          end: '^\\1*$'
          endCaptures:
            0: name: 'support.asciidoc'
        ]

    it 'should generate Javascript code block', ->
      languages = [
        pattern: 'javascript|js', type: 'source', code: 'js'
      ]
      codeBlocks = generator.makeAsciidocBlocks(languages)
      expect(codeBlocks).toHaveLength 2 # Number of blocks
      expect(codeBlocks[0]).toEqual
        begin: '^\\[source,\\s*(?i:(javascript|js))\\]$'
        beginCaptures:
          0: name: 'support.asciidoc'
        patterns: [
          name: 'markup.code.js.asciidoc'
          begin: '^(-{4,})\\s*$'
          beginCaptures:
            0: name: 'support.asciidoc'
          end: '^\\1*$'
          endCaptures:
            0: name: 'support.asciidoc'
          contentName: 'source.embedded.js'
          patterns: [include: 'source.js']
        ]
        end: '(?<=----)[\\r\\n]+$'

    it 'should generate C++ code block', ->
      languages = [
        pattern: 'c(pp|\\+\\+)', type: 'source', code: 'cpp'
      ]
      codeBlocks = generator.makeAsciidocBlocks(languages)
      expect(codeBlocks).toHaveLength 2 # Number of blocks
      expect(codeBlocks[0]).toEqual
        begin: '^\\[source,\\s*(?i:(c(pp|\\+\\+)))\\]$'
        beginCaptures:
          0: name: 'support.asciidoc'
        end: '(?<=----)[\\r\\n]+$'
        patterns: [
          name: 'markup.code.cpp.asciidoc'
          begin: '^(-{4,})\\s*$'
          beginCaptures:
            0: name: 'support.asciidoc'
          end: '^\\1*$'
          endCaptures:
            0: name: 'support.asciidoc'
          contentName: 'source.embedded.cpp'
          patterns: [include: 'source.cpp']
        ]

  describe "with Markdown syntax", ->

    it 'should generate default code block', ->
      languages = []
      codeBlocks = generator.makeMarkdownBlocks(languages)
      expect(codeBlocks).toHaveLength 1 # Number of blocks
      expect(codeBlocks[0]).toEqual
        name: 'markup.raw.asciidoc'
        begin: '^\\s*(`{3,}).*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        end: '^\\s*\\1\\s*$'
        endCaptures:
          0: name: 'support.asciidoc'

    it 'should generate Javascript code block', ->
      languages = [
        pattern: 'javascript|js', type: 'source', code: 'js'
      ]
      codeBlocks = generator.makeMarkdownBlocks(languages)
      expect(codeBlocks).toHaveLength 2 # Number of blocks
      expect(codeBlocks[0]).toEqual
        name: 'markup.code.js.asciidoc'
        begin: '^\\s*(`{3,})\\s*(?i:(javascript|js))\\s*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        end: '^\\s*\\1\\s*$'
        endCaptures:
          0: name: 'support.asciidoc'
        contentName: 'source.embedded.js'
        patterns: [include: 'source.js']

    it 'should generate C++ code block', ->
      languages = [
        pattern: 'c(pp|\\+\\+)', type: 'source', code: 'cpp'
      ]
      codeBlocks = generator.makeMarkdownBlocks(languages)
      expect(codeBlocks).toHaveLength 2 # Number of blocks
      expect(codeBlocks[0]).toEqual
        name: 'markup.code.cpp.asciidoc'
        begin: '^\\s*(`{3,})\\s*(?i:(c(pp|\\+\\+)))\\s*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        end: '^\\s*\\1\\s*$'
        endCaptures:
          0: name: 'support.asciidoc'
        contentName: 'source.embedded.cpp'
        patterns: [include: 'source.cpp']
