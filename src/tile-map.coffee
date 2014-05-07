Vector2D = require './vector2d'
Heap = require './heap'

ABS = Math.abs
FLOOR = Math.floor
SQRT2 = Math.sqrt(2)

objectId = 0
class Tile
  id: 0
  objects: null
  bins: null
  objectFilterMap: null
  position: new Vector2D
  coords: new Vector2D
  center: null
  map: null
  top: null
  topLeft: null
  left: null
  bottomLeft: null
  bottom: null
  bottomRight: null
  right: null
  topRight: null
  length: 0
  constructor: (options)->
    @id = options.id
    @position = options.position || @position
    map = @map = options.map
    @center = new Vector2D
      x: @position.x + map.pixelWidth / 2
      y: @position.y + map.pixelHeight / 2
    @coords = @center.divideByScalar((map.pixelWidth + map.pixelHeight) / 2)
    @objects = {}
    @bins = {}
    @objectFilterMap = {}

  add: (object, bins)->
    id = object._objectId
    if !id?
      id = object._objectId = objectId++
    else if object._tile?
      object._tile.remove(object)
    @objects[id] = object
    object._tile = @
    @length++

    if bins?
      @objectFilterMap[id] = bins
      if bins instanceof Array
        for bin in bins
          @bins[bin] = (@bins[bin] + 1) || 1
      else
        @bins[bins] = (@bins[bins] + 1) || 1

  filter: (filter)->
    objects = []
    for id, object of @objects
      objects.push(object) if filter(object)
    return objects

  remove: (object)->
    if object._objectId? && object._tile == @
      id = object._objectId
      delete @objects[id]
      object._tile = null
      @length--

      bins = @objectFilterMap[id]
      if bins instanceof Array
        for bin in bins
          @bins[bin]--
      else
        @bins[bins]--

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
    pixelHeight = @pixelHeight = options.pixelHeight || @pixelHeight
    @tileWidth = options.tileWidth || @tileWidth
    @tileHeight = options.tileHeight || @tileHeight

    @totalPixelWidth = @pixelWidth * @tileWidth
    @totalPixelHeight = @pixelHeight * @tileHeight

    @map = {}
    @hashMax = @tileHeight * @tileWidth - 1
    for x in [0...@totalPixelWidth-1] by @pixelWidth
      for y in [0...@totalPixelHeight-1] by pixelHeight
        hash = @hash(x, y)
        tile = @map[hash] = new @TileClass
          id: hash
          position: new Vector2D
            x: x 
            y: y 
          map: @
        left = @get(x - 1, y)
        topLeft = @get(x - 1, y - 1)
        top = @get(x, y - 1)
        bottomLeft = @get(x - 1, y + pixelHeight)
        if left? 
          tile.left = left
          left.right = tile
        if topLeft?
          tile.topLeft = topLeft
          topLeft.bottomRight = tile
        if top?
          tile.top = top
          top.bottom = tile
        if bottomLeft?
          tile.bottomLeft = bottomLeft
          bottomLeft.topRight = tile

  add: (object, bins)->
    position = object.position
    if position?
      if @bounds(position.x, position.y)
        hash = @hash(position.x, position.y)
        tile = @map[hash]
        tile.add(object, bins)
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

Directions =
  Left: 0
  BottomLeft: 1
  Bottom: 2
  BottomRight: 3
  Right: 4
  TopRight: 5
  Top: 6
  TopLeft: 7
  All: 8

getNeighbors = (status)->
  tile = status.tile
  neighbors = []

  neighbors.push(tile.top) if tile.top?
  neighbors.push(tile.topLeft) if tile.topLeft?
  neighbors.push(tile.left) if tile.left?
  neighbors.push(tile.bottomLeft) if tile.bottomLeft?
  neighbors.push(tile.bottom) if tile.bottom?
  neighbors.push(tile.bottomRight) if tile.bottomRight?
  neighbors.push(tile.right) if tile.right?
  neighbors.push(tile.topRight) if tile.topRight?

  return neighbors

TileMap.AStar = (startTile, endTile, cost)-> 
  statuses = {}

  startStatus = statuses[startTile.id] = 
    tile: startTile
    parent: null
    closed: false
    cost: 0
    heuristicCost: 0
    predictedCost: 0
    direction: Directions.All
    opened: true

  openList = new Heap
  openList.insert(startStatus, 0)

  while openList.length > 0
    status = openList.pop()
    status.closed = true
    tile = status.tile

    if tile == endTile
      waypoints = []
      while tile != startTile
        waypoints.unshift(tile)
        tile = statuses[tile.id].parent
      return waypoints

    neighbors = getNeighbors(status)

    for neighbor in neighbors
      neighborStatus = statuses[neighbor.id]
      if !neighborStatus?
        neighborStatus = statuses[neighbor.id] = 
          tile: neighbor
          opened: false
      if !neighborStatus.closed
        coef = if neighbor.position.x != tile.position.x && neighbor.position.y != tile.position.y then SQRT2 else 1
        moveCost = cost(neighbor)
        
        if moveCost == false
          neighborStatus.closed = true
        else
          moveCost *= coef

          newCost = status.cost + moveCost
          heuristicVector = neighbor.coords.sub(endTile.coords)
          heuristicCost = ABS(heuristicVector.x) + ABS(heuristicVector.y)
          predictedCost = newCost + heuristicCost

          if !neighborStatus.opened || predictedCost < neighborStatus.predictedCost
            neighborStatus.parent = tile
            neighborStatus.cost = newCost
            neighborStatus.heuristicCost = heuristicCost
            neighborStatus.predictedCost = predictedCost

            if !neighborStatus.opened
              neighborStatus.opened = true
              openList.insert(neighborStatus, predictedCost)
            else
              openList.update(neighborStatus, predictedCost)
  return []

pathingId = 0
class TileMap.PathingQueue
  queue: null
  pathingMap: null
  algorithm: null
  constructor: (options)->
    @queue = []
    @pathingMap = {}
    @algorithm = options.algorithm
    @cost = options.cost
  schedule: (object, end, callback)->
    id = object._pathingId
    if !id?
      id = object._pathingId = pathingId++
    if !@pathingMap[id]
      context = [object, end, callback]
      @queue.push(context)
      @pathingMap[id] = true
  path: ()->
    if @queue.length > 0
      [object, end, callback] = @queue.shift()
      start = object.tile
      if start?
        @pathingMap[object._pathingId] = false
        callback(@algorithm(start, end, @cost))

module.exports = TileMap