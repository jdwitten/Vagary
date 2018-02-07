const express = require('express')
const app = express()

var drafts = require('./Controllers/drafts')
var posts = require('./Controllers/posts')

app.get('/', (req, res) => res.send('Hello World!'))

app.use('/drafts', drafts)
app.use('/posts', posts)


app.listen(3000, () => console.log('Vagary api listening on port 3000!'))
