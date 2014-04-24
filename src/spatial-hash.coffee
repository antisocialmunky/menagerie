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
  add: (object, layer = 'default')->
    position = object.position
    bounds = object.bounds
    if position?
      if bounds?
        @addBounds(object, layer)
      else
        hash = @hash(position.x, position.y)
        @addByHash(object, hash, layer)
  addByHash: (object, hash, layer)->
    if !(buckets = @lookup[hash])
      buckets = @lookup[hash] = {}
    if !(bucket = buckets[layer])
      bucket = buckets[layer] = []
    bucket.push(object)
  addBounds: (object, layer)->
    position = object.position
    bounds = object.bounds
    maxX = position.x+bounds.width
    maxY = position.y+bounds.height
    pixelWidth = @pixelWidth
    pixelHeight = @pixelHeight

    for x in [position.x..FLOOR(maxX/pixelWidth)*pixelWidth] by pixelWidth
      if x >= position.x
        for y in [position.y..FLOOR(maxY/pixelHeight)*pixelHeight] by pixelHeight
          if y >= position.y
            hash = @hash(x, y)
            @addByHash(object, hash, layer)
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