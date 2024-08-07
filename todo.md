
# To-Do

* **Tuesday:** I want the rowing version finished, including solid reusable modules for the other modes.
* **Wednesday:** Finish all components to close the core loop of the castle version.
* **Tuesday:** Try all rules tweaks, different configurations, extra ideas.
* **Friday:** Once we know what's needed, create the visuals + sound fx + everything for it.
* **Saturday:** Rest day. (Possibly playtest.)
* **Sunday:** Do everything needed to be submit final version before going to bed.


## Rowing Game


AI/SINGLEPLAYER:
* Properly scale the piranha areas. (My current settings are fine, so recreate them through config scalars)

POLISHING:
* Make Input + GameOver look better
* Provide actual buttons on GameOver
* POWERUP: Extra health? Seems pretty useful now




## General

* Put the other game mode into `main_castle.tscn` or something.
* RowingBoat movement/mechanics
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

TEST:
* Discrete canoe movement



## Polishing

* Prevent insta-grabbing what comes out of broken rocks => give those elements an impulse too, _away_ from whatever broke the rock?
* Prevent finished boats from going back into the route? (Just disable their movement entirely? A one-way wall? They can go back, but they just can't interact with anything anymore?)
* BOOST: show on the canoe (of last player) that they're being boosted. (Also destroy stuff in their immediate surroundings to make sure they get unstuck?)
* SPAWNING: Maybe add some _moving/more dynamic_ obstacles on the river => re-use the MonsterSpawner for this!
  * Piranhas I guess?
* Probably want a wider/longer river on higher player count.

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

@IDEA: Maybe your _boat_ could create some of the currents.


## Collision Layers

1 = World Bounds
2 = Rocks
3 = Elements + Else (this layer is used by the feeler on the canoe)
4 = Currents (need player to be on layer 4 to scan and pick them up in Area)
5 = Finish (similarly, need player to be on layer 5 to scan and pick them up)

When the player becomes ghost, they are taken out of layer 2 and 4. They still scan layers themselves, though, such as layer 1, to stay within bounds.