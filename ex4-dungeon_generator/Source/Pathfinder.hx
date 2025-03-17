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

    public function findSafestPath():Array<{x:Int, y:Int}> {
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
    
                if (nx >= 0 && ny >= 0 && nx < dungeon.size && ny < dungeon.size && dungeon.getTile(nx, ny) != Dungeon.WALL) {
                    if (Lambda.exists(closedList, c -> c.x == nx && c.y == ny)) continue;
    
                    var tileType = dungeon.getTile(nx, ny);
                    var g = current.g + 1;
    
                    // Modify Costs:
                    if (tileType == Dungeon.TRAP) g += 10; // Avoid traps (higher cost)
                    else if (tileType == Dungeon.COIN) g -= 2; // Prefer coins (reduce cost)
                    else if (tileType == Dungeon.GEM) g -= 4; // Prefer gems even more (reduce cost)
    
                    var h = Math.abs(goal.x - nx) + Math.abs(goal.y - ny);
                    var f = g + h;
    
                    var existing = Lambda.find(openList, n -> n.x == nx && n.y == ny);
                    if (existing == null || g < existing.g) {
                        openList.push(new PathNode(nx, ny, g, Std.int(h), current));
                    }
                }
            }
        }
        return []; // No path found
    }    

    public function animateShortesPath(main:Main):Void {
        var path = findPath();
        animatePathOnGrid(main, path, 0xFF0000); // Red for shortest path
    }
    
    public function animateSafePath(main:Main):Void {
        var path = findSafestPath();
        animatePathOnGrid(main, path, 0x00FF00); // Green for safest path
    }
    
    /*private function animatePathOnGrid(main:Main, path:Array<{x:Int, y:Int}>, color:UInt):Void {
        if (path.length == 0) return; // No path found
    
        var delay = 200;
        for (i in 0...path.length) {
            var step = path[i];
            haxe.Timer.delay(() -> {
                var tileType = dungeon.getTile(step.x, step.y);
    
                // **Track stats**
                if (tileType == Dungeon.COIN) main.coinsCollected++;
                if (tileType == Dungeon.GEM) main.gemsCollected++;
                if (tileType == Dungeon.TRAP) main.trapsTriggered++;
    
                // **Update UI**
                main.coinText.text = "Coins: " + main.coinsCollected;
                main.gemText.text = "Gems: " + main.gemsCollected;
                main.trapText.text = "Traps: " + main.trapsTriggered;
    
                // **Draw path movement**
                var tile = new Shape();
                tile.graphics.beginFill(color);
                tile.graphics.drawRect(0, 0, tileSize, tileSize);
                tile.graphics.endFill();
                tile.x = step.x * tileSize;
                tile.y = step.y * tileSize + this.offsetY; // Offset for buttons
                main.addChild(tile);
            }, Std.int(i * delay));
        }
    }*/
    private function animatePathOnGrid(main:Main, path:Array<{x:Int, y:Int}>, color:UInt):Void {
        if (path.length == 0) return; // No path found
    
        var delay = 200;
        for (i in 0...path.length) {
            var step = path[i];
            haxe.Timer.delay(() -> {
                var tileType = dungeon.getTile(step.x, step.y);
    
                // **Track stats**
                if (tileType == Dungeon.COIN) main.coinsCollected++;
                if (tileType == Dungeon.GEM) main.gemsCollected++;
                if (tileType == Dungeon.TRAP) main.trapsTriggered++;
    
                // **Update UI**
                main.coinText.text = "Coins: " + main.coinsCollected;
                main.gemText.text = "Gems: " + main.gemsCollected;
                main.trapText.text = "Traps: " + main.trapsTriggered;
    
                // **Draw semi-transparent path overlay**
                var overlay = new Shape();
                overlay.graphics.beginFill(color, 0.5); // 50% transparency
                overlay.graphics.drawRect(0, 0, tileSize, tileSize);
                overlay.graphics.endFill();
                overlay.x = step.x * tileSize;
                overlay.y = step.y * tileSize + this.offsetY; // Offset for buttons
                main.addChild(overlay);
    
            }, Std.int(i * delay));
        }
    }
          
}
