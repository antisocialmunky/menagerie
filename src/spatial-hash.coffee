FLOOR = Math.floor
CEIL = Math.ceil

class SpatialHash
  lookup: null
  width: 0
  height: 0
  pixelWidth: 0
  pixelHeight: 0
  maxHash: 0
  constructor: (options)->
    if options
      @width = options.width if options.width
      @height = options.height if options.height
      @pixelWidth = options.pixelWidth if options.pixelWidth
      @pixelHeight = options.pixelHeight if options.pixelHeight
      @maxHash = @width * @height / @pixelWidth / @pixelHeight
    @lookup = {}
  add: (object)->
    if object.x? && object.y?
      if object.width? && object.height?
        @addRect(object)
      else
        hash = @hash(object.x, object.y)
        @addByHash(object, hash)
  addByHash: (object, hash)->
      if !(bucket = @lookup[hash])
        bucket = @lookup[hash] = []
      bucket.push(object)
  addRect: (object)->
    maxX = object.x+object.width
    maxY = object.y+object.height
    pixelWidth = @pixelWidth
    pixelHeight = @pixelHeight

    for x in [object.x..CEIL(maxX/pixelWidth)*pixelWidth] by pixelWidth
      if x >= object.x
        for y in [object.y..CEIL(maxY/pixelHeight)*pixelHeight] by pixelHeight
          if y >= object.y
            hash = @hash(x, y)
            @addByHash(object, hash)
  get: (hash)->
    return @lookup[hash]
  hashRect: (sX, sY, width, height)->
    hashes = []
    maxX = sX+width
    maxY = sY+height
    pixelWidth = @pixelWidth
    pixelHeight = @pixelHeight
    for x in [sX..CEIL(maxX/pixelWidth)*pixelWidth] by pixelWidth
      if x >= sX
        for y in [sY..CEIL(maxY/pixelHeight)*pixelHeight] by pixelHeight
          if y >= sY
            hashes.push(@hash(x, y))
    return hashes
  filterUsingRect: (rect) ->
    hashes = @hashRect(rect.x, rect.y, rect.width, rect.height)
    objects = []
    for hash in hashes
      gets = @get(hash)
      objects = objects.concat(gets) if gets?
    return objects
  hash: (x, y)->
    return FLOOR(x / @pixelWidth) + FLOOR(y / @pixelHeight) * @width / @pixelWidth
  clear: ()->
    @lookup = {}

module.exports = SpatialHash