package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;
import motion.Actuate; // Animation library

class Main extends Sprite {
    var background:Shape;
    var promptText:TextField;
    var button:Sprite;
    
    var characterNames:Array<String> = ["Aria", "Kai", "Lysander", "Seraphina", "Juno"];
    var locations:Array<String> = ["a dark forest", "an abandoned temple", "a bustling space station", "a frozen wasteland"];
    var conflicts:Array<String> = ["must find a lost artifact", "is pursued by a relentless bounty hunter", "is trapped in a time loop", "discovers an ancient prophecy"];
    var actions:Array<String> = ["before it's too late.", "without revealing their true identity.", "while uncovering a dark conspiracy.", "before an impending catastrophe."];

    public function new() {
        super();

        // Create a gradient background
        createBackground();

        // Set up text field
        promptText = new TextField();
        promptText.width = 500;
        promptText.height = 200;
        promptText.x = 50;
        promptText.y = 80;
        promptText.defaultTextFormat = new TextFormat("_sans", 22, 0xFFFFFF, true);
        promptText.multiline = true;
        promptText.wordWrap = true;
        promptText.alpha = 0; // Start hidden
        addChild(promptText);

        // Create a button
        createButton();

        // Generate the first prompt
        generatePrompt();
    }

    function createBackground():Void {
        background = new Shape();
        var g = background.graphics;
        g.beginGradientFill("linear", [0x282C35, 0x3B4252], [1, 1], [0, 255]);
        g.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
        g.endFill();
        addChild(background);
    }

    function createButton():Void {
        button = new Sprite();
        var g = button.graphics;
        g.beginFill(0xFFC107); // Yellow button
        g.drawRoundRect(0, 0, 180, 50, 15);
        g.endFill();

        var buttonText = new TextField();
        buttonText.defaultTextFormat = new TextFormat("_sans", 18, 0x000000, true);
        buttonText.text = "New Story";
        buttonText.width = 180;
        buttonText.height = 50;
        buttonText.selectable = false;
        buttonText.x = 10;
        buttonText.y = 10;

        button.x = (Lib.current.stage.stageWidth - 180) / 2;
        button.y = 300;
        button.buttonMode = true;
        button.addEventListener(MouseEvent.CLICK, function(_) generatePrompt());

        button.addChild(buttonText);
        addChild(button);
    }

    function generatePrompt():Void {
        var character = getRandom(characterNames);
        var location = getRandom(locations);
        var conflict = getRandom(conflicts);
        var action = getRandom(actions);

        var story = character + " in " + location + " " + conflict + " " + action;

        // Apply animation effect
        Actuate.tween(promptText, 0.5, { alpha: 0 }).onComplete(function() {
            promptText.text = story;
            Actuate.tween(promptText, 0.5, { alpha: 1 });
        });
    }

    function getRandom(array:Array<String>):String {
        return array[Std.random(array.length)];
    }
}
