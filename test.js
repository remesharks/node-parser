var createReadStream = require('fs').createReadStream
var createWriteStream = require('fs').createWriteStream
var streamify = require('dt-stream')
var parse = require('./lib/parser')
var data = 0

var filename = "test.html"

var tpl = streamify(parse(createReadStream(filename), {pretty:true}))

tpl.stream.pipe(process.stdout, {end:false})
// tpl.stream.pipe(createWriteStream("test.log"))

tpl.stream.on('data', function () {
    data++
})
tpl.stream.on('end', function () {
    console.log("",data,"done.")
})
