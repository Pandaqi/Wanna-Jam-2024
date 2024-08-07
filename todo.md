
# To-Do

* **Tuesday:** Try all rules tweaks, different configurations, extra ideas.
* **Friday:** Once we know what's needed, create the visuals + sound fx + everything for it.
* **Saturday:** Rest day. (Possibly playtest.)
* **Sunday:** Do everything needed to be submit final version before going to bed.


## Rowing Game

CRASHING BUG (PROBABLY FIXED NOW): When switching in/out of canoe => probably when players hit each other, perhaps with the yellow one


GRAPHICS:
* Piranhas
* Actual canoes
* Details to all the existing sprites
* (Some other decoration sprites for variation?)
* Prettier UI and buttons
* Prettier Health bar

POLISHING:
* BUG: Explosion particles don't show up?
* ACTUALLY EXPLAIN THE MAIN THING
  * Move by paddling left/right
  * If you pick up garbage, the current area type is spit out a moment later. These are usually _good_ to pick up.
  * If you lose all your health, your canoe breaks and you have to swim---which is usually worse. Once you catch your Canoe powerup, however, you get it back.
  * Race to the finish. Best time wins!
* Make Input + GameOver look better
* Make elements a little more noticeable => add BORDER around them? At least more DETAILS and CONTRAST.
* Provide actual buttons on GameOver
* POWERUP: Extra health? Seems pretty useful now. (More useful than the mass changer or something.)
  * With how quickly/often canoes break, though, how useful is it really? Maybe extra health + temporary shield?
* BOOST: show on the canoe (of last player) that they're being boosted. (Also destroy stuff in their immediate surroundings to make sure they get unstuck?)
* SPAWNING: Maybe add some _moving/more dynamic_ obstacles on the river => re-use the MonsterSpawner for this! => Piranhas I guess?
  * Yes, we can have one obstacle that simply moves, but doesn't hurt.
  * And one that actively chases you, like piranhas, but you can defeat it somehow?
* Some EXTRA SPICE for swimming players. (Maybe you're not allowed to finish without canoe, but then we'd need another rule to ensure you always get your canoe back _eventually_.)
* Perhaps _link_ your Canoe Element to you specifically, so only _you_ can pick it up?


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

@IDEA: Maybe your _boat_ could create some of the currents. (Whenever you do X, or you make a really sharp/fast turn, it leaves behind a current imprint?)


## Collision Layers

1 = World Bounds
2 = Rocks
3 = Elements + Else (this layer is used by the feeler on the canoe)
4 = Currents (need player to be on layer 4 to scan and pick them up in Area)
5 = Finish (similarly, need player to be on layer 5 to scan and pick them up)

When the player becomes ghost, they are taken out of layer 2 and 4. They still scan layers themselves, though, such as layer 1, to stay within bounds.