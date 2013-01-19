#setting up express and the http server
express = require('express')
http = require('http')
url = require('url')
app = express();
server = http.createServer(app)
port = if process.env.PORT then process.env.PORT else 3000

#setting up socker.io
io = require('socket.io').listen(server)
knox = require('knox')

#setting up the knox client for uplaod to S3
crypto = require('crypto')
config = require('./gitignored_config.coffee')
knox_client = knox.createClient(
    key: config.s3_key
    secret: config.s3_secret
    bucket: "searchbydrawing"
)
console.log(knox_client)




#express stuff      
app.use(express.static(__dirname + '/public'));
app.enable('trust proxy')



#commented out, as we are currently delivering the static index.html
#app.get('/', (req, res) ->
#  res.send('Hello World')
#)


#as google uses X-Frame-Options: SAMEORIGIN we can not embed the result in an iframe
#app.set('view engine', 'jade');
#app.set('view options', {
#    layout: false
#});
#app.get '/d/:param_imgid', (req, res) ->
#  console.log(req)
#  imgurl = 'https://searchbydrawing.s3.amazonaws.com/images/'+req.params.param_imgid+'.png'
#  res.render('detail',
#    title: "Search by Drawing - "+req.params.param_imgid
#    imgurl: imgurl
#    google_search_by_image_url: 'https://www.google.com/searchbyimage?nota=1&image_url='+encodeURIComponent(imgurl)
#    )



#socket io stuff
io.sockets.on('connection', (socket) ->
  #socket.emit('news', { hello: 'world' })
  
  #socket.on('my other event', (data) -> 
  #  console.log(data)
  #)

  socket.on('q', (data) ->
    console.log(data)
    filename = crypto.createHash('md5').update(data.dataurl).digest("hex") + ".png"
    buf = new Buffer(data.dataurl.replace(/^data:image\/\w+;base64,/, ""),'base64')
    req = knox_client.put('/images/'+filename, {
                 'Content-Length': buf.length,
                 'Content-Type':'image/png',
                 'x-amz-acl': 'public-read'}
    )
    
    req.on('response', (res) ->
      if res.statusCode is 200
          console.log('KNOX saved to %s', req.url)
          #socket.emit('upload success', imgurl: req.url)
          url_parts=url.parse(req.url)
          console.log(url_parts)
          imageid=url_parts.pathname.replace('/images/', '').replace('.png', '')
          console.log('imageid:'+imageid)
          socket.emit('upload success', 
            imgurl: req.url
            imgid: imageid
          )
      else
          console.log('KNOX ERROR START')
          console.log(res)
          console.log('KNOX ERROR error %d', req.statusCode)
    )

    req.end(buf)
  )
)



#start the servers
server.listen(port)
console.log('Listening on port '+port);