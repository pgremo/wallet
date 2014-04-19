exports.index = (req, res) ->
  console.log 'calling index'
  res.render 'index', title: 'Express'
