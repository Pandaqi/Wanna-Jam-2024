Welcome to my devlog for the game jam called _So you WANNA Jam!? 2024_. The jam was held from August 3th to August 12th by the YouTuber/Game Developer Wannibe Manisha.

Because the jam has a longer timeframe, I'll probably be able to track this devlog as I go (instead of writing it after the fact). I'll explain the general process of making my entry, any interesting problems and solutions, and whatever else seems worth sharing.

## What's the idea?

The **theme** for the jam was **Inside Out**. As it was revealed, I was still busy finishing other projects, so I didn't start work until a few days later.

Nevertheless, I knew by just looking at the theme (and reminding myself of it a few times), would help my brain start subconsciously generating ideas. And indeed, by the time I could actually start on this jam, I already had a few approaches. Three of them, to be precise.

### The initial 3 ideas

**Idea #1 ("Kingside Out"):** There's a palace in the middle of the screen. Monsters come in at all sides (in "waves"), and you lose if they destroy the palace. 

You control _two_ characters. One stands inside the palace, another outside. Obviously, they have different tasks and powers, and you must work together (or play them both by yourself) to succeed.

**Idea #2 ("Finside Out"):** You're in a rowing boat, but each key is bound to a single _paddle_. One paddle is always on the _outside_ (and steers you one direction) and another peddle is always on the _inside_ (and steers you the other direction). On other words, you can only go _inside outside inside outside_ to move where you want, instead of going straight or whatever.

This can be singleplayer or multiplayer (again). You can just sit in the same boat (each doing one paddle), or be distributed over multiple boats. The objective would be to win the race.

**Idea #3 ("Inside Sprout"):** You're cute little beings of some kind. There's _food_ around the level. By _eating_ it (shoving it inside your mouth) ... something else will _sprout_ later (it comes out of you, like, erm, pooping). In other words, you have to transform things into the right other things by eating and then "dropping" a bit later. 

But what's the _objective_? This could be a puzzle-like game (you need to make sure item X ends up in location Y at the right time). Or it could be another "tower defense" thing: the monsters attacking you are attracted to the closest thing you dropped. Some are good to them, some will kill them. As such, you need to eat the right thing and then poop out the result close to a monster that will be killed by it :p

(And then maybe, to really reinforce the theme, this transformation will have different rules/consequences when _inside_ certain areas or some _inner circle_ that you need to defend.)

### What do we pick?

All these ideas felt promising. I was tempted to prototype them all, in separate projects. 

That seems "doable" the moment you think it, but my experience tells me it really isn't. You need to add too many details, code, simple graphics to be able to actually judge if the idea is good or not. (No, 20 equally gray boxes moving around without purpose is not a good test of a game's fun factor :p) To do so for _three completely separate projects_ ... nah.

Instead, there's a lot of overlap here. 

* The Inside Sprout idea would benefit from some "inner circle" that needs to be defended or has different properties---hey, that's the same as the palace of Kingside Out!
* Similarly, both ideas require defending against threats coming in---hey, we can streamline that if we give the rowing game the same setup (instead of racing to the finish, protect something)
* All ideas require movement---hey, why wouldn't movement just always be a rowing boat?
* The Inside Sprout idea is basically about transformation: you put something inside something else, and another thing comes out---hey, we can make the same happen by moving stuff inside/outside the palace.

As such, I did what is usually a good idea for creativity (and just making decisions and not losing momentum): I smashed all three ideas together.

If I keep the code clean, I can reuse all components in different ways, and try these ideas with the exact same codebase.

For now, though, this is a possible _merge_ of ideas.

* The palace is on an island in the center. Everything around it is water. (Like a huge _moat_ around the castle.)
* Monsters come in from the edge. If they reach your "Heart" on the inside, they deal damage. Health < 0 = lost.
  * They come in "waves", because I've never done that before and it fits the water theme of course.
  * They walk by being attracted to the closest Element (if within range).
* The OUTSIDE player ...
  * Attacks monsters by touching them or dropping "bad items" to attract them.
  * Moves around in a boat. Random garbage drifts in the water (to pick up).
