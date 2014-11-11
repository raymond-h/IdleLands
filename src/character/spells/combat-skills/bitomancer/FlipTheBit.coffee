
Spell = require "../../../base/Spell"

class FlipTheBit extends Spell
  name: "Flip the Bit"
  @element = FlipTheBit::element = Spell::Element.physical
  @stat = FlipTheBit::stat = "special"
  @tiers = FlipTheBit::tiers = [
    {name: "Flip the Bit", spellPower: 1, cost: 450, class: "Bitomancer", level: 30}
    {name: "Flip the Bit", spellPower: 1, cost: 1000, class: "Bitomancer", level: 50}
    {name: "Flip the Bit", spellPower: 1, cost: 2000, class: "Bitomancer", level: 70}
  ]

  determineTargets: ->
    @targetSomeEnemies size: 1

  cast: (player) ->
    storedHp = player.hp.getValue()
    player.hp.set player.mp.getValue()
    player.mp.set storedHp
    message = "%casterName uses %spellName on %targetName. %targetName's HP and MP are switched!"
    @broadcast player, message

  constructor: (@game, @caster) ->
    super @game, @caster
    @bindings =
      doSpellCast: @cast

module.exports = exports = FlipTheBit