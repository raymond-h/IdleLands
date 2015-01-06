
_ = require "lodash"
Equipment = require "../item/Equipment"
Generator = require "./Generator"
Chance = require "chance"
chance = new Chance()

class EquipmentGenerator extends Generator
  constructor: (@game) ->

  generateItem: (type = null, generatorBonus = 0) ->
    itemList = @game.componentDatabase.itemStats
    type = _.sample @types if not type

    return null if not itemList[type]

    baseItem = _.sample itemList[type]

    item = new Equipment baseItem

    @addPropertiesToItem item, generatorBonus

    item.type = type

    item.itemClass = @getItemClass item
    @cleanUpItem item

  addPropertiesToItem: (item, generatorBonus = 0) ->
    itemList = @game.componentDatabase.itemStats

    if chance.integer({min: 0, max: 4}) is 1
      @mergePropInto item, _.sample itemList['prefix']
      (@mergePropInto item,  _.sample itemList['prefix']) until chance.integer({min: 0, max: 15**(i = (i+1) or 0)}) > 1+generatorBonus

    (@mergePropInto item,  _.sample itemList['prefix-special']) if chance.integer({min: 0, max: 120}) <= 0+generatorBonus

    (@mergePropInto item,  _.sample itemList['suffix']) if chance.integer({min: 0, max: 85}) <= 0+generatorBonus

  cleanUpItem: (item) ->
    (if _.isNaN val then item[attr] = true) for attr,val of item
    item

  getItemClass: (item) ->
    itemClass = "basic"
    itemClass = "pro" if item.name.toLowerCase() isnt item.name
    itemClass = "idle" if item.name.toLowerCase().indexOf("idle") isnt -1 or item.name.toLowerCase().indexOf("idling") isnt -1
    itemClass = "godly" if item.score() > 7500

    itemClass

  generateItemAtScore: (targetScore, tolerance = 0.15, bonus = 0) ->
    testItem = (item) ->
      baseScore = item.score()
      flux = baseScore * tolerance
      baseScore-flux <= targetScore <= baseScore+flux

    item = @cleanUpItem @generateItem null, bonus
    item = @cleanUpItem @generateItem null, bonus while not testItem item

    item


module.exports = exports = EquipmentGenerator
