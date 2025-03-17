package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;

class Main extends Sprite {
    var promptText:TextField;
    var characterNames:Array<String> = ["Aria", "Kai", "Lysander", "Seraphina", "Juno"];
    var locations:Array<String> = ["a dark forest", "an abandoned temple", "a bustling space station", "a frozen wasteland"];
    var conflicts:Array<String> = ["must find a lost artifact", "is pursued by a relentless bounty hunter", "is trapped in a time loop", "discovers an ancient prophecy"];
    var actions:Array<String> = ["before it's too late.", "without revealing their true identity.", "while uncovering a dark conspiracy.", "before an impending catastrophe."];

    public function new() {
        super();

        // Set up text field
        promptText = new TextField();
        promptText.width = 400;
        promptText.height = 200;
        promptText.x = 50;
        promptText.y = 100;
        promptText.defaultTextFormat = new TextFormat("_sans", 18, 0x722727, true);
        promptText.multiline = true;
        promptText.wordWrap = true;
        addChild(promptText);

        // Generate the first prompt
        generatePrompt();

        // Listen for clicks to generate new prompts
        stage.addEventListener(MouseEvent.CLICK, function(_) generatePrompt());
    }

    function generatePrompt():Void {
        var character = getRandom(characterNames);
        var location = getRandom(locations);
        var conflict = getRandom(conflicts);
        var action = getRandom(actions);

        var story = character + " in " + location + " " + conflict + " " + action;
        promptText.text = story;
    }

    function getRandom(array:Array<String>):String {
        return array[Std.random(array.length)];
    }
}
