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

### But first! A playtest

I managed to snatch two people for a quick playtest of the current start of the game. And I guess this is another example (one of many) of why it's important to let others see your stuff and make a judgment, because you---the creator---just can't see it clearly.

They loved it.

It's extremely easy to pick up and play, yet it's challenging in the right way. The rivers look beautiful and you actually grow more skillful over time. This game turned out to be _far better_ than my feeling of "it's a bit meh and messy".

Similarly, the addition of the piranha nipping at your heels (in single player mode) also just ... works really well? Perhaps because it's a clearly defined track and it's easy for me to let the piranha follow and chase you (in a fun, somewhat realistic way).

Of course, there was the usual list of issues.

* There was not enough margin at the edge of the screen. So when players were far apart, and you were zoomed out pretty far, the player(s) in last place couldn't see what they were doing at all!
  * I simply have a variable `screen_edge_margin` that can be bumped up. And I realized I forgot to calculate the proper bounds for players---it merely used their center point for zooming the camera, which obviously doesn't work well because the canoes are bigger than that.
  * I also added a check that players can't be too far apart in terms of _progress along the river_. If you're >10 segments behind the leader, you get a boost, and that also helps the camera stay more zoomed in as the players are closer together.
* I only check whether you should pick up/interact with something when it enters your area. (Far less expensive than checking _every frame_.) However, when you drop an element, it is temporarily an "exception" with yourself (for ~0.7s) to prevent picking it up immediately after dropping. But this means that the `area_enter` signal might not fire, because the element has been inside the area all along, but it was an exception!
  * The fix is to send a signal when this exception runs out, and then _recheck_ the bodies.
* In one test game, we had a _crazy_ bend in the river with 4+ currents traveling through each other. Players struggled to the point of getting frustrated :p
  * The fix, of course, is to check if currents overlap during placement, then remove the offending ones.
