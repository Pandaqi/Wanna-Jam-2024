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

## Step 1: Start with rowing

### A first attempt

With so much work to do, and so many unknowns, it's easy to get overwhelmed. As such, I decided to latch onto the simplest part to execute and _make specific_, just to get something going.

That turned out to be the rowing idea. Even though I expected this to _not_ be the final game, the first thing I created was ...

* The left/right paddle motion for a boat (or canoe I guess)
* A random river/track generator.
* Randomly spawning elements to convert, areas with a current, etcetera.
* And finishing that core game loop.

This forced me to make specific scripts and implementations for at least half the things I'd also need for the other ideas. The rowing motion, obviously. But also, for example, the `ElementSpawner`. In this simple "rowing race" the spawner is linked to a function that generates random positions on the track. In the other modes, that same general module would just be linked to a _different_ function that spawns the elements in some slightly different way.

This took about a day, but it allowed me to make progress and built parts of the general skeleton. It also just ended up being a fun game and, if all else fails, I'll just submit this one :p

{{% remark %}}
I'll see if I can make a tutorial about how I did the river track. It's a rather simple algorithm that creates organic, non-problematic rivers. With the proper boundaries around it, so you can't go out of bounds, a seamless water shader over it, etcetera. But it uses a lot of tricks and cool ideas that I think others might find useful too!
{{% /remark %}}

### I still have no clue

Okay, now I had a "game". You could press one button to paddle left, one to paddle right, and you could follow a river until the finish.

Where was I going with this? I didn't know! But I couldn't waste time---and sitting still and doubting never brings you anything---so I just started implementing all sorts of ideas that came to me.

* I placed random rocks within the river, with the assurance that there was always a way around it. This made it far more varied and challenging to race the track.
* I added water currents. Hotspots that clearly push you in a certain direction. (And I made a shader to nicely show this direction and strength, otherwise players would just be confused.)
* I added _damage_ to the rocks => if you hit them often enough, they break apart and reveal some nice thing to pick up.
  * I also did this just in case you _did_ ever get stuck behind rocks, however rare.
* I subdivided the river into sections. (Because the river is just a list of points in the first place, this is extremely easy to do: just cut that array into random pieces.)
  * First of all: for visual variation. Each section has its own color and variations on how things can be placed etcetera.
  * Secondly, so that I can show a simple "tutorial sign" whenever a new area starts. (So you learn what each element does as you play the game.)
  * Thirdly, so that the area can _determine_ what elements come out of you. ( = If you're in the red area, any garbage you pick up will come as the Red element a few seconds later.) 

All of these ideas were fine. But I still didn't really know what I was moving towards. And I was surely moving _away_ from the theme of the jam.

Although it is fun to wobble around in my random river, I currently have no great ideas for how to actually make that a more full-fledged game.

I decided to come back to the jam's theme and just finish a "playable version", then completely shift to the next simplest idea.

### A "minimum viable prototype" of rowing

In practice, this meant the following.

* Add some barebones menu and game over screen (with the finish times and such), to close the game loop.
* Add some barebones images to see what we're doing. (Mostly more _shaders_ to make water seem like water, and the other things to seem like they _drift_ on the water. I'm not good with shaders, so I was fine with this extra bit of practice.)
* JAM THEME: Allow players to get _out of their boats_. (So you can be inside or outside the boat.)
  * I added damage to the boats as well. Once they're destroyed, you end up in the water. (Behind the scenes, you change your `Vehicle` from Canoe to Swimming :p)
  * This makes you slower and more restricted.
  * Once you pick up the Canoe powerup, you get it back.
* SINGLE PLAYER: Navigating the track has now become too sophisticated to make an "AI" opponent (that is actually smart and balanced). So, instead, I decided to support single player with the time-tested "the lava is rising / the ceiling is falling"-threat.
  * There is a bunch of piranhas that starts behind you. You must stay ahead of them; if they catch you before finishing, you lose.
  * These piranhas don't move around like the player. They just follow the predetermined river path, point to point, ignoring any obstacles.
  * BUT they can be distracted by the elements you drop. 

As usual, trying to "power through" and generating more and more ideas and solutions _does_ lead to some better gameplay. 

For example, at first you could just move freely if you landed in the water. (You could use all four arrow keys.) After trying a bunch of different movement patterns, however, I found one that still only uses those two buttons _and_ is slightly harder than the canoe but not _too hard_. 

Similarly, I tested the rule that "once you've fallen in the water, you can only pick up a canoe, and none of the other powerups" and "when your canoe breaks, the _canoe element_ always shoots out of it, so you _always_ have a quick way to get back in a canoe (if you chase it)". Both of these are just a simple toggle in the code, but once turned on the gameplay immediately felt friendlier and nicer.

Just trying a bunch of stuff helped me end up at a much better solution for what to do. That's nice, but it can't solve the fact that the game is a bit directionless at its core.

Many of these things are mechanics I needed to code for the other ideas anyway. (Moving from land to water (in/out boat), entities being distracted by closest element, etcetera.)

But ... trying to do all this in _the same project_ was a bit of a bad idea. At this point, I just assumed the current project was entirely for the _rowing idea_, and would start a new one (copying over whatever was needed) for the others. I _could_ have put all files in unique folders per game prototype, but that would just mean endless folders, with one big _shared_ folder that was even messier, and it was all just a bit meh.

As such, after ~2 days of work, I started a fresh Godot project to implement the basic skeleton of the "Inside Sprout" idea.

@TODO: Continue



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



