# Code blocks generator
module.exports =

  makeAsciidocBlocks: (languages, debug = false) ->
    # add languages blocks
    codeBlocks = languages.map (lang) ->
      name: "markup.code.#{lang.code}.asciidoc"
      begin: "(?=(?>(?:^\\[(source)(?:,|#)\\p{Blank}*(?i:(#{lang.pattern}))((?:,|#)[^\\]]+)*\\]$)))"
      patterns: [
        match: "^\\[(source)(?:,|#)\\p{Blank}*(?i:(#{lang.pattern}))((?:,|#)([^,\\]]+))*\\]$"
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
        contentName: "#{lang.type}.embedded.#{lang.code}"
        patterns: [
          include: '#block-callout'
        ,
          include: '#include-directive'
        ,
          include: "#{lang.type}.#{lang.code}"
        ]
        end: '^(\\1)$'
      ,
        comment: 'open block'
        begin: '^(-{2})\\s*$'
        contentName: "#{lang.type}.embedded.#{lang.code}"
        patterns: [
          include: '#block-callout'
        ,
          include: '#include-directive'
        ,
          include: "#{lang.type}.#{lang.code}"
        ]
        end: '^(\\1)$'
      ,
        comment: 'literal block'
        begin: '^(\\.{4})\\s*$'
        contentName: "#{lang.type}.embedded.#{lang.code}"
        patterns: [
          include: '#block-callout'
        ,
          include: '#include-directive'
        ,
          include: "#{lang.type}.#{lang.code}"
        ]
        end: '^(\\1)$'
      ]
      end: '((?<=--|\\.\\.\\.\\.)[\\r\\n]+$|^\\p{Blank}*$)'

    # add generic block
    codeBlocks.push
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

    # add listing block
    codeBlocks.push
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

    if debug then console.log CSON.stringify codeBlocks
    codeBlocks

  makeMarkdownBlocks: (languages, debug = false) ->
    # add languages blocks
    codeBlocks = languages.map (lang) ->
      name: "markup.code.#{lang.code}.asciidoc"
      begin: "^\\s*(`{3,})\\s*(?i:(#{lang.pattern}))\\s*$"
      beginCaptures:
        0: name: 'support.asciidoc'
      contentName: "#{lang.type}.embedded.#{lang.code}"
      patterns: [
        include: '#block-callout'
      ,
        include: "#{lang.type}.#{lang.code}"
      ]
      end: '^\\s*\\1\\s*$'
      endCaptures:
        0: name: 'support.asciidoc'

    # add generic block
    codeBlocks.push
      name: 'markup.raw.asciidoc'
      begin: '^\\s*(`{3,}).*$'
      beginCaptures:
        0: name: 'support.asciidoc'
      patterns: [
        include: '#block-callout'
      ]
      end: '^\\s*\\1\\s*$'
      endCaptures:
        0: name: 'support.asciidoc'

    if debug then console.log CSON.stringify codeBlocks
    codeBlocks
