express = require 'express'
routes = require './routes'
lookup = require './routes/lookup'
http = require 'http'
path = require 'path'

port = process.env.PORT or 3000

app = express()
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'
app.use require('static-favicon') path.join __dirname, 'public/img/favicon.ico'
app.use require('morgan') 'dev'
app.use require('body-parser')()
app.use require('method-override')()
app.use express.static path.join __dirname, 'public'
app.use require('coffee-middleware')
  src: path.join __dirname, 'public'
  compress: true

if process.env.DEBUG
  app.use require('errorhandler')()

router = express.Router()
router.route '/'
  .get routes.index
router.route '/:keyID/:vCode/:characterID/:accountKey?'
  .get lookup.lookup

app.use '/', router

app.listen port, () ->
  console.log "Express server listening on port #{port}"
