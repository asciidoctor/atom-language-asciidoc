# Code blocks generator
module.exports =

  makeAsciidocBlocks: (languages, debug = false) ->
    # add languages blocks
    codeBlocks = languages.map (lang) ->
      begin: "^\\[(source),\\p{Blank}*(?i:(#{lang.pattern}))(?:,([^\]]*))?\\]$"
      beginCaptures:
        0: name: 'support.asciidoc'
        1: name: 'constant.asciidoc'
        2: name: 'string.asciidoc'
        3:
          patterns: [
            include: '#attribute-reference'
          ]
      patterns: [
        name: "markup.code.#{lang.code}.asciidoc"
        begin: '^(-{4,})\\s*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        contentName: "#{lang.type}.embedded.#{lang.code}"
        patterns: [
          include: '#block-callout'
        ,
          include: "#{lang.type}.#{lang.code}"
        ]
        end: '^\\1*$'
        endCaptures:
          0: name: 'support.asciidoc'
      ]
      end: '(?<=----)[\\r\\n]+$'

    # add generic block
    codeBlocks.push
      begin: '^\\[(source)(?:,([^,\\]]*)){0,2}\\]$'
      beginCaptures:
        0: name: 'support.asciidoc'
        1: name: 'constant.asciidoc'
        2: name: 'string.asciidoc'
      end: '(?<=----)[\\r\\n]+$'
      patterns: [
        name: 'markup.raw.asciidoc'
        begin: '^(-{4,})\\s*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        patterns: [include: '#block-callout']
        end: '^\\1*$'
        endCaptures:
          0: name: 'support.asciidoc'
      ]
    # add listing block
    codeBlocks.push
      name: 'markup.raw.asciidoc'
      begin: '^(-{4,})\\s*$'
      beginCaptures:
        0: name: 'support.asciidoc'
      patterns: [include: '#block-callout']
      end: '^\\1*$'
      endCaptures:
        0: name: 'support.asciidoc'

    if debug
      console.log CSON.stringify codeBlocks
    codeBlocks

  makeMarkdownBlocks: (languages, debug = false) ->
    # add languages blocks
    codeBlocks = languages.map (lang) ->
      name: "markup.code.#{lang.code}.asciidoc"
      begin: "^\\s*(`{3,})\\s*(?i:(#{lang.pattern}))\\s*$"
      beginCaptures:
        0: name: 'support.asciidoc'
      end: '^\\s*\\1\\s*$'
      endCaptures:
        0: name: 'support.asciidoc'
      contentName: "#{lang.type}.embedded.#{lang.code}"
      patterns: [
        include: '#block-callout'
      ,
        include: "#{lang.type}.#{lang.code}"
      ]

    # add generic block
    codeBlocks.push
      name: 'markup.raw.asciidoc'
      begin: '^\\s*(`{3,}).*$'
      beginCaptures:
        0: name: 'support.asciidoc'
      patterns: [include: '#block-callout']
      end: '^\\s*\\1\\s*$'
      endCaptures:
        0: name: 'support.asciidoc'

    if debug
      console.log CSON.stringify codeBlocks
    codeBlocks
