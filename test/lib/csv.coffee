toCSV = require '../../lib/csv'
should = require('chai').should()

describe 'Generate CSV', ->

  it 'Simple', ->
    data = [
      {first: 'foo', second: 'bar', third: 'baz'}
      {first: 'oof', second: 'rab', third: 'zab'}
    ]
    result = toCSV ['first', 'second', 'third'], data
    result.should.equal 'first,second,third\r\nfoo,bar,baz\r\noof,rab,zab'

  it 'Embedded "', ->
    data = [
      {first: 'foo"goo', second: 'bar', third: 'baz'}
      {first: 'oof', second: 'rab', third: 'zab'}
    ]
    result = toCSV ['first', 'second', 'third'], data
    result.should.equal 'first,second,third\r\n"foo""goo",bar,baz\r\noof,rab,zab'

  it 'Embedded ,', ->
    data = [
      {first: 'foo,goo', second: 'bar', third: 'baz'}
      {first: 'oof', second: 'rab', third: 'zab'}
    ]
    result = toCSV ['first', 'second', 'third'], data
    result.should.equal 'first,second,third\r\n"foo,goo",bar,baz\r\noof,rab,zab'

  it 'Embedded line ending', ->
    data = [
      {first: 'foo\r\ngoo', second: 'bar', third: 'baz'}
      {first: 'oof', second: 'rab', third: 'zab'}
    ]
    result = toCSV ['first', 'second', 'third'], data
    result.should.equal 'first,second,third\r\n"foo\r\ngoo",bar,baz\r\noof,rab,zab'
