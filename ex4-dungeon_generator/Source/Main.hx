package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;

class Main extends Sprite {
    var GRID_SIZE:Int = 10;
    static inline var TILE_SIZE:Int = 40;
    var dungeon:Array<Array<Int>>;

    var increaseButton:Sprite;
    var decreaseButton:Sprite;

    public function new() {
        super();
        generateDungeon();
        drawDungeon();
        createButtons();
    }

    function generateDungeon():Void {
        dungeon = [];
        for (i in 0...GRID_SIZE) {
            dungeon.push([]);
            for (j in 0...GRID_SIZE) {
                dungeon[i].push(0); // 0 = empty space
            }
        }

        for (i in 0...GRID_SIZE) {
            for (j in 0...GRID_SIZE) {
                if (Std.random(100) < 20) { // 20% chance for walls
                    dungeon[i][j] = 1;
                }
            }
        }

        // Set start and exit points
        dungeon[0][0] = 3; // Start position (3)
        dungeon[GRID_SIZE - 1][GRID_SIZE - 1] = 4; // Exit (4)

        ensurePath();
    }

    function ensurePath():Void {
        var queue:Array<{x:Int, y:Int}> = [{x: 0, y: 0}];
        var visited:Array<Array<Bool>> = [];

        for (i in 0...GRID_SIZE) {
            visited.push([]);
            for (j in 0...GRID_SIZE) {
                visited[i].push(false);
            }
        }

        visited[0][0] = true;
        var directions = [{x: 0, y: 1}, {x: 1, y: 0}, {x: 0, y: -1}, {x: -1, y: 0}];

        while (queue.length > 0) {
            var current = queue.shift();
            if (current.x == GRID_SIZE - 1 && current.y == GRID_SIZE - 1) return;

            for (dir in directions) {
                var nx = current.x + dir.x;
                var ny = current.y + dir.y;

                if (nx >= 0 && ny >= 0 && nx < GRID_SIZE && ny < GRID_SIZE) {
                    if (!visited[nx][ny] && dungeon[nx][ny] != 1) {
                        visited[nx][ny] = true;
                        queue.push({x: nx, y: ny});
                    }
                }
            }
        }

        for (i in 0...GRID_SIZE) {
            for (j in 0...GRID_SIZE) {
                if (!visited[i][j]) dungeon[i][j] = 0;
            }
        }
    }

    function drawDungeon():Void {
        this.removeChildren(); // Clear all previous tiles
    
        var offsetY = 70; // Push dungeon down
    
        for (i in 0...GRID_SIZE) {
            for (j in 0...GRID_SIZE) {
                var tile = new Shape();
                tile.graphics.beginFill(getColor(dungeon[i][j]));
                tile.graphics.drawRect(0, 0, TILE_SIZE, TILE_SIZE);
                tile.graphics.endFill();
                tile.x = i * TILE_SIZE;
                tile.y = j * TILE_SIZE + offsetY;
                addChild(tile);
            }
        }
    
        // Draw grid
        var grid = new Shape();
        grid.graphics.lineStyle(1, 0x000000, 0.5);
        
        for (i in 0...GRID_SIZE + 1) {
            grid.graphics.moveTo(i * TILE_SIZE, offsetY);
            grid.graphics.lineTo(i * TILE_SIZE, GRID_SIZE * TILE_SIZE + offsetY);
        }
        for (j in 0...GRID_SIZE + 1) {
            grid.graphics.moveTo(0, j * TILE_SIZE + offsetY);
            grid.graphics.lineTo(GRID_SIZE * TILE_SIZE, j * TILE_SIZE + offsetY);
        }
        addChild(grid);
    
        // ✅ FIX: Check if buttons exist before re-adding them
        if (increaseButton != null) addChild(increaseButton);
        if (decreaseButton != null) addChild(decreaseButton);
    }
    
    
    

    function getColor(type:Int):UInt {
        return switch (type) {
            case 0: 0xFFFFFF;
            case 1: 0x333333;
            case 3: 0x00FF00;
            case 4: 0xFF0000;
            default: 0xFFFFFF;
        }
    }

    function createButtons():Void {
        increaseButton = createButton("Increase Grid", 20, 20);
        decreaseButton = createButton("Decrease Grid", 200, 20);
    
        increaseButton.addEventListener(MouseEvent.CLICK, function(_) adjustGridSize(1));
        decreaseButton.addEventListener(MouseEvent.CLICK, function(_) adjustGridSize(-1));
    
        addChild(increaseButton);
        addChild(decreaseButton);
    }
    

    function createButton(label:String, x:Float, y:Float):Sprite {
        var button = new Sprite();
        button.graphics.beginFill(0xFFC107);
        button.graphics.drawRoundRect(0, 0, 150, 40, 10);
        button.graphics.endFill();

        var buttonText = new TextField();
        buttonText.defaultTextFormat = new TextFormat("_sans", 16, 0x000000, true);
        buttonText.text = label;
        buttonText.width = 150;
        buttonText.height = 40;
        buttonText.selectable = false;
        buttonText.x = 10;
        buttonText.y = 10;

        button.x = x;
        button.y = y;
        button.buttonMode = true;
        button.addChild(buttonText);

        return button;
    }

    function adjustGridSize(change:Int):Void {
        var newSize = GRID_SIZE + change;
        if (newSize < 5 || newSize > 20) return; // Limit between 5x5 and 20x20
        GRID_SIZE = newSize;
        generateDungeon();
        drawDungeon();
    }
}
