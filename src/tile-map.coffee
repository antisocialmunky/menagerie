Vector2D = require './vector2d'
PriorityQueue = require 'binaryheap'

FLOOR = Math.floor
SQRT2 = Math.sqrt(2)

objectId = 0
class Tile
  id: 0
  objects: null
  position: new Vector2D
  center: null
  map: null
  top: null
  down: null
  left: null
  right: null
  constructor: (options)->
    @id = options.id
    @position = options.position || @position
    @map = options.map
    @center = new Vector2D
      x: @position.x + @map.pixelWidth / 2
      y: @position.y + @map.pixelHeight / 2
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
  hashMax: 0
  TileClass: Tile
  constructor: (options)->
    @pixelWidth = options.pixelWidth || @pixelWidth
    @pixelHeight = options.pixelHeight || @pixelHeight
    @tileWidth = options.tileWidth || @tileWidth
    @tileHeight = options.tileHeight || @tileHeight

    @totalPixelWidth = @pixelWidth * @tileWidth
    @totalPixelHeight = @pixelHeight * @tileHeight

    @map = {}
    @hashMax = @tileHeight * @tileWidth - 1
    for x in [0...@totalPixelWidth-1] by @pixelWidth
      for y in [0...@totalPixelHeight-1] by @pixelHeight
        hash = @hash(x, y)
        tile = @map[hash] = new @TileClass
          id: hash
          position: new Vector2D
            x: x 
            y: y 
          map: @
        left = @get(x - 1, y)
        top = @get(x, y - 1)
        if left? 
          tile.left = left
          left.right = tile
        if top?
          tile.top = top
          top.bottom = tile

  add: (object)->
    position = object.position
    if position?
      if @bounds(position.x, position.y)
        hash = @hash(position.x, position.y)
        tile = @map[hash]
        tile.add(object)
        return true
    return false

  get: (x, y)->
    if @bounds(x, y)
      return @map[@hash(x, y)]

  filter: (filter, x, y)->
    if @bounds(x, y)
      tile = @map[@hash(x, y)]
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
    hash = tileY * @tileWidth + tileX
    if hash < 0 || hash > @hashMax
      return false 
    return hash

TileMap.AStar = (startTile, endTile, cost)-> 
  statuses = {}

  lastTile = null

  startStatus = statuses[startTile.id] = 
    tile: startTile
    parent: lastTile
    closed: false
    cost: 0
    heuristicCost: 0
    predictedCost: 0
    opened: true

  openList = new PriorityQueue(true)
  openList.insert(startStatus, 0)

  while openList.length > 0
    status = openList.pop()
    status.closed = true
    tile = status.tile

    if tile == endTile
      waypoints = []
      while tile != startTile
        waypoints.push(tile)
        tile = statuses[tile.id].parent
      return waypoints.reverse

    neighbors = []
    neighbors.push(tile.top) if tile.top?
    neighbors.push(tile.left) if tile.left?
    neighbors.push(tile.bottom) if tile.bottom?
    neighbors.push(tile.right) if tile.right?

    for neighbor in neighbors
      neighborStatus = statuses[neighbor.id]
      if !neighborStatus? 
        neighborStatus = statuses[neighbor.id] = 
          tile: neighbor
          parent: tile
          opened: false
      if !neighborStatus.closed
        coef = 1
        moveCost = coef * cost(neighbor)

        newCost = status.cost + moveCost

        if !neighborStatus.opened || newCost < neighborStatus.cost
          heuristicCost = neighbor.position.sub(neighbor.position).length()
          predictedCost = newCost + heuristicCost

          neighborStatus.cost = newCost
          neighborStatus.heuristicCost = heuristicCost
          neighborStatus.predictedCost = predictedCost

          if !neighborStatus.opened
            neighborStatus.opened = true
          else
            openList.remove(neighborStatus)
          openList.insert(neighborStatus, predictedCost)
  return []

module.exports = TileMap