format = (x) ->
  if /[",]|(\r\n)/.test(x)
    '"' + x.replace(/"/, '""') + '"'
  else
    x

module.exports = (columns, data) ->
  result = (for column in columns
    format column).join() + '\r\n'
  result + (for row in data
    (for column in columns
      format row[column]).join()).join '\r\n'
