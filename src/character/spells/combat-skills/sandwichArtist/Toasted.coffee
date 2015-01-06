
Spell = require "../../../base/Spell"
SandwichBuff = require "./SandwichBuff"

class Toasted extends Spell
  name: "Toasted"
  @element = Toasted::element = Spell::Element.fire
  @tiers = Toasted::tiers = [
    `/**
      * This skill burns up to 2 opponents. It also feeds them a sandwich, but it's most likely burnt to a crisp.
      *
      * @name Toasted
      * @requirement {class} SandwichArtist
      * @requirement {mp} 50
      * @requirement {level} 1
      * @element fire
      * @targets {enemy} 1-2
      * @minDamage dex/6
      * @minDamage dex/4
      * @category SandwichArtist
      * @package Spells
    */`
    {name: "Toasted", spellPower: 1, cost: 50, class: "SandwichArtist", level: 1}
  ]
  
  calcDamage: ->
    minStat = (@caster.calc.stat 'dex')/6
    maxStat = (@caster.calc.stat 'dex')/4
    super() + @minMax minStat, maxStat

  determineTargets: ->
    @targetSomeEnemies size: @chance.integer({min: 1, max: 2}), guaranteeSize: yes

  cast: (player) ->
    buff = @game.spellManager.modifySpell new SandwichBuff @game, @caster
    buff.prepareCast player

    @name = buff.name
    damage = @calcDamage()
    message = "%casterName made %targetName a %spellName."
    @broadcast player, message
    if player.calculateYesPercent?
      yesno = @chance.bool {likelihood: player.calculateYesPercent()}
    else
      yesno = @chance.bool {likelihood: 50}
    if yesno
      message = "%targetName wanted the %spellName toasted. %targetName is burned for %damage damage!"
      @doDamageTo player, damage, message
      @name = "toasted #{@name}"
    else
      message = "%targetName didn't want the %spellName toasted."
      @broadcast player, message
    buff.name = @name

  constructor: (@game, @caster) ->
    super @game, @caster
    @bindings =
      doSpellCast: @cast

module.exports = exports = Toasted