FLOOR = Math.floor

objectId = 0
class Tile
  objects: null
  x: 0
  y: 0
  constructor: (x, y)->
    @x = x || @x
    @y = y || @y
    @objects = {}
  add: (object)->
    id = object._objectId
    if !id?
      id = object._objectId = objectId++
    else if object._tile?
      object._tile.remove(object)
    @objects[id] = object
    object._tile = @
  filter: (filter)->
    objects = []
    for id, object of @objects
      objects.push(object) if filter(object)
    return objects
  remove: (object)->
    if object._objectId? && object._tile == @
      delete @objects[object._objectId]
      delete object._tile

class TileMap
  pixelWidth: 0
  pixelHeight: 0
  tileWidth: 0
  tileHeight: 0
  totalPixelWidth: 0
  totalPixelHeight: 0
  map: null
  TileClass: Tile
  constructor: (options)->
    @pixelWidth = options.pixelWidth || @pixelWidth
    @pixelHeight = options.pixelHeight || @pixelHeight
    @tileWidth = options.tileWidth || @tileWidth
    @tileHeight = options.tileHeight || @tileHeight

    @totalPixelWidth = @pixelWidth * @tileWidth
    @totalPixelHeight = @pixelHeight * @tileHeight

    @map = {}
  add: (object)->
    position = object.position
    if position?
      if @bounds(position.x, position.y)
        hash = @hash(position.x, position.y)
        tile = @map[hash]
        if !tile?
          tile = @map[hash] = new @TileClass(FLOOR(position.x / @pixelWidth), FLOOR(position.y / @pixelHeight))
        tile.add(object)
        return true
    return false
  get: (x, y)->
    if @bounds(x, y)
      return @map[@hash(x, y)]
  filter: (filter, x, y)->
    if @bounds(x, y)
      tile = @map[@hash(x, y)]
      if tile?
        return tile.filter(filter)
    return []
  remove: (object)->
    if object._tile?
      object._tile.remove(object)
      return true
    return false
  bounds: (x, y)->
    return x >= 0 && x < @totalPixelWidth && y >= 0 && y < @totalPixelHeight
  hash: (x, y)->
    tileX = FLOOR(x / @pixelWidth)
    tileY = FLOOR(y / @pixelHeight)
    return tileY * @tileWidth + tileX
    #if position?

module.exports = TileMap