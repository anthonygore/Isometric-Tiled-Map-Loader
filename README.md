gridmap
=======

Grid Map for Corona SDK using Tiled

Gridmap is a moderately simple map loader. It will load tiled maps created with Tiled. It returns a display group with each layer inside it. I wrote this very quickly; if you find a problem, just post on this page. Gridmap is not extremely sophisticated - no extras, just loading maps. But, I hope it will help someone, as it has helped me. I have also only tried it with orthogonal maps - no isometric ones. Loading isometric maps is not guaranteed.

Feel free to edit it in any way you want to.

Tiles are each individual sprites.

### Usage:
---------------------
<code>
local gridmap=require("gridmap") -- Load the library

local map=gridmap:createMap("map") -- Specify which map to load
</code>

The map file that you load must be exported as a .lua file. To do that, in Tiled, when you've finished your map, go to File > Export As. In the "Files of Type" field, specify "Lua files (*.lua)."


###Tiled instructions:
In Tiled, you can, of course, specify properties for a layer or tileset.

Properties:
You can add any property you want to a tileset, but it will not change the tileset in any way when you load it. It will simply add it to the tileset's property table.

You can also add any property to a layer.

Properties beginning with "Physics:" will be passed to the physics properties when a tile in the layer is created.
Example:
Properties of the layer you made in Tiled:


<code>
Physics:existent = true
</code>

Existent is true = the layer has physics or false = does not have physics)


<code>
Physics:bounce = 0.3
Physics:isSensor = true
</code>

You can make whatever params you wish, so long as they can be put inside a normal physics params table: physics.addBody(obj, "kinematic", {params table} )
Properties beginning with "Layer:" will be passed to the layer itself, instead of the layer's properties. That means parameters like rotation, xScale, yScale, etc... will be applied to the layer in general (a display group)

Example:
Properties of the layer you made in Tiled:


<code>
Layer:rotation = 90
Layer:x = 30
Layer:y = 90
</code>


Simple.
Properties beginning with "Tiles:" are the same as properties beginning with "Layer:," only they are passed to each tile. Otherwise, they are exactly the same.

To access a single tile, use this:

<code>
local chosenTile=map:getTile(1, 3, 3)
--Parameters:
--Layer - number, the layer the tile you want is in
--X - number, the x (in tiles) of the tile you want
--Y - number, the y (in tiles) of the tile you want
</code>

Most of the values are inside of the map. Such as:


<code>
map.layers = a table holding each layer
map.layers[1].tiles = the layer's tile table
</code>
