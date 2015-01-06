
MessageCreator = require "./MessageCreator"
_ = require "lodash"
Equipment = require "../item/Equipment"

teleports = require "../../config/teleports.json"

class GMCommands
  constructor: (@game) ->

  teleportLocation: (player, locationTitle) ->
    location = @lookupLocation locationTitle
    @teleport player, location.map, location.x, location.y, location.formalName

  teleport: (player, map, x, y, title = null) ->
    return if not player
    player.map = map
    player.x = x
    player.y = y

    text = title ? "#{map} - #{x},#{y}"

    @game.teleport player, map, x, y, "#{player.name} got whisked away to #{text}."

    playerTile = player.getTileAt()
    player.handleTile playerTile
    player.checkShop()

  massTeleportLocation: (locationTitle) ->
    location = @lookupLocation locationTitle
    @massTeleport location.map, location.x, location.y, location.formalName

  massTeleport: (map, x, y, title = null) ->
    _.each @game.playerManager.players, (player) =>
      @teleport player, map, x, y, title

  lookupLocation: (name) ->
    @locations[name]

  createItemFor: (player, type, itemParams) ->

    params = @game.componentDatabase.parseItemString itemParams, type, yes
    item = new Equipment params
    item.itemClass = 'custom'

    player.forceIntoOverflow item

  arrangeBattle: (playerList) ->
    teams = []
    for team in playerList
      newTeam = []
      for playerName in team
        newTeam.push @game.playerManager.getPlayerByName playerName
      teams.push newTeam
    @game.arrangeBattle teams

  initializeCustomData: ->
    require('git-clone') 'https://github.com/IdleLands/Custom-Assets', "#{__dirname}/../../assets/custom", ->

  updateCustomData: (cb = ->) ->
    require("git-pull") "#{__dirname}/../../assets/custom", cb

  setModeratorStatus: (identifier, status) ->
    player = @game.playerManager.getPlayerById identifier
    player?.isContentModerator = status

  locations: _.extend {},
    teleports.towns,
    teleports.bosses,
    teleports.dungeons,
    teleports.trainers,
    teleports.other

module.exports = exports = GMCommands