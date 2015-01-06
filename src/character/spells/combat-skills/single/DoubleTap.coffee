
Spell = require "../../../base/Spell"

class DoubleTap extends Spell
  name: "double tap"
  @element = DoubleTap::element = Spell::Element.physical
  @tiers = DoubleTap::tiers = [
    `/**
      * This skill makes the caster attack twice.
      *
      * @name double tap
      * @requirement {class} Fighter
      * @requirement {mp} 450
      * @requirement {level} 1
      * @targets {enemy} 1
      * @element physical
      * @category Fighter
      * @package Spells
    */`
    {name: "double tap", spellPower: 1, cost: 450, class: "Fighter", level: 1}
    `/**
      * This skill makes the caster attack thrice.
      *
      * @name triple tap
      * @requirement {class} Fighter
      * @requirement {mp} 600
      * @requirement {level} 51
      * @targets {enemy} 1
      * @element physical
      * @category Fighter
      * @package Spells
    */`
    {name: "triple tap", spellPower: 2, cost: 600, class: "Fighter", level: 51}
    `/**
     * This skill makes the caster attack twice.
     *
     * @name double tap
     * @requirement {class} MagicalMonster
     * @requirement {mp} 1000
     * @requirement {level} 25
     * @targets {enemy} 1
     * @element physical
     * @prerequisite {collectible} Fighter's Manual
     * @category MagicalMonster
     * @package Spells
     */`
    {name: "double tap", spellPower: 1, cost: 1000, class: "MagicalMonster", level: 25, collectibles: ["Fighter's Manual"]}
  ]

  cast: (player) ->
    @broadcast player,"%casterName is going %spellName crazy on %targetName!"
    @caster.party.currentBattle.doPhysicalAttack @caster, player
    if player.hp.atMin()
      @broadcast player,"%casterName needs not hit %targetName again!"
      return

    @caster.party.currentBattle.doPhysicalAttack @caster, player

    if @spellPower > 1
      if player.hp.atMin()
        @broadcast player,"%casterName needs not hit %targetName again!"
        return
      @caster.party.currentBattle.doPhysicalAttack @caster, player

  constructor: (@game, @caster) ->
    super @game, @caster
    @bindings =
      doSpellCast: @cast

module.exports = exports = DoubleTap