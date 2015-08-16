describe 'RPMSpec grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-rpm-spec')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.rpm-spec')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.rpm-spec'

  it 'tokenizes metadata headers', ->
    {tokens} = grammar.tokenizeLine('Packager:')
    expect(tokens[0]).toEqual value: 'Packager:', scopes: ['source.rpm-spec',
     'keyword.rpm-spec']

  it 'tokenizes numbers', ->
    {tokens} = grammar.tokenizeLine('1234')
    expect(tokens[0]).toEqual value: '1234', scopes: ['source.rpm-spec',
     'contstant.numeric.rpm-spec']

  it 'tokenizes operators', ->
    {tokens} = grammar.tokenizeLine('>=')
    expect(tokens[0]).toEqual value: '>=', scopes: ['source.rpm-spec',
     'keyword.operator.logical.rpm-spec']

    {tokens} = grammar.tokenizeLine('||')
    expect(tokens[0]).toEqual value: '||', scopes: ['source.rpm-spec',
     'keyword.operator.logical.rpm-spec']

  it 'tokenizes section headers', ->
    {tokens} = grammar.tokenizeLine('%build')
    expect(tokens[0]).toEqual value: '%build', scopes: ['source.rpm-spec',
     'entity.name.section.rpm-spec']

    {tokens} = grammar.tokenizeLine('%post')
    expect(tokens[0]).toEqual value: '%post', scopes: ['source.rpm-spec',
     'entity.name.section.rpm-spec']

    {tokens} = grammar.tokenizeLine('%postun')
    expect(tokens[0]).toEqual value: '%postun', scopes: ['source.rpm-spec',
     'entity.name.section.rpm-spec']

    {tokens} = grammar.tokenizeLine('%description')
    expect(tokens[0]).toEqual value: '%description', scopes: ['source.rpm-spec',
     'entity.name.section.rpm-spec']

    {tokens} = grammar.tokenizeLine('%changelog')
    expect(tokens[0]).toEqual value: '%changelog', scopes: ['source.rpm-spec',
     'entity.name.section.rpm-spec']

  it 'tokenizes conditional statement parts', ->
    {tokens} = grammar.tokenizeLine('%if')
    expect(tokens[0]).toEqual value: '%if', scopes: ['source.rpm-spec',
     'keyword.control.rpm-spec']

    {tokens} = grammar.tokenizeLine('%ifarch')
    expect(tokens[0]).toEqual value: '%ifarch', scopes: ['source.rpm-spec',
     'keyword.control.rpm-spec']

    {tokens} = grammar.tokenizeLine('%ifnarch')
    expect(tokens[0]).toEqual value: '%ifnarch', scopes: ['source.rpm-spec',
     'keyword.control.rpm-spec']

    {tokens} = grammar.tokenizeLine('%ifnos')
    expect(tokens[0]).toEqual value: '%ifnos', scopes: ['source.rpm-spec',
     'keyword.control.rpm-spec']

    {tokens} = grammar.tokenizeLine('%ifos')
    expect(tokens[0]).toEqual value: '%ifos', scopes: ['source.rpm-spec',
     'keyword.control.rpm-spec']

    {tokens} = grammar.tokenizeLine('%else')
    expect(tokens[0]).toEqual value: '%else', scopes: ['source.rpm-spec',
     'keyword.control.rpm-spec']

    {tokens} = grammar.tokenizeLine('%endif')
    expect(tokens[0]).toEqual value: '%endif', scopes: ['source.rpm-spec',
     'keyword.control.rpm-spec']

  it 'tokenizes conditional statement parts with whitespace', ->
    {tokens} = grammar.tokenizeLine('%if ')
    expect(tokens[0]).toEqual value: '%if', scopes: ['source.rpm-spec',
     'keyword.control.rpm-spec']

    {tokens} = grammar.tokenizeLine('%ifarch ')
    expect(tokens[0]).toEqual value: '%ifarch', scopes: ['source.rpm-spec',
     'keyword.control.rpm-spec']

  it 'tokenizes definitions', ->
    {tokens} = grammar.tokenizeLine('%global')
    expect(tokens[0]).toEqual value: '%global', scopes: ['source.rpm-spec',
     'storage.modifier.rpm-spec']

    {tokens} = grammar.tokenizeLine('%define')
    expect(tokens[0]).toEqual value: '%define', scopes: ['source.rpm-spec',
     'storage.modifier.rpm-spec']

    {tokens} = grammar.tokenizeLine('%undefine')
    expect(tokens[0]).toEqual value: '%undefine', scopes: ['source.rpm-spec',
     'storage.modifier.rpm-spec']

  it 'tokenizes simple variables', ->
    {tokens} = grammar.tokenizeLine('%version')
    expect(tokens[0]).toEqual value: '%version', scopes: ['source.rpm-spec',
     'variable.parameter.rpm-spec']

  it 'tokenizes variables near whitespace', ->
    {tokens} = grammar.tokenizeLine(' %version ')
    expect(tokens[0]).toEqual value: 'version', scopes: ['source.rpm-spec',
     'variable.parameter.rpm-spec']

  it 'tokenizes variables at end of paths', ->
    {tokens} = grammar.tokenizeLine('something/%version')
    expect(tokens[1]).toEqual value: '%version', scopes: ['source.rpm-spec',
     'variable.parameter.rpm-spec']

  it 'tokenizes complex named variables', ->
    {tokens} = grammar.tokenizeLine('%Ver_S10n')
    expect(tokens[0]).toEqual value: '%Ver_S10n', scopes: ['source.rpm-spec',
     'variable.parameter.rpm-spec']

  it 'tokenizes variables embedded in text', ->
    {tokens} = grammar.tokenizeLine('x%{pkg_version}y')
    expect(tokens[2]).toEqual value: 'pkg_version', scopes: ['source.rpm-spec',
     'variable.parameter.rpm-spec']

  it 'tokenizes embedded variables by themselves', ->
    {tokens} = grammar.tokenizeLine('%{pkg_version}')
    expect(tokens[1]).toEqual value: 'pkg_version', scopes: ['source.rpm-spec',
     'variable.parameter.rpm-spec']

  it 'tokenizes embedded variables testing for null', ->
    {tokens} = grammar.tokenizeLine('%{?pkg_version}')
    expect(tokens[1]).toEqual value: '%{?', scopes: ['source.rpm-spec',
      'punctuation.other.bracket.rpm-spec']
    expect(tokens[2]).toEqual value: 'pkg_version', scopes: ['source.rpm-spec',
      'contstant.numeric.rpm-spec']
    expect(tokens[3]).toEqual value: '}', scopes: ['source.rpm-spec',
      'punctuation.other.bracket.rpm-spec']
