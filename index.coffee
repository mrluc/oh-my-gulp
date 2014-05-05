express = require('express')
app = module.exports = express()

app.use require('express-partials')() #layouts
app.engine '.html', require('ejs').__express
app.set 'view engine', 'html'
app.set('views', __dirname + '/views'); #default



app.get '/', (req, res) ->
  res.render 'nav/footer', layout: no


app.listen port = process.env.port || 3000

console.log "Listening on #{ port }"