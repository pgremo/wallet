require 'es6-shim'
neow = require 'neow'

client = new neow.EveClient()

load = (props) ->
  return new Promise (resolve, reject) ->
    xs = []
    recur = (props) ->
      client.fetch 'char:WalletJournal', props
        .then (result) ->
          entries = for key, value of result.transactions
            value
          Array.prototype.push.apply xs, entries
          if entries.length is props.rowCount
            props.fromID = Math.min.apply null, (parseInt(key) for key of result.transactions)
            recur props
          else
            resolve xs
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
      res.render 'lookup',
        title: 'Express'
        entries: result