* Finally, and most crucially, there was a **recurrent crash**. It seemed to happen whenever players transitioned from canoe->swimming, or when they bumped into each other. What was the issue?
  * When they do this transition, there's a frame of delay. 
  * Why? You can't change physics bodies _while the physics are calculating collisions_. Instead, when the bodies interact, and damage is dealt, and their canoe breaks ... this procedure (canoe -> swimming) is _planned_ for the end of this frame.
  * In the mean time, stuff may happen. For example, they might have accidentally transitioned while overlapping an element drifting around.
  * By the time they make the switch ... that element they overlapped, might already be gone!
  * So now the code is dealing with invalid / null references, and it crashes!
  * The fix is to check if the objects needed are still available and as they should be when the code executes. (There is no cleaner solution. Simulated physics are simply a bit messy and I've learned to just do a few extra checks and add some more safeguards.)

A bit technical, perhaps, but it's just to illustrate the kinds of issues that come up now and how I solved them.

With that done, the game was completely unpolished (missing icons, no sound effects, etcetera), but it was actually a really fun game to play. And, as per my personal challenge, I devoted a plenty of time to making that river look visually stunning (which mostly meant learning some more shader magic/tricks). Okay, stunning is a big word, it just looks better than I expected a randomly generated curvy-river-line to look, okay?

@TODO: Can I do a screenshot of what I'm actually talking about?

If all else fails, I can add all this polish in a day or so, and make this my submission.

That said, let's look at that other idea.

## Step 2: Continue with something completely different

### Creating the skeleton

The next "simplest" idea was the Inside Sprout. That's really a simplification of Kingside Out.

On the third day, I woke up early and churned through the basic components needed for it. A few hours of non-stop coding, making files and folders, connecting stuff, creating Resources and classes for different things I'll probably need. I've mostly stopped connecting or doing things in the _editor_, prefering to handle it all through code. This way, I can copy-paste files to other projects and nothing is broken, because a certain connection (such as a signal listener) wasn't saved in the _editor_ instead.

{{% remark %}}
By the way, I'm doing all these jams during a (mostly self-proclaimed) summer holiday. Normally, I'd have my "more important" work to do first. I wouldn't be able to devote this much time to it, in fact, I don't recall ever having the energy to do a single game jam while not on some kind of break/holiday.
{{% /remark %}}

What were those components? (Yes, I was making this list the evening before to simply get my own specific to-do list for tomorrow.)

* Map
  * Some way to spawn, manage, check _areas_. (The area player A is in, determines what player B drops. And which area is _inside_/_outside_, of course.)
  * Some way to spawn and manage _elements_. (Just spawn randomly, not too close to players, with min/max restrictions.)
  * Some way to spawn and manage _monsters_. (In waves, increasing difficulty, random positions screen edge.)
  * The "Heart". (Something that must be protected, takes damage, game over if destroyed.)
* Monster Logic
  * General movement Resource: Drawn to nearby elements they "desire". Otherwise walk to your Heart. If they hit it, take damage.
  * General type Resource: other properties, which frame of spritesheet to display, etcetera
* Player Logic
  * Movement (with a swappable module for _how_ exactly they move, because I'm not sure yet)
  * The chain for "pick up element(s) > convert > drop converted"
* State/Progression
  * The thing that manages how far you've come, when it's game start/game over, which rules are unlocked

At this point, I still had two major questions left:

* What's the significance of inside/outside? What is the real difference and challenge from controlling two characters, one of whom is "inside"?
* What's the theme or map layout? Painting colored circles on a flat solid floor will not look or feel great ...

Then I noticed the words "just spawn randomly" in my notes for spawning elements. Experience tells me that this is usually a great opportunity to change "random/whatever" to "controlled by player". For now, I went ahead with the following idea.

* The inside player _purchases new seeds_. They have stations for buying certain elements / making them spawn in certain locations. That's how you must manually make stuff appear, and hopefully in a tactical way.
* There's a moat _between_ the two players, so they literally can't visit each other's spaces. (And that moat can reuse my organic river generation code.) They can pass stuff between them, though, which is a transition that should _matter somehow_.
  * Maybe you can visit/swap places, but you need to both be at the harbor and it takes time.
  * Maybe giving stuff back to the inside is the _only_ way the inner player can get defenses/weapons in case the monsters break through there.
  * Maybe there are bridges to the inside. Destroying/changing those bridges are a crucial part of strategy, but it takes resources/timing/being at the correct station to do so obviously.

Ugh. See what I'm doing again? I'm overcomplicating it! Moving towards Kingside Out again, while I wanted to do the _simpler_ version of that idea first.

So no no no, forget about that _for now_. Let's make Inside Sprout first, which just has a single player (or all players doing the same thing, free to move around), randomized areas, and completely focuses on "one thing goes in > wait > another thing comes out"

### How'd that go?

I ended up doing the following for the map.

* The world is a _grid_.
* Using a simple flood-fill, I divided it into areas of different types.
* Then I found the _outline_ of those areas, so I had a single polygon that I could draw and fill.
* And then I could use a shader to make the edges a bit fuzzy and wobbly, so the transitions are nicer.
* And we get a world subdivided into areas of different types, without looking extremely static or harsh.

In general, it's wise to _start_ random generation from order, then slowly make it more chaotic or random. Starting from pure randomness and trying to wrangle order out of that ... yeah, usually not great. That's why I (and many other algorithms for this) love starting with a grid or subdivisions of some sort, and then modifying that.

It _also_ makes area checks exceptionally cheap and opens the doorway to Kingside Out. (For example, I can simply mark a few areas in the center as "inside", and forbid the player there from leaving them. Boom, we're getting there. But as I say that, I am very uncertain whether I'll have time to get anywhere near that third idea.)

I had some trouble with the shader. I'd coded one to make the edges of a rectangle jagged ... only to realize that the areas were obviously going to be irregularly shaped :p So how does it know if it's dealing with an edge?

After some trial and error, I had the eureka moment that I could pretend each area was a circle. In other words, 

* I step through the outline (the `Vector2` points that determine the edge, which are already sorted in the right order)
* For each point, I pretend it's the next step on a circle. (So, I update the angle by X. Then I get the position on a circle of radius `0.5`, at position `(0.5, 0.5)`, with that angle.)
* Then I simply assign that circle location as the UV coordinate for this point.
* And in the shader, I can now calculate the "distance to the edge" of any point by calculating the distance of its UV to `(0.5, 0.5)`. All the points on the edge will fall exactly on that circle, with distance 0. (And so, if within a certain threshold, I enable the noise texture value for that pixel to make the edges fuzzy and wobbly.)

This took me an hour and a half, but it works flawlessly now and I learned a lot about shaders and UV coordinates again.

@TODO: IMAGE OF MAP IN PROGRESS

I could re-use my code (from the rowing game) for picking up and converting elements based on the area where you are. (Though with major modifications, because now you can have _multiple elements_ at the same time, and I needed some timer/visualization for that.)

The monsters and spawning had to be done from scratch. But it's not too hard to assign a specific weakness to a monster, then check if one such element is in range, and if so, walk to it.

Or so I thought ...

### Trying to find the game

Once I had all the core elements, I tested the game, and it obviously wasn't fun. Numbers were wacky. Distances too big. I only had a pretty map and no other sprites, so I had no clue what every plant/monster even was :p

The crucial thing here is to try a lot of things and find a simple core game loop that _does_ feel fun, even lacking graphics.

And so I noticed the following things.

**Tweak #1:** It feels odd if monsters instantly consume/remove a flower. That means "distracting" them often has a disappointing impact, as they just walk out of their way for 1 second, destroy the distraction, and they're headed for the Heart again.

Additionally, when trying to invent multiple types of monsters/flowers, I noticed I didn't have many properties to "tweak". I needed more ways to differentiate how these objects function in the game.

And so I decided to create a second module (`Attacker`), and give both `Health` and `Attacker` to both enemies and elements. In other words, 

* They _both_ have a health bar.
* Attacking just does X damage ... and then it waits for a timer to attack again.
* Once health is empty, of course, one of them dies and the attack yields.
* To keep plants more passive, though, which feels more fitting, they only attack when provoked.

This felt far better. Distracting enemies actually meant something. And now I could tweak health, damage, attack speed, etcetera between different types.

**Tweak #2:** The biggest danger in a game like this is that the "optimal" strategy is to stay close to your Heart and plop all your defenses down there. Most of the ideas I had were making this problem _worse_. They were nudging/encouraging players to stay closer to their Heart, to move less, to do the passive/safe thing.

When I noticed this problem, I purposely flipped it around. How can I make sure the player is often forced to move away and to keep moving?

* The rule of "what you drop depends on your area" already helps here, but really only at later stages, when monsters have wildly different flowers that could attract them.
* Giving monsters pretty small sight/kill ranges would help too. (Communicating their exact range with a circle on the ground or something also seems smart.)
* I continued my idea of "inside and outside" 
  * The areas around the Heart are automatically assigned _inside_ and given a different look.
  * When inside, you **can't drop elements**. In other words, when close to the Heart, you literally _can't_ put up defenses.
  * What _can_ you do instead? Well ...

**Tweak #3:** All these tweaks make the game far more dynamic, but also lead to situations of "powerlessness". If a monster comes from direction A, and there is simply no area at in its path that grows the right flowers---you can't stop it! You just can't.

At first, I considered giving the player some slight attacking power too. But no, the unique factor of this game is that you can't do damage directly, only through planting flowers/dropping seeds.

Instead, I used the remaining question ("what different thing can you do when inside?") to answer this.

* When inside, anything you drop becomes the same thing: a bullet.
* Around the heart is also a cannon. As long as there are bullets inside, you can operate the cannon and shoot.
* Your other properties (timer, speed, etcetera) are also different inside.
* And when you visit your Heart (or some other space inside), perhaps whenever you transition inside/outside, the areas recolor themselves.

I also opted for this "tree gun" because of perhaps the final major problem: once monsters _have_ broken through your flowers/defenses, they can juts attack the heart endlessly, and you can do nothing to stop it. That's the downside of having the "rule" that the player itself does not interact with the monsters at all. But with a cannon from your heart, which you can always reload and aim, you can still shoot monsters that have come inside.

I implemented this, as always, in the way that requires no extra explanation or controls.

* The cannon automatically aims in your direction when you're walking inside.
* It automatically shoots on a timer, provided you've dropped at least one bullet.
* And if you've seen it once, you understand what it does and can use it easily.


### That's a game?

Though not amazing, this actually makes the game challenging and interesting to play.

It really _is_ a simplified version of Kingside Out. Which, I realize, I probably wouldn't have managed to make in the short timeframe anyway.

I ended up simplifying it more and more as I realized I ran out of time ... and plain out of energy and motivation. I've written another article about my experience doing several game jams in a row and all the mistakes I made that led to being too exhausted to properly finish this one :p

The biggest one is to simply unify "distracted by" and "killed by". These were two different things in the code: animals were always _distracted_ by more things (so they went out of their way to visit that flower) than they were _killed_ (only a few of those distractions would actually attack).

When it came time to determine the specific properties of all animals/enemies, though, I realized this distinction was moot. It overcomplicated things without any tangible benefit. So now there's only _one_ enemy that actually has a difference, while all others are just "anything that distract us kills us".

Similarly, I _randomized_ the duration of the conversion (pick up seed -> ... random time ... -> drop) at first. Easy to code, extra variety, extra challenge right? (And you could see the timer for each one clearly, so it wasn't guesswork for the player.) When playing the nearly finished game, though, I noticed that it's just annoying if the order that elements will drop completely changes (at random) every time you pick up something. It's much nicer if you know the first timer will finish first, so you also know exactly where you need to be then. 

This randomness served no purpose, and turned something that should be fun strategy into an annoyance, so all element conversions simply became a fixed time.


@TODO: IMAGE/VIDEO of how it plays now?

I would've loved to try all the other ideas and twists and mechanics, but time is running out now. It's time to start polishing both ideas, otherwise I risk missing huge chunks of sprites/sound effects/necessary tutorial instructions by the time I have to submit.

## Conclusion
