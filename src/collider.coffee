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
    spatialHash = new SpatialHash(@)

    for layer, objects of @objects
      for object1 in objects
        spatialHash.add(object1, layer)
        layersToCollide = object1.layersToCollide
        for layerToCollide in layersToCollide
          objectsToCollide = @objects[layerToCollide]
          if objectsToCollide?
            for object2 in objectsToCollide
              if object1 != object2 && @collideObjects(object1, object2)
                collisions.push(object1: object1, object2: object2)
    return collisions
  collideObjects: (object1, object2)->

module.exports = 
  Collidable: Collidable
  Collider: Collider