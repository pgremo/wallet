require 'es6-shim'
neow = require 'neow'
toCSV = require '../lib/csv'

client = new neow.EveClient()

load = (props) ->
  return new Promise (resolve, reject) ->
    entries = []
    recur = (props) ->
      client.fetch 'char:WalletJournal', props
        .then (result) ->
          values = for key, value of result.transactions
            value
          entries.push values...
          if values.length is props.rowCount
            props.fromID = Math.min (parseInt(key) for key of result.transactions)...
            recur props
          else
            resolve entries
        .catch (err) ->
          reject err
    recur props

exports.lookup = (req, res) ->
  load
      keyID: req.params.keyID
      vCode: req.params.vCode
      characterID: req.params.characterID
      rowCount: 25
      fromID: null
    .then (result) ->
      columns = for key of result[0]
        key
      res.send toCSV(columns, result)
    .catch (err) ->
      console err

