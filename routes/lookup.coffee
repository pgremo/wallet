journal = require '../data/journal'
toCSV = require '../lib/csv'

exports.lookup = (req, res) ->
  journal.load req.params
  .then (result) -> res.send toCSV (key for key of result[0]), result
  .catch (err) -> console.log err

