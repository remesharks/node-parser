{WritableStream:XMLParser} = require 'htmlparser2'
{Template} = require 'dynamictemplate'

class Parser
    constructor: (stream, opts = {}) ->
        opts.end = off
        pause = stream.pause.bind(stream)
        resume = stream.resume.bind(stream)
        # initialize
        pause()
        @tpl = new Template(opts, resume)
        @parser = new XMLParser(this, opts.parser)
        @tpl.on('resume', resume)
        @tpl.on('pause', pause)
        stream.pipe(@parser)
        # state
        @parents = []
        @el = @tpl.xml

    # parser event handler

    onopentagname: (name) =>
        @parents.unshift(@el)
        @el = @parents[0].tag(name)

    ontext: (text) =>
        @el.text?(text)

    onattribute: (key, value) =>
        @el.attr?(key, value)

    onclosetag: (name) =>
        @el.end()
        @el = @parents.shift()

    onerror: (err) =>
        @tpl.emit('error', err)

    onend: () =>
        @tpl.end()
        @tpl = @el = @parents = null



parse = (stream, opts) ->
    return new Parser(stream, opts).tpl

# exports

parse.Parser = Parser
module.exports = parse


