FLOOR = Math.floor

elementId = 0
class Tile
  elements: null
  x: 0
  y: 0
  constructor: (x, y)->
    @x = x || @x
    @y = y || @y
    @elements = {}
  add: (element)->
    id = element._elementId
    if !id?
      id = element._elementId = elementId++
    else if element._tile?
      element._tile.remove(element)
    @elements[id] = element
    element._tile = @
  filter: (filter)->
    elements = []
    for id, element of @elements
      elements.push(element) if filter(element)
    return elements
  remove: (element)->
    if element._elementId? && element._tile == @
      delete @elements[element._elementId]
      delete element._tile

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
  add: (element)->
    position = element.position
    if position?
      if @bounds(position.x, position.y)
        hash = @hash(position.x, position.y)
        tile = @map[hash]
        if !tile?
          tile = @map[hash] = new @TileClass(FLOOR(position.x / @pixelWidth), FLOOR(position.y / @pixelHeight))
        tile.add(element)
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
  remove: (element)->
    if element._tile?
      element._tile.remove(element)
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