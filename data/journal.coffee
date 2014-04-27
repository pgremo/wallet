require 'es6-shim'
neow = require 'neow'
_ = require 'lodash'

client = new neow.EveClient()

defaults =
  accountKey:
    1000
  rowCount:
    2560

exports.load = (props) ->
  query = _.assign {}, defaults, props
  return new Promise (resolve, reject) ->
    entries = []
    recur = (query) ->
      client.fetch 'corp:WalletJournal', query
      .then (result) ->
        values = (value for key, value of result.entries)
        entries.push values...
        if values.length isnt query.rowCount
          resolve entries
        else
          query.fromID = Math.min (parseInt(key) for key of result.entries)...
          recur query
      .catch (err) -> reject err
    recur query