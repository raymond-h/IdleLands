
Event = require "../Event"

`/**
 * This event handles both the blessGold and forsakeGold aliases.
 *
 * @name Gold
 * @category Player
 * @package Events
 */`
class GoldEvent extends Event
  go: ->
    if not @event.remark
      @game.errorHandler.captureException (new Error "GOLD EVENT FAILURE"), extra: @event
      return

    boost = @player.calcGoldGain @calcGoldEventGain @event.type, @player

    extra =
      gold: Math.abs boost
      realGold: boost

    @player.gainGold boost

    @player.emit "event.#{@event.type}", @player, extra

    message = @event.remark + " [%realGold gold]"

    @game.eventHandler.broadcastEvent {message: message, player: @player, extra: extra, type: 'gold'}

module.exports = exports = GoldEvent