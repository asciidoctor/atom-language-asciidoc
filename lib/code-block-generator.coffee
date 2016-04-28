# Code blocks generator
module.exports =

  makeAsciidocBlocks: (languages, debug = false) ->
    # add languages blocks
    codeBlocks = languages.map (lang) ->
      begin: "^\\[source,\\s*(?i:(#{lang.pattern}))\\]$"
      beginCaptures:
        0: name: 'support.asciidoc'
      patterns: [
        name: "markup.code.#{lang.code}.asciidoc"
        begin: '^(-{4,})\\s*$'
        beginCaptures:
          0: name: 'support.asciidoc'
        end: '^\\1*$'
        endCaptures:
          0: name: 'support.asciidoc'
        contentName: "#{lang.type}.embedded.#{lang.code}"
        patterns: [include: "#{lang.type}.#{lang.code}"]
      ]
      end: '(?<=----)[\\r\\n]+$'

    # add generic block
    codeBlocks.push
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
      patterns: [include: "#{lang.type}.#{lang.code}"]

    # add generic block
    codeBlocks.push
      name: 'markup.raw.asciidoc'
      begin: '^\\s*(`{3,}).*$'
      beginCaptures:
        0: name: 'support.asciidoc'
      end: '^\\s*\\1\\s*$'
      endCaptures:
        0: name: 'support.asciidoc'

    if debug
      console.log CSON.stringify codeBlocks
    codeBlocks
