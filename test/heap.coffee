Heap = require '../lib/heap'
should = require('chai').should()

describe 'Heap', ->
  it 'should construct correctly', ->
    heap = new Heap()
    heap.nodes.length.should.equal 0
    heap.length.should.equal 0

  it 'should insert, pop correctly', ->
    heap = new Heap()
    a = {}
    b = {}
    c = {}
    heap.insert(a, 100)
    heap.insert(b, 10)
    heap.insert(c, 20)
    heap.length.should.equal 3

    n1 = heap.pop()
    n2 = heap.pop()
    n3 = heap.pop()
    heap.length.should.equal 0

    n1.should.equal b
    n2.should.equal c
    n3.should.equal a

  it 'should insert, update, pop correctly', ->
    heap = new Heap()
    a = {}
    b = {}
    c = {}

    heap.insert(a, 100)
    heap.insert(b, 10)
    heap.insert(c, 20)
    heap.length.should.equal 3

    heap.update(b, 200)
    heap.length.should.equal 3

    n1 = heap.pop()
    n2 = heap.pop()
    n3 = heap.pop()
    heap.length.should.equal 0

    n1.should.equal c
    n2.should.equal a
    n3.should.equal b