FLOOR = Math.floor
CEIL = Math.ceil
MAX = Math.max

class SpatialHash
  lookup: null
  width: 0
  height: 0
  pixelWidth: 0
  pixelHeight: 0
  constructor: (options)->
    if options
      @width = options.width if options.width
      @height = options.height if options.height
      @pixelWidth = options.pixelWidth if options.pixelWidth
      @pixelHeight = options.pixelHeight if options.pixelHeight
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
    pixelWidth = @pixelWidth
    pixelHeight = @pixelHeight

    minX = position.x - bounds.width / 2
    minY = position.y - bounds.height / 2
    maxX = position.x + bounds.width / 2 
    maxY = position.y + bounds.height / 2
    minX = FLOOR(minX/pixelWidth)*pixelWidth + 1 if minX % pixelWidth != 0
    minX = MAX(minX, 0)
    maxX = CEIL(maxX/pixelWidth)*pixelWidth - 1  if maxX % pixelHeight != 0
    minY = FLOOR(minY/pixelHeight)*pixelHeight + 1 if minY % pixelHeight != 0
    minY = MAX(minX, 0)
    maxY = CEIL(maxY/pixelHeight)*pixelHeight - 1  if maxY % pixelHeight != 0

    for x in [minX..maxX] by pixelWidth
      if x >= minX
        for y in [minY..maxY] by pixelHeight
          if y >= minY
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
