package;

import haxe.ds.StringMap;

class Story {
    public var currentStep:String;
    public var storyMap:StringMap<{ text:String, choice1:String, next1:String, choice2:String, next2:String }>;

    public function new() {
        storyMap = new StringMap();

        // Define story chunks
        storyMap.set("start", {
            text: "You wake up in a dark forest. You see two paths ahead.",
            choice1: "Take the left path",
            next1: "left_path",
            choice2: "Take the right path",
            next2: "right_path"
        });

        storyMap.set("left_path", {
            text: "The path is rocky. You hear a noise behind you.",
            choice1: "Run forward",
            next1: "run_forward",
            choice2: "Turn back",
            next2: "start"
        });

        storyMap.set("right_path", {
            text: "You enter a misty cave. It's cold inside.",
            choice1: "Explore deeper",
            next1: "deep_cave",
            choice2: "Leave the cave",
            next2: "start"
        });

        storyMap.set("run_forward", {
            text: "You find an old cabin with a lantern outside.",
            choice1: "Knock on the door",
            next1: "cabin",
            choice2: "Ignore it and keep running",
            next2: "end"
        });

        storyMap.set("deep_cave", {
            text: "You discover a treasure chest!",
            choice1: "Open it",
            next1: "treasure",
            choice2: "Leave it alone",
            next2: "start"
        });

        storyMap.set("cabin", {
            text: "An old man opens the door. He offers you shelter.",
            choice1: "Accept his offer",
            next1: "end",
            choice2: "Refuse and leave",
            next2: "start"
        });

        storyMap.set("treasure", {
            text: "Inside the chest, you find gold and a mysterious key.",
            choice1: "Take everything",
            next1: "end",
            choice2: "Just take the key",
            next2: "start"
        });

        storyMap.set("end", {
            text: "Your journey has ended. Restart?",
            choice1: "Yes",
            next1: "start",
            choice2: "No",
            next2: "exit"
        });

        currentStep = "start";
    }

    public function getCurrentStep():{ text:String, choice1:String, next1:String, choice2:String, next2:String } {
        return storyMap.get(currentStep);
    }

    public function updateStep(choice:String):Void {
        var step = storyMap.get(currentStep);
        if (step != null) {
            if (choice == "choice1") {
                currentStep = step.next1;
            } else {
                currentStep = step.next2;
            }
        }
    }
}
