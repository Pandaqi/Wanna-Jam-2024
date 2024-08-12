



## Future To-Do

* SPAWNING: Maybe add some _moving/more dynamic_ obstacles on the river => re-use the MonsterSpawner for this! => Piranhas I guess?
  * Yes, we can have one obstacle that simply moves, but doesn't hurt.
  * And one that actively chases you, like piranhas, but you can defeat it somehow?
* Some EXTRA SPICE for swimming players. (Maybe you're not allowed to finish without canoe, but then we'd need another rule to ensure you always get your canoe back _eventually_.)
* Perhaps _link_ your Canoe Element to you specifically, so only _you_ can pick it up?
  * At least implement this as _possibility_.

GRAPHICS:
* (Some other decoration sprites for variation?)
* BOOST: show on the canoe (of last player) that they're being boosted. (Also destroy stuff in their immediate surroundings to make sure they get unstuck?)
* Display some other menu/message in single player when we lose.
* Don't think Piranha and HealthBar are now scaled accordingly to Config ...
* Make finish child of water texture, so it can clip-children and it's neatly inside => the alternative is to simply place the finish BELOW the decorations layer, which is less expensive but also less exact

@IDEA (Kingside Out): 
* All garbage is just that: garbage. That's how you know it can be picked up and hasn't transformed yet. (Anything else has been the result of transformation.)
* What it _turns into_ depends on which area you're in.
  * OPTION C: The inside palace is divided into areas. The area your other player is in when you PICK IT UP/DROP IT determines what comes out of it!
    * This basically requires the palace to be built from grid (tilemap, wave function collapse, whatever).
    * Because then we can use a simple flood fill algorithm to create all areas for all possible end products.
    * **This feels most promising!**
    * (If there are multiple players inside, it just becomes a random option out of all.) 

@IDEA: Maybe your _boat_ could create some of the currents. (Whenever you do X, or you make a really sharp/fast turn, it leaves behind a current imprint?)




## Collision Layers

1 = World Bounds
2 = Rocks
3 = Elements + Else (this layer is used by the feeler on the canoe)
4 = Currents (need player to be on layer 4 to scan and pick them up in Area)
5 = Finish (similarly, need player to be on layer 5 to scan and pick them up)

When the player becomes ghost, they are taken out of layer 2 and 4. They still scan layers themselves, though, such as layer 1, to stay within bounds.