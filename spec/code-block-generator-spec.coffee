generator = require '../lib/code-block-generator'

describe 'Code block generator', ->

  describe 'with AsciiDoc syntax', ->

    it 'should generate default code block', ->
      languages = []
      codeBlocks = generator.makeAsciidocBlocks(languages)
      expect(codeBlocks).toHaveLength 2 # Number of blocks
      expect(codeBlocks[0]).toEqualJson
        begin: '(?=(?>(?:^\\[(source)((?:,|#)[^\\]]+)*\\]$)))'
        patterns: [
          match: '^\\[(source)((?:,|#)([^,\\]]+))*\\]$'
          captures:
            0:
              name: 'markup.heading.asciidoc'
              patterns: [
                include: '#block-attribute-inner'
              ]
        ,
          include: '#inlines'
        ,
          include: '#block-title'
        ,
          comment: 'listing block'
          name: 'markup.raw.asciidoc'
          begin: '^(-{4,})\\s*$'
          patterns: [
            include: '#block-callout'
          ,
            include: '#include-directive'
          ]
          end: '^(\\1)$'
        ,
          comment: 'open block'
          name: 'markup.raw.asciidoc'
          begin: '^(-{2})\\s*$'
          patterns: [
            include: '#block-callout'
          ,
            include: '#include-directive'
          ]
          end: '^(\\1)$'
        ,
          comment: 'literal block'
          name: 'markup.raw.asciidoc'
          begin: '^(\\.{4})\\s*$'
          patterns: [
            include: '#block-callout'
          ,
            include: '#include-directive'
          ]
          end: '^(\\1)$'
        ]
        end: '((?<=--|\\.\\.\\.\\.)[\\r\\n]+$|^\\p{Blank}*$)'

    it 'should generate listing block', ->
      languages = []
      codeBlocks = generator.makeAsciidocBlocks(languages)
      expect(codeBlocks).toHaveLength 2 # Number of blocks
      expect(codeBlocks[1]).toEqualJson
        name: 'markup.raw.asciidoc'
        begin: '^(-{4,})\\s*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        patterns: [
          include: '#block-callout'
        ,
          include: '#include-directive'
        ]
        end: '^(\\1)$'
        endCaptures:
          0: name: 'support.asciidoc'

    it 'should generate Javascript code block', ->
      languages = [
        pattern: 'javascript|js', type: 'source', code: 'js'
      ]
      codeBlocks = generator.makeAsciidocBlocks(languages)
      expect(codeBlocks).toHaveLength 3 # Number of blocks
      expect(codeBlocks[0]).toEqualJson
        name: "markup.code.js.asciidoc"
        begin: "(?=(?>(?:^\\[(source)(?:,|#)\\p{Blank}*(?i:(javascript|js))((?:,|#)[^\\]]+)*\\]$)))"
        patterns: [
          match: "^\\[(source)(?:,|#)\\p{Blank}*(?i:(javascript|js))((?:,|#)([^,\\]]+))*\\]$"
          captures:
            0:
              name: 'markup.heading.asciidoc'
              patterns: [
                include: '#block-attribute-inner'
              ]
        ,
          include: '#inlines'
        ,
          include: '#block-title'
        ,
          comment: 'listing block'
          begin: '^(-{4,})\\s*$'
          contentName: "source.embedded.js"
          patterns: [
            include: '#block-callout'
          ,
            include: '#include-directive'
          ,
            include: "source.js"
          ]
          end: '^(\\1)$'
        ,
          comment: 'open block'
          begin: '^(-{2})\\s*$'
          contentName: "source.embedded.js"
          patterns: [
            include: '#block-callout'
          ,
            include: '#include-directive'
          ,
            include: "source.js"
          ]
          end: '^(\\1)$'
        ,
          comment: 'literal block'
          begin: '^(\\.{4})\\s*$'
          contentName: "source.embedded.js"
          patterns: [
            include: '#block-callout'
          ,
            include: '#include-directive'
          ,
            include: "source.js"
          ]
          end: '^(\\1)$'
        ]
        end: '((?<=--|\\.\\.\\.\\.)[\\r\\n]+$|^\\p{Blank}*$)'

    it 'should generate C++ code block', ->
      languages = [
        pattern: 'c(pp|\\+\\+)', type: 'source', code: 'cpp'
      ]
      codeBlocks = generator.makeAsciidocBlocks(languages)
      expect(codeBlocks).toHaveLength 3 # Number of blocks
      expect(codeBlocks[0]).toEqualJson
        name: "markup.code.cpp.asciidoc"
        begin: "(?=(?>(?:^\\[(source)(?:,|#)\\p{Blank}*(?i:(c(pp|\\+\\+)))((?:,|#)[^\\]]+)*\\]$)))"
        patterns: [
          match: "^\\[(source)(?:,|#)\\p{Blank}*(?i:(c(pp|\\+\\+)))((?:,|#)([^,\\]]+))*\\]$"
          captures:
            0:
              name: 'markup.heading.asciidoc'
              patterns: [
                include: '#block-attribute-inner'
              ]
        ,
          include: '#inlines'
        ,
          include: '#block-title'
        ,
          comment: 'listing block'
          begin: '^(-{4,})\\s*$'
          contentName: "source.embedded.cpp"
          patterns: [
            include: '#block-callout'
          ,
            include: '#include-directive'
          ,
            include: "source.cpp"
          ]
          end: '^(\\1)$'
        ,
          comment: 'open block'
          begin: '^(-{2})\\s*$'
          contentName: "source.embedded.cpp"
          patterns: [
            include: '#block-callout'
          ,
            include: '#include-directive'
          ,
            include: "source.cpp"
          ]
          end: '^(\\1)$'
        ,
          comment: 'literal block'
          begin: '^(\\.{4})\\s*$'
          contentName: "source.embedded.cpp"
          patterns: [
            include: '#block-callout'
          ,
            include: '#include-directive'
          ,
            include: "source.cpp"
          ]
          end: '^(\\1)$'
        ]
        end: '((?<=--|\\.\\.\\.\\.)[\\r\\n]+$|^\\p{Blank}*$)'

  describe 'with Markdown syntax', ->

    it 'should generate default code block', ->
      languages = []
      codeBlocks = generator.makeMarkdownBlocks(languages)
      expect(codeBlocks).toHaveLength 1 # Number of blocks
      expect(codeBlocks[0]).toEqualJson
        name: 'markup.raw.asciidoc'
        begin: '^\\s*(`{3,}).*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        patterns: [include: '#block-callout']
        end: '^\\s*\\1\\s*$'
        endCaptures:
          0: name: 'support.asciidoc'

    it 'should generate Javascript code block', ->
      languages = [
        pattern: 'javascript|js', type: 'source', code: 'js'
      ]
      codeBlocks = generator.makeMarkdownBlocks(languages)
      expect(codeBlocks).toHaveLength 2 # Number of blocks
      expect(codeBlocks[0]).toEqualJson
        name: 'markup.code.js.asciidoc'
        begin: '^\\s*(`{3,})\\s*(?i:(javascript|js))\\s*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        end: '^\\s*\\1\\s*$'
        endCaptures:
          0: name: 'support.asciidoc'
        contentName: 'source.embedded.js'
        patterns: [
          include: '#block-callout'
        ,
          include: 'source.js'
        ]

    it 'should generate C++ code block', ->
      languages = [
        pattern: 'c(pp|\\+\\+)', type: 'source', code: 'cpp'
      ]
      codeBlocks = generator.makeMarkdownBlocks(languages)
      expect(codeBlocks).toHaveLength 2 # Number of blocks
      expect(codeBlocks[0]).toEqualJson
        name: 'markup.code.cpp.asciidoc'
        begin: '^\\s*(`{3,})\\s*(?i:(c(pp|\\+\\+)))\\s*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        end: '^\\s*\\1\\s*$'
        endCaptures:
          0: name: 'support.asciidoc'
        contentName: 'source.embedded.cpp'
        patterns: [
          include: '#block-callout'
        ,
          include: 'source.cpp'
        ]
