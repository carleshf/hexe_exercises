package;

class Dungeon {
    public var size:Int;
    public var grid:Array<Array<Int>>;

    public function new(size:Int) {
        this.size = size;
        generateGrid();
    }

    function generateGrid():Void {
        grid = [];
        for (i in 0...size) {
            grid.push([]);
            for (j in 0...size) {
                grid[i].push(Std.random(100) < 20 ? 1 : 0); // 20% chance for walls
            }
        }
        grid[0][0] = 3; // Start position
        grid[size - 1][size - 1] = 4; // Exit
        ensurePath();
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

    public function getTile(x:Int, y:Int):Int {
        return grid[x][y];
    }
}
