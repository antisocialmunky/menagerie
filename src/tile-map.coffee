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
  remove: (element)->
    if element._elementId? && element._tile == @
      delete @elements[element._elementId]
      delete element._tile

class TileMap
  pixelWidth: 0
  pixelHeight: 0
  tileWidth: 0
  tileHeight: 0
  map: null
  TileClass: Tile
  constructor: (options)->
    @pixelWidth = options.pixelWidth || @pixelWidth
    @pixelHeight = options.pixelHeight || @pixelHeight
    @tileWidth = options.tileWidth || @tileWidth
    @tileHeight = options.tileHeight || @tileHeight

    @map = {}
  add: (element)->
    position = element.position
    if position?
      if position.x >= 0 && position.x < @pixelWidth * @tileWidth && position.y >= 0 && position.y < @pixelHeight * @tileHeight
        hash = @hash(position)
        tile = @map[hash]
        if !tile?
          tile = @map[hash] = new @TileClass(FLOOR(position.x / @pixelWidth), FLOOR(position.y / @pixelHeight))
        tile.add(element)
        return true
    return false
  remove: (element)->
    if element._tile?
      element._tile.remove(element)
      return true
    return false
  hash: (position)->
    tileX = FLOOR(position.x / @pixelWidth)
    tileY = FLOOR(position.y / @pixelHeight)
    return tileY * @tileWidth + tileX
    #if position?

module.exports = TileMap