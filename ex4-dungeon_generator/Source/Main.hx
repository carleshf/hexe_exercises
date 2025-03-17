package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Main extends Sprite {
    static inline var TILE_SIZE:Int = 40;
    var GRID_SIZE:Int = 10;
    var dungeon:Dungeon;
    var pathfinder:Pathfinder;

    var increaseButton:Sprite;
    var decreaseButton:Sprite;
    var pathButton:Sprite;

    public function new() {
        super();
        dungeon = new Dungeon(GRID_SIZE);
        pathfinder = new Pathfinder(dungeon, TILE_SIZE, 70);
        drawDungeon();
        createButtons();
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

    function drawDungeon():Void {
        this.removeChildren();

        // this should go to dungeon class
        var offsetY = 70;
        for (i in 0...GRID_SIZE) {
            for (j in 0...GRID_SIZE) {
                var tile = new Shape();
                tile.graphics.beginFill(getColor(dungeon.getTile(i, j)));
                tile.graphics.drawRect(0, 0, TILE_SIZE, TILE_SIZE);
                tile.graphics.endFill();
                tile.x = i * TILE_SIZE;
                tile.y = j * TILE_SIZE + offsetY;
                addChild(tile);
            }
        }

        // Draw grid (restored from previous version)
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

        if (increaseButton != null) addChild(increaseButton);
        if (decreaseButton != null) addChild(decreaseButton);
        if (pathButton != null) addChild(pathButton);
    }

    function createButton(label:String, x:Float, y:Float, onClick:Void->Void):Sprite {
        // should buttons be a class?
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
    
        button.addEventListener(MouseEvent.CLICK, function(_) onClick());
        return button;
    }    

    function createButtons():Void {
        increaseButton = createButton("Increase Grid", 20, 20, () -> adjustGridSize(1));
        decreaseButton = createButton("Decrease Grid", 200, 20, () -> adjustGridSize(-1));
        pathButton = createButton("Find Path", 380, 20, () -> pathfinder.animatePath(this));

        addChild(increaseButton);
        addChild(decreaseButton);
        addChild(pathButton);
    }

    function adjustGridSize(change:Int):Void {
        var newSize = GRID_SIZE + change;
        if (newSize < 5 || newSize > 20) return; // Limit between 5x5 and 20x20
        GRID_SIZE = newSize;
        
        // Regenerate dungeon and redraw
        dungeon = new Dungeon(GRID_SIZE);
        pathfinder = new Pathfinder(dungeon, TILE_SIZE, 70);
        drawDungeon();
    }
    
}
