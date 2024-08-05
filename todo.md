
# To-Do

* **Tuesday:** I want the rowing version finished, including solid reusable modules for the other modes.
* **Wednesday:** Finish all components to close the core loop of the castle version.
* **Tuesday:** Try all rules tweaks, different configurations, extra ideas.
* **Friday:** Once we know what's needed, create the visuals + sound fx + everything for it.
* **Saturday:** Rest day. (Possibly playtest.)
* **Sunday:** Do everything needed to be submit final version before going to bed.


## Rowing Game

* Rename scene to `main_river.tscn` or something.
* Create spawning function for stuff _on_ the track, and stuff on the _edge_
  * Use it to place random elements to pick up on the track.
  * Also create simple areas with a current. (Check current vector against track vector. Make sure it never goes back; or if it does, it's a much smaller range than the width at that point.)
  * Place decorations on the _edge_ to make it look much better. (Background should probably be lighter and also textured a bit.)
  * Perhaps place rocks or stuff on the track, using the same idea as currents to ensure they do not block the _entire path_. (Or maybe there are _moving/more dynamic_ obstacles on the river => re-use the MonsterSpawner for this!)
* Test different **rowing mechanics**.
  * Only on press (as opposed to continuous).
  * Rowing motions need time to recharge. Pressing the button _perfectly_ after recharge has some bonus; pressing it earlier some penalty or does nothing.
  * If you press both at the same time, go _straight forward_. (Now it does nothing because both forces cancel each other.)
* Create ElementSpawner
  * It can just take a module/resource that takes care of all those `query_position` calls and such.
  * (The bounds and stuff are read from config, which is read from the Global so I can just swap it out depending on game mode chosen.) (Global also doubles as signal bus and bg music and stuff.)
* Create ElementConverter + ElementGrabber ( + ElementDropper?)
  * To pick them up, convert, then spit back out again.
  * This is all based on PHYSICS (areas/body triggers)
* Camera2D 
  * Move to keep all players in view
  * A min-width/min-height (to prevent zooming in _too much_)
  * If this brings your zoom level too far back, give the player in last place a speed boost forward?
* Test multiple boats. See if it fits, if they can have fun interactions, etcetera.
* Finish
  * Display finish. (Just a simple rectangle at the final edge, with a shader that creates blocks.) (Though perhaps we place it a bit _earlier_ because we want some extra space for the boats to go afterwards; and then we use a final collider to close off the track at start/finish)
  * Track time and finishers.
  * Allow going to game over and displaying the ranking.


## General

* Put the other game mode into `main_castle.tscn` or something.
* RowingBoat movement/mechanics
  * The rowing boat should emit a signal when finished, which the player can then listen to and determine it has finished.
* Converter (Element goes in, wait a while, something else is dropped)
* MonsterSpawner (in waves, increasing difficulty, random positions screen edge)
* ElementSpawner (just spawn randomly, not too close to players, with min/max restrictions)
* Heart (something that must be protected, takes damage, game over if destroyed)
* Player / Monster / Element objects
  * Player = listens to player input, otherwise reuses the same modules as everyone else
  * Monster = has some type resource, movement resource, attracted to closest elements
  * Element = just has an area for picking it up, doesn't do much else
* INPUT
  * I need to decide _how_ to support/distribute multiple players over possible locations/boats.
  * And how to easily communicate this or provide key hints
    * OPTION: On login screen, if you're alone, it shows both controls? (If a second player logs in, it switches to just the one?)
    * OPTION: Display the key hints in the game itself.
      * You can choose your "game mode"? "Teams" (two people in the same boat, controlling only one paddle of it) or "Solo" (everyone in their own boat, controlling both paddles) => At least _implement both_
  * @IDEA: Also allow up/down keys to move the _other player_, so you can control both players even with a single hand?






@IDEA: 
* All garbage is just that: garbage. That's how you know it can be picked up and hasn't transformed yet. (Anything else has been the result of transformation.)
* What it _turns into_ depends on which area you're in.
  * OPTION A: The map is divided into changing areas, and the area you're in when you PICK IT UP matters.
  * OPTION B: The map is divided into changing areas, and the area you're in when you DROP IT matters.
  * OPTION C: The inside palace is divided into areas. The area your other player is in when you PICK IT UP/DROP IT determines what comes out of it!
    * This basically requires the palace to be built from grid (tilemap, wave function collapse, whatever).
    * Because then we can use a simple flood fill algorithm to create all areas for all possible end products.
    * **This feels most promising!**
    * (If there are multiple players inside, it just becomes a random option out of all.) 

@IDEA: Players/Monsters/Elements.
* They all have a "InsideOutsideModule" (need better name)
* It simply switches Resources based on where this object is. (InsideRuleset or OutsideRuleset)
* And the properties of that determine how it should function.
* (There could also be the TransitionRuleSet which triggers any custom logic for when the transition happens.)

@IDEA: MonsterSpawner.
* Each wave simply has a strength (say 10), and each monster has an individual value (say 2)
* It _randomly selects_ from monsters that are available, until it gets a _total value_ equal to _strength_. (With slight margin for error, otherwise we remove the last added option and pick the "friendlier version" of the wave.)
  * Also immediately add debug radius for the monsters for when they'll pick up Elements to walk towards => I've learned how useful that is.

@IDEA: _Currents_ in the water could push and pull monsters in certain directions. (Maybe your _boat_ creates those currents?)