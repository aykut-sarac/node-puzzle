fs = require 'fs'
readline = require 'readline'

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  readStream = fs.createReadStream "#{__dirname}/../data/geo.txt"
  lineReader = readline.createInterface(readStream)

  counter = 0
  #Read Each line on demand
  lineReader.on('line', (dataChunk) ->
    #Check dataline has countryCode then split to array, can be tricky
    if dataChunk.includes(countryCode)
      data = dataChunk.split '\n'
      line = data[0].split '\t'
      #if Country code match, add it to counter
      if line[3] == countryCode then counter += +line[1] - +line[0]
  ).on('close', () ->
    cb null, counter
  )