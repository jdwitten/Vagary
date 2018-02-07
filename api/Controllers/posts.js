var express = require('express')
var router = express.Router()
var Post = require('../Models/post.js')

router.get('/', function (req, res) {
  var post = new Post(1, 1, "Backpacking the Balkans", [{"url": "https://www.gstatic.com/webp/gallery/1.jpg"}], {"id" : 1,"user": 1,"title": "Backpacking the Balkans","posts" : [1, 2, 3]}, "Croatia")
  res.send({"posts": [{"id": post.id, "author": post.author, "content": post.content, "trip": post.trip, "location": post.location }]})
})

module.exports = router
