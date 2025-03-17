package;

class Dungeon {
    public var size:Int;
    public var grid:Array<Array<Int>>;

    public static inline var EMPTY:Int = 0;
    public static inline var WALL:Int = 1;
    public static inline var START:Int = 3;
    public static inline var EXIT:Int = 4;
    public static inline var TRAP:Int = 5;
    public static inline var COIN:Int = 6;
    public static inline var GEM:Int = 7;

    public function new(size:Int) {
        this.size = size;
        generateGrid();
    }

    function generateGrid():Void {
        grid = [];
        for (i in 0...size) {
            grid.push([]);
            for (j in 0...size) {
                grid[i].push(Std.random(100) < 20 ? WALL : EMPTY);
            }
        }
        grid[0][0] = START;
        grid[size - 1][size - 1] = EXIT;
        ensurePath();
    }

    public function addItems():Void {
        for (i in 0...size) {
            for (j in 0...size) {
                if (grid[i][j] == EMPTY) {
                    var rand = Std.random(100);
                    if (rand < 10) grid[i][j] = TRAP;
                    else if (rand < 20) grid[i][j] = COIN;
                    else if (rand < 25) grid[i][j] = GEM;
                }
            }
        }
    }

    public function getTile(x:Int, y:Int):Int {
        return grid[x][y];
    }

    function ensurePath():Void {
        var queue:Array<{x:Int, y:Int}> = [{x: 0, y: 0}];
        var visited:Array<Array<Bool>> = [];

        for (i in 0...size) {
            visited.push([]);
            for (j in 0...size) visited[i].push(false);
        }

        visited[0][0] = true;
        var directions = [{x: 0, y: 1}, {x: 1, y: 0}, {x: 0, y: -1}, {x: -1, y: 0}];

        while (queue.length > 0) {
            var current = queue.shift();
            if (current.x == size - 1 && current.y == size - 1) return;

            for (dir in directions) {
                var nx = current.x + dir.x;
                var ny = current.y + dir.y;

                if (nx >= 0 && ny >= 0 && nx < size && ny < size && !visited[nx][ny] && grid[nx][ny] != 1) {
                    visited[nx][ny] = true;
                    queue.push({x: nx, y: ny});
                }
            }
        }

        for (i in 0...size) {
            for (j in 0...size) {
                if (!visited[i][j]) grid[i][j] = 0;
            }
        }
    }
}
