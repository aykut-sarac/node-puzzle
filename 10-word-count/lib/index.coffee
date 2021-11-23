through2 = require 'through2'

module.exports = ->
  words = 0
  lines = 0
  bytes = 0
  chars = 0

  transform = (chunk, encoding, cb) ->

    if !chunk
      return cb()
    
    bytes = Buffer.byteLength(chunk, encoding)
    chars = chunk.length

    chunkArr = chunk.split('\n')
    lines = chunkArr.length

    for str in chunkArr
      # double quote check
      if str[0] == '"' && str[str.length-1] == '"'
        words++
        continue
      # camelCase check
      if str != str.toUpperCase()
        # first group ($1), add space ' ', second group ($2)
        str = str.replace(/([a-z])([A-Z])/g, '$1 $2')
             
      tokens = str.split(' ')
      
      words += tokens.length

    return cb() 
  
  flush = (cb) ->
    this.push {words, lines, bytes, chars}
    this.push null
    return cb()

  return through2.obj transform, flush
