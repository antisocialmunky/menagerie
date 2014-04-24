SpatialHash = require './spatial-hash'

class Collidable
  bounds: null
  layer: 'default'
  layersToCollide: []
  constructor: (options)->
    @bounds = options.bounds || new Bounds
    @layer = options.layer || @layer
    @layersToCollide = options.layersToCollide || []

class Collider
  objects: null
  pixelWidth: 128
  pixelHeight: 128
  width: 1280
  height: 768
  constructor: ()->
    @objects = {}
  add: (object)->
    layerName = object.layer
    if layerName? && object.layersToCollide? && object.bounds?
      layer = @objects[layerName]
      if !layer?
        layer = @objects[layerName] = []
      layer.push(object)
  remove: (object)->
    layerName = object.layer
    if layerName? && object.layersToCollide? && object.bounds?
      layer = @objects[layerName]
      if layer?
        i = layer.indexOf(object)
        if i >= 0
          layer.splice(i, 1)
  collide: ()->
    collisions = []
    partition = new SpatialHash(@)

    for layer, objects of @objects
      for object1 in objects
        partition.add(object1, layer)

    for hash, chunk of partition.lookup
      for layer, bucket1 of chunk
        for object1 in bucket1
          for layerToCollide in object1.layersToCollide
            bucket2 = chunk[layerToCollide]
            if bucket2
              for object2 in bucket2
                if object1 != object2 && @collideObjects(object1, object2)
                  collisions.push(object1: object1, object2: object2)
    return collisions
  collideObjects: (object1, object2)->

module.exports = 
  Collidable: Collidable
  Collider: Collider