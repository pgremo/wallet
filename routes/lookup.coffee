require 'es6-shim'
neow = require 'neow'
toCSV = require '../lib/csv'

client = new neow.EveClient()

load = (props) ->
  return new Promise (resolve, reject) ->
    entries = []
    recur = (props) ->
      client.fetch 'corp:WalletJournal', props
      .then (result) ->
        values = (value for key, value of result.entries)
        entries.push values...
        if values.length is props.rowCount
          props.fromID = Math.min (parseInt(key) for key of result.entries)...
          recur props
        else
          resolve entries
      .catch (err) -> reject err
    recur props

exports.lookup = (req, res) ->
  query =
    keyID:
      req.params.keyID
    vCode:
      req.params.vCode
    characterID:
      req.params.characterID
    accountKey:
      req.params.accountKey ? 1000
    rowCount:
      2560
  load query
  .then (result) -> res.send toCSV (key for key of result[0]), result
  .catch (err) -> console err

