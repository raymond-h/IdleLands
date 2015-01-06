
_ = require "lodash"

class Map
  gidMap:
    1: "StairsDown"
    2: "StairsUp"
    3: "BrickWall"
    4: "Grass"
    5: "Water"
    6: "Lava"
    7: "Tile"
    8: "Ice"
    9: "Forest"
    10: "Sand"
    11: "Swamp"
    12: "BlueNPC"
    13: "RedNPC"
    14: "GreenNPC"
    15: "QuestionMark"
    16: "Tree"
    17: "Mountain"
    18: "Door"
    19: "Dirt"
    20: "FighterTrainer"
    21: "MageTrainer"
    22: "ClericTrainer"
    23: "JesterTrainer"
    24: "RogueTrainer"
    25: "GeneralistTrainer"
    26: "Boss"
    27: "Chest"
    28: "PurpleTeleport"
    29: "RedTeleport"
    30: "YellowTeleport"
    31: "GreenTeleport"
    32: "BlueTeleport"
    33: "Cloud"
    34: "Wood"
    35: "Hole"
    36: "Gravel"

  blockers: [16, 17, 3, 33]
  interactables: [1, 2, 12, 13, 14, 15, 18]

  constructor: (path) ->
    @map = require path

    @tileHeight = @map.tileheight
    @tileWidth = @map.tilewidth

    @height = @map.height
    @width = @map.width

    @name = @map.properties.name

    @loadRegions()

  loadRegions: ->
    @regionMap = []

    return if not @map.layers[3]

    _.each @map.layers[3].objects, (region) =>
      startX = region.x / 16
      startY = region.y / 16
      width = region.width / 16
      height = region.height / 16

      for x in [startX...(startX+width)]
        for y in [startY...(startY+height)]
          @regionMap[(y*@width)+x] = region.name

  getTile: (x, y) ->

    #layers[0] will always be the terrain
    #layers[1] will always be the blocking tiles
    #layers[2] will always be the interactable stuff
    #layers[3] will always be map regions, where applicable
    tilePosition = (y*@width) + x
    {
      terrain: @gidMap[@map.layers[0].data[tilePosition]]
      blocked: @map.layers[1].data[tilePosition] in @blockers
      blocker: @gidMap[@map.layers[1].data[tilePosition]]
      region: @regionMap[tilePosition] or 'Wilderness'
      object: _.findWhere @map.layers[2].objects, {x: @tileWidth*x, y: @tileHeight*(y+1)}
    }

  getFirstTile: (predicate) ->
    {
    object: _.findWhere @map.layers[2].objects, predicate
    }

module.exports = exports = Map