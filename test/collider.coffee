Collider = require '../lib/collider'
ADT = require '../lib/adt'
Bounds = ADT.Bounds

Collidable = Collider.Collidable

describe 'Collidable', ->
  it 'should construct correctly', ->
    a = new Collidable
      layer: 'a'
      layersToCollide: ['a']
      bounds: new Bounds
        radius: 10
    a.layer.should.equal 'a'
    a.layersToCollide[0].should.equal 'a'
    a.bounds.radius.should.equal 10

describe 'Collider', ->
  it 'should add/remove correctly', ->
    a = new Collidable
      layer: 'a'
      layersToCollide: ['a']
      bounds: new Bounds
        radius: 10
    b = new Collidable
      layer: 'b'
      layersToCollide: ['a']
      bounds: new Bounds
        radius: 10
    collider = new Collider.Collider
    collider.add(a)
    collider.add(b)

    collider.objects.a[0].should.equal a
    collider.objects.b[0].should.equal b

    collider.remove(a)
    collider.remove(b)    

    collider.objects.a.length.should.equal 0
    collider.objects.b.length.should.equal 0
  it 'should collide correctly', ->
    class ColliderTracker extends Collider.Collider
      collideObjects: (o1, o2)->
        return true

    a = new Collidable
      layer: 'a'
      layersToCollide: ['a']
      bounds: new Bounds
        radius: 10
    a.position =
      x: 0
      y: 0
    b = new Collidable
      layer: 'b'
      layersToCollide: ['a']
      bounds: new Bounds
        radius: 10
    b.position =
      x: 0
      y: 0
    c = new Collidable
      layer: 'c'
      layersToCollide: ['a', 'b']
      bounds: new Bounds
        radius: 10
    c.position =
      x: 0
      y: 0

    collider = new ColliderTracker

    collider.add(a)
    collider.add(b)
    collider.add(c)

    collisions = collider.collide()
    
    #does not collide by itself
    #b collides with a

    collisions.length.should.equal 3
    collisions[0].object1.should.equal b
    collisions[0].object2.should.equal a
    collisions[1].object1.should.equal c
    collisions[1].object2.should.equal a
    collisions[2].object1.should.equal c
    collisions[2].object2.should.equal b