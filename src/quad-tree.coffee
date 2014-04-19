Rectangle = require './rectangle'

QuadTree = {}

i = 0
UpperLeft = QuadTree.UpperLeft = i++
BottomLeft = QuadTree.BottomLeft = i++
BottomRight = QuadTree.BottomRight = i++
UpperRight = QuadTree.UpperRight = i++

QuadTreeNode = class QuadTree.QuadTreeNode extends Rectangle
  isLeaf: true
  children: null
  depth: 0
  maxDepth: 0
  maxChildren: 1000
  #state
  subdividingMode: false
  constructor: (options) -> 
    super(options)
    if options
      @depth = parseInt(options.depth, 10) if options.depth > 0
      @maxChildren = parseInt(options.maxChildren, 10) if options.maxChildren > 0
      @maxDepth = parseInt(options.maxDepth, 10) if options.maxDepth > 0
    @children = []

  addChild: (object) ->
    if @isLeaf
      if @children.length < @maxChildren || @depth >= @maxDepth
        if object._quad
          object._quad.removeChild(object)
        object._quadIndex = @children.length
        @children.push(object)
        object._quad = @
      else
        quads = []

        @isLeaf = false

        halfWidth = @width/2
        halfHeight = @height/2

        options = 
          maxChildren: @maxChildren
          maxDepth: @maxDepth
          depth: @depth + 1
          x: @x
          y: @y
          width: halfWidth
          height: halfHeight

        quads[UpperLeft] = new QuadTreeNode(options)
        options.y += halfHeight
        quads[BottomLeft] = new QuadTreeNode(options)
        options.x += halfWidth
        quads[BottomRight] = new QuadTreeNode(options)
        options.y -= halfHeight
        quads[UpperRight] = new QuadTreeNode(options)

        children = @children.slice(0);
        
        @subdividingMode = true;

        children.push(object)
        for child in children
          if quads[UpperLeft].containedInsideRect(child)
            quads[UpperLeft].addChild(child)
          else if quads[BottomLeft].containedInsideRect(child)
            quads[BottomLeft].addChild(child)
          else if quads[BottomRight].containedInsideRect(child)
            quads[BottomRight].addChild(child)
          else if quads[UpperRight].containedInsideRect(child)
            quads[UpperRight].addChild(child)

        @subdividingMode = false

        @children = quads

  removeChild: (object)->
    if @isLeaf
      if object._quad == @
        i = object._quadIndex
        @children.splice(i, 1)
        for i in [i...@children.length]
          @children.quadIndex--;
        object._quad = null
        object._quadIndex = -1
    else if !@subdividingMode
      if @children[UpperLeft].containedInsideRect(object)
        @children[UpperLeft].removeChild(object)
      else if @children[BottomLeft].containedInsideRect(object)
        @children[BottomLeft].removeChild(object)
      else if @children[BottomRight].containedInsideRect(object)
        @children[BottomRight].removeChild(object)
      else if @children[UpperRight].containedInsideRect(object)
        @children[UpperRight].removeChild(object)

      #simple unsubdivide
      if @children[UpperLeft].children.length == 0 &&
      @children[BottomLeft].children.length == 0 &&
      @children[BottomRight].children.length == 0 &&
      @children[UpperRight].children.length == 0
        @children = []
        @isLeaf = true

  containedInsideRect: (object)->
    x = object.x
    y = object.y
    myX = @x
    myY = @y
    return x >= myX && x < @width + myX && y >= myY && y < @height + myY

  filterUsingRect: (rect)->
    return @filterUsingRectHelper(rect, [])

  filterUsingRectHelper: (rect, ret)->
    x = rect.x
    y = rect.y
    x2 = x + rect.width
    y2 = y + rect.height
    myX = @x
    myY = @y
    myX2 = myX + @width
    myY2 = myY + @height

    if y2 >= myY && y < myY2 && x2 >= myX && x < myX2
      if @isLeaf
        ret.push(child) for child in @children
      else
        @children[UpperLeft].filterUsingRectHelper(rect, ret)
        @children[BottomLeft].filterUsingRectHelper(rect, ret)
        @children[BottomRight].filterUsingRectHelper(rect, ret)
        @children[UpperRight].filterUsingRectHelper(rect, ret)

    return ret

module.exports = QuadTree