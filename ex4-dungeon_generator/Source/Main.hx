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
    var safePathButton:Sprite;

    var addItemsButton:Sprite;

    public var coinsCollected:Int = 0; //should encapsulate this
    public var gemsCollected:Int = 0;
    public var trapsTriggered:Int = 0;
    public var coinText:TextField; // should be updated in main and not in dungeon
    public var gemText:TextField;
    public var trapText:TextField;


    public function new() {
        super();
        dungeon = new Dungeon(GRID_SIZE);
        pathfinder = new Pathfinder(dungeon, TILE_SIZE, 100);
        drawDungeon();
        createButtons();
        createHUD();
    }

    /*function getColor(type:Int):UInt {
        return switch (type) {
            case 0: 0xFFFFFF;
            case 1: 0x333333;
            case 3: 0x00FF00;
            case 4: 0xFF0000;
            default: 0xFFFFFF;
        }
    }*/

    function getEmoji(type:Int):String {
        return switch (type) {
            case Dungeon.EMPTY: "⬜";
            case Dungeon.WALL: "⬛";
            case Dungeon.START: "🚪";
            case Dungeon.EXIT: "🏁";
            case Dungeon.TRAP: "⚠️";
            case Dungeon.COIN: "🪙";
            case Dungeon.GEM: "💎";
            default: "⬜";
        }
    }

    // this should go in Dungeon
    function drawDungeon():Void {
        this.removeChildren();
        var offsetY = 100;
    
        for (i in 0...GRID_SIZE) {
            for (j in 0...GRID_SIZE) {
                var tileText = new TextField();
                tileText.defaultTextFormat = new TextFormat("_sans", 30, 0x000000, true);
                tileText.text = getEmoji(dungeon.getTile(i, j));
                tileText.width = TILE_SIZE;
                tileText.height = TILE_SIZE;
                tileText.x = i * TILE_SIZE;
                tileText.y = j * TILE_SIZE + offsetY;
                tileText.selectable = false;
                addChild(tileText);
            }
        }
    
        if (increaseButton != null) addChild(increaseButton);
        if (decreaseButton != null) addChild(decreaseButton);
        if (addItemsButton != null) addChild(addItemsButton);
        if (pathButton != null) addChild(pathButton);
        if (safePathButton != null) addChild(safePathButton);

        if (coinText != null) addChild(coinText);
        if (gemText != null) addChild(gemText);
        if (trapText != null) addChild(trapText);
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
        addItemsButton = createButton("Add Items", 380, 20, () -> {
            dungeon.addItems();
            drawDungeon();
        });
        pathButton = createButton("Find Path", 560, 20, () -> {
            this.coinsCollected = 0;
            this.gemsCollected = 0;
            this.trapsTriggered = 0;
            pathfinder.animateShortesPath(this);
        });
        safePathButton = createButton("Find Safest Path", 740, 20, () -> {
            this.coinsCollected = 0;
            this.gemsCollected = 0;
            this.trapsTriggered = 0;
            pathfinder.animateSafePath(this);
        });

        addChild(increaseButton);
        addChild(decreaseButton);
        addChild(addItemsButton);
        addChild(pathButton);
        addChild(safePathButton);
    }

    function adjustGridSize(change:Int):Void {
        var newSize = GRID_SIZE + change;
        if (newSize < 5 || newSize > 20) return; // Limit between 5x5 and 20x20
        GRID_SIZE = newSize;
        
        // Regenerate dungeon and redraw
        dungeon = new Dungeon(GRID_SIZE);
        pathfinder = new Pathfinder(dungeon, TILE_SIZE, 100);
        drawDungeon();
    }
    
    function createHUD():Void {
        coinText = createStatText("Coins: 0", 20, 70);
        gemText = createStatText("Gems: 0", 200, 70);
        trapText = createStatText("Traps: 0", 380, 70);
        
        addChild(coinText);
        addChild(gemText);
        addChild(trapText);
    }

    function createStatText(label:String, x:Float, y:Float):TextField {
        var text = new TextField();
        text.defaultTextFormat = new TextFormat("_sans", 18, 0x000000, true);
        text.text = label;
        text.width = 150;
        text.height = 30;
        text.x = x;
        text.y = y;
        return text;
    }
}