* The INSIDE player ...
  * Attacks monsters by activating stuff on the palace. (They only have long-range stuff like cannons, which require certain things to be in storage to fire?)
  * Moves around normally. (Though maybe not, having to learn/use only _two_ buttons per player, always, is nice simplicity.)
* On the TRANSITION between inside/outside
  * Monsters can change. (Become something else, suddenly move faster, etcetera.) => Maybe they're all fishes in the water, then transform into their actual being once on land?
  * Elements change instantly. (You )
* Stretch goals ...
  * Perhaps _how_ each element _transforms_ is displayed on "tutorial places" on the island, as a constant reminder. And if the inside player walks over those, they change?
  * Both players can be outside or inside too. 
  * Some recurring curse/modifier that _swaps places_ (so the inside player is now outside and vice versa)?
  * Roguelike unlocks / progression / heavily randomized map generation or setups?


So ...

## What are my personal challenges?

I always want to invent one or two extra restrictions, just to force myself to learn something new and improve. (Instead of game jams just being "make the same game/mistakes over and over, very quickly" :p)

The first one I just stated: flexible setup to allow different "game modes" all in the same project.

The second one is an improvement on working with Custom Resources in Godot. I've learned how to make them as data containers, I've learned how to use them to define behavior, but my previous project saw me give the `Config` resource to over fifty scripts, and I got tired of it. It's much better to have _one_ Global Autoload script that holds the Config resource, and everything reads that. (Because it also allows completely swapping out the game config for another by just swapping out that single config.)

Similarly, I still tempt to hardcode references to module scripts, making it impossible to actually reuse them in "any other location" or "any other combo of components". So let's try to make these tiny tweaks to my game architecture (which is already quite good, I think).

The third and final one has to do with graphics. Because of my 15+ years experience, my graphics always look _fine_. But never _great_ (or better!). And I feel stagnant, probably because I don't really do animations or shaders or any more fancy and complicated effects. For this game, I want to see if I can do more with lighting, and make the water look really nice, and all that stuff.

## Step 1: Make what we'll surely need

I see a few components that we'll need regardless of the game idea.

* RowingBoat movement/mechanics
* Converter (Element goes in, wait a while, something else is dropped)
* MonsterSpawner (in waves, increasing difficulty, random positions screen edge)
* ElementSpawner (just spawn randomly, not too close to players, with min/max restrictions)
* Heart (something that must be protected, takes damage, game over if destroyed)
* Player / Monster / Element objects
  * Player = listens to player input, otherwise reuses the same modules as everyone else
  * Monster = has some type resource, movement resource, attracted to closest elements
  * Element = just has an area for picking it up, doesn't do much else

I decided to make all of these first, and then see where we were and how I felt about the ideas.

@TODO

## Step 2: A first prototype

Now we combine the elements for the first time to get our first prototype: monsters move in, we row around converting stuff, and we must survive.

@TODO

We can also create a slightly different prototype with just the rowing.

* First, just create a race in a straight line, start to finish. The main challenge is timing your inside/outside rows well, but you still convert stuff too. (Which other players or yourself can then pick up for a certain bonus or not.) And, of course, there could be rocks or whatever placed on the parcours, and water currents.
* Then, for extra challenge, randomly draw a path, and turn it into a curved race.



@IDEA: 
* All garbage is just that: garbage. That's how you know it can be picked up and hasn't transformed yet. (Anything else has been the result of transformation.)
* What it _turns into_ depends on which area you're in.
  * OPTION A: The map is divided into changing areas, and the area you're in when you PICK IT UP matters.
  * OPTION B: The map is divided into changing areas, and the area you're in when you DROP IT matters.
  * OPTION C: The inside palace is divided into areas. The area your other player is in when you PICK IT UP/DROP IT determines what comes out of it!
    * This basically requires the palace to be built from grid (tilemap, wave function collapse, whatever).
    * Because then we can use a simple flood fill algorithm to create all areas for all possible end products.

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