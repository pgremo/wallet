format = (x) ->
  if /[",]|(\r\n)/.test(x)
    return '"' + x.replace(/"/, '""') + '"'
  else
    return x

module.exports = (columns, data) ->
  result = ''
  for column in columns
    if result isnt ''
      result = result + ','
    result = result + format(column)
  result = result + '\r\n'
  for row in data
    line = ''
    for column in columns
      if line isnt ''
        line = line + ','
      line = line + format(row[column])
    line = line + '\r\n'
    result = result + line
  result