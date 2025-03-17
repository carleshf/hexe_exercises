package;

import openfl.display.Sprite;
import openfl.display.Shape;
import haxe.Timer;

class Pathfinder {
    var dungeon:Dungeon;
    var tileSize:Int;
    var offsetY:Int;

    public function new(dungeon:Dungeon, tileSize:Int, offsetY:Int) {
        this.dungeon = dungeon;
        this.tileSize = tileSize;
        this.offsetY = offsetY;
    }

    public function findPath():Array<{x:Int, y:Int}> {
        // A* implementation - should I look for an eficient implementation?
        var openList:Array<PathNode> = [];
        var closedList:Array<{x:Int, y:Int}> = [];

        var start = new PathNode(0, 0);
        var goal = new PathNode(dungeon.size - 1, dungeon.size - 1);

        openList.push(start);
        var directions = [{x: 0, y: 1}, {x: 1, y: 0}, {x: 0, y: -1}, {x: -1, y: 0}];

        while (openList.length > 0) {
            openList.sort((a, b) -> a.f - b.f); // Sort by lowest cost
            var current = openList.shift();

            if (current.x == goal.x && current.y == goal.y) {
                var path:Array<{x:Int, y:Int}> = [];
                while (current != null) {
                    path.unshift({x: current.x, y: current.y});
                    current = current.parent;
                }
                return path;
            }

            closedList.push({x: current.x, y: current.y});

            for (dir in directions) {
                var nx = current.x + dir.x;
                var ny = current.y + dir.y;

                if (nx >= 0 && ny >= 0 && nx < dungeon.size && ny < dungeon.size && dungeon.getTile(nx, ny) != 1) {
                    if (Lambda.exists(closedList, c -> c.x == nx && c.y == ny)) continue;

                    var g = current.g + 1;
                    var h = Math.abs(goal.x - nx) + Math.abs(goal.y - ny);
                    var f = g + h;

                    var existing = Lambda.find(openList, n -> n.x == nx && n.y == ny);
                    if (existing == null || g < existing.g) {
                        openList.push(new PathNode(nx, ny, g, Std.int(h), current));

                    }
                }
            }
        }
        return [];
    }

    public function animatePath(parent:Sprite):Void {
        var path = findPath();
        if (path.length == 0) return;

        var delay = 200;
        for (i in 0...path.length) {
            var step = path[i];
            Timer.delay(() -> {
                var tile = new Shape();
                tile.graphics.beginFill(0x00FFFF);
                tile.graphics.drawRect(0, 0, tileSize, tileSize);
                tile.graphics.endFill();
                tile.x = step.x * tileSize;
                tile.y = step.y * tileSize + offsetY;
                parent.addChild(tile);
            }, Std.int(i * delay));
        }
    }
}
