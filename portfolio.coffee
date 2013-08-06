util = require 'util'
express = require 'express'
app = express()
app.enable('trust proxy');

# Middleware
app.use (req,res,next) -> 
	console.log '%s %s', req.method, req.url
	next()
# Ensure we are using HTTPS
app.use (req, res, next) ->
	if req.protocol == 'https'
		next()
	else
		res.send 403,{error:"The chargerizer is only accessible using HTTPS"}

# Routes
app.get '/:page?', (req, res) ->
	if req.params.page?
		res.sendfile "./public/#{req.params.page}", (err) ->
			res.send 500, {error: "Something seems to have gone wrong"}
	else
		res.sendfile './public/portfolio.html'
	
app.get '/stylesheets/:style', (req, res) ->
	res.sendfile "./portfolio/stylesheets/#{req.params.style}", (err) ->
		if err?
			res.send 500, {error:"Something seems to have gone wrong"}
			
app.get '/images/:image', (req, res) ->
	res.sendfile "./public/assets/#{req.params.image}", (err) ->
		if err?
			res.send 500, {error:"Something seems to have gone wrong"}

app.post '/charge/:token', (req, res) ->
	res.send 501,{error:"This endpoint is not implemented"}

#server = https.createServer {"pfx":fs.readFileSync process.env.CERT_PATH},app 
server = app 
server.listen 52525
console.log("Listening on port " + 52525)
