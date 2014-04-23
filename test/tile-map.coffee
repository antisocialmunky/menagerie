should = require('chai').should()
TileMap = require '../lib/tile-map'

describe 'TileMap', ->
  tileMap = new TileMap(
    pixelWidth: 10
    pixelHeight: 10
    tileWidth: 100
    tileHeight: 100)

  it 'should construct correctly', ->
    tileMap.pixelWidth.should.equal 10
    tileMap.pixelHeight.should.equal 10
    tileMap.tileWidth.should.equal 100
    tileMap.tileHeight.should.equal 100

  it 'should add correctly', ->
    a =
      position:
        x: 10
        y: 10
    b =
      position:
        x: 61
        y: 9
    
    tileMap.add(a).should.be.true
    tileMap.add(b).should.be.true

    a._elementId.should.equal 0
    a._tile.should.equal tileMap.map[101]
    b._elementId.should.equal 1
    b._tile.should.equal tileMap.map[6]
    a._tile.should.not.equal b._tile

    tileMap.remove(a).should.be.true
    tileMap.remove(b).should.be.true

    a._elementId.should.equal 0
    should.not.exist a._tile
    b._elementId.should.equal 1
    should.not.exist b._tile

    should.not.exist tileMap.map[101].elements[0]
    should.not.exist tileMap.map[6].elements[1]

  it 'should not add out of bounds', ->
    a =
      position:
        x: 10000
        y: 10000
    b =
      position:
        x: -1
        y: -1
    tileMap.add(a).should.be.false
    tileMap.add(b).should.be.false

    should.not.exist a._elementId
    should.not.exist a._tile
    should.not.exist b._elementId
    should.not.exist b._tile

    # should not break
    tileMap.remove(a).should.be.false
    tileMap.remove(b).should.be.false