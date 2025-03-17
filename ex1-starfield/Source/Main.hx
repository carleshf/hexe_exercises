package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.Lib;

class Main extends Sprite {
    var stars:Array<Shape>; // Array to store stars
    var numStars:Int = 100; // Number of stars

	public function new() {
		super();
		stars = [];
        createStars();
        addEventListener(Event.ENTER_FRAME, update);
	}

	function createStars():Void {
        for (i in 0...numStars) {
            var star = new Shape();
            star.graphics.beginFill(0x7BC8D6); // White stars
            star.graphics.drawCircle(0, 0, Math.random() * 2 + 1); // Random size (1-3 pixels)
            star.graphics.endFill();

            star.x = Math.random() * Lib.current.stage.stageWidth;
            star.y = Math.random() * Lib.current.stage.stageHeight;

            stars.push(star);
            addChild(star);
        }
    }

	function update(event:Event):Void {
        for (star in stars) {
            star.y += 2; // Move stars downward

            if (star.y > Lib.current.stage.stageHeight) {
                star.y = 0; // Reset to top
                star.x = Math.random() * Lib.current.stage.stageWidth;
            }
        }
    }
}
