package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.MouseEvent;

class Main extends Sprite {
    var story:Story;
    var storyText:TextField;
    var choice1Button:Sprite;
    var choice2Button:Sprite;
    var choice1Text:TextField;
    var choice2Text:TextField;

    public function new() {
        super();
        story = new Story();
        createUI();
        updateUI();
    }

    function createUI():Void {
        // Story text field
        storyText = new TextField();
        storyText.defaultTextFormat = new TextFormat("_sans", 20, 0x000000, true);
        storyText.width = 400;
        storyText.height = 100;
        storyText.wordWrap = true;
        storyText.x = 50;
        storyText.y = 50;
        addChild(storyText);

        // Choice 1 button
        choice1Button = createButton(50, 180);
        choice1Text = createButtonText();
        choice1Button.addChild(choice1Text);
        choice1Button.addEventListener(MouseEvent.CLICK, function(_) {
            story.updateStep("choice1");
            updateUI();
        });
        addChild(choice1Button);

        // Choice 2 button
        choice2Button = createButton(50, 250);
        choice2Text = createButtonText();
        choice2Button.addChild(choice2Text);
        choice2Button.addEventListener(MouseEvent.CLICK, function(_) {
            story.updateStep("choice2");
            updateUI();
        });
        addChild(choice2Button);
    }

    function createButton(xPos:Float, yPos:Float):Sprite {
        var button = new Sprite();
        button.graphics.beginFill(0x007BFF);
        button.graphics.drawRoundRect(0, 0, 300, 50, 10);
        button.graphics.endFill();
        button.x = xPos;
        button.y = yPos;
        button.buttonMode = true;
        return button;
    }

    function createButtonText():TextField {
        var text = new TextField();
        text.defaultTextFormat = new TextFormat("_sans", 18, 0xFFFFFF, true);
        text.width = 300;
        text.height = 50;
        text.wordWrap = true;
        text.selectable = false;
        text.x = 10;
        text.y = 10;
        return text;
    }

    function updateUI():Void {
        var step = story.getCurrentStep();
        storyText.text = step.text;
        choice1Text.text = step.choice1;
        choice2Text.text = step.choice2;

        // Hide buttons if reached "exit"
        if (story.currentStep == "exit") {
            choice1Button.visible = false;
            choice2Button.visible = false;
        } else {
            choice1Button.visible = true;
            choice2Button.visible = true;
        }
    }
}
