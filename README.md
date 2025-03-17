### Exercise 1: Generate a Procedural Starfield (Basic Procedural Generation)

📌 **Goal**: Create a simple procedural starfield, where stars randomly appear on the screen and move downward.

#### 🎯 Concepts Covered:

    Creating a game loop
    Using Math.random()
    Drawing simple graphics procedurally

#### Steps:

    Create an array of stars, each with a random (x, y) position.
    Every frame, move the stars downward.
    When a star reaches the bottom, move it back to the top with a new random x position.
---

### Exercise 2: Procedural Terrain Generation (Perlin Noise)

📌 **Goal**: Generate a simple 2D terrain using Perlin noise.

#### 🎯 Concepts Covered:

    Using Perlin noise for procedural generation
    Drawing shapes dynamically
    Looping through arrays to generate terrain

#### Steps:

    Use Math.random() or a Perlin noise function to generate random height values.
    Draw a series of rectangles (columns) to represent terrain.
    Let the terrain smoothly vary in height to create hills/valleys.

---

## Exercise 3: Randomized Storytelling Prompts

📌 **Goal**: Create a story prompt generator that procedurally generates small narratives.

#### 🎯 Concepts Covered:

    Random text generation
    Combining arrays of words to create sentences
    Using event listeners for interactivity

#### Steps:

    Create arrays for characters, locations, conflicts, and actions.
    Randomly select one element from each array to construct a sentence.
    Display the generated story prompt on the screen when the player clicks a button.

---

### Exercise 4: Procedural Dungeon Room Generator

📌 **Goal**: Create a randomized dungeon room layout, with obstacles and an exit.

#### 🎯 Concepts Covered:

    2D arrays for map representation
    Tile-based procedural generation
    Creating simple pathfinding (optional)

#### Steps:

    Create a grid-based map (e.g., 10x10 tiles).
    Randomly place walls, obstacles, and an exit.
    Ensure there is at least one clear path to the exit (basic pathfinding check).

---

### Exercise 5: Interactive Story with Branching Choices

📌 **Goal**: Build a text-based adventure game where player choices dynamically change the story.

#### 🎯 Concepts Covered:

    State management for story progression
    Creating multiple paths in the story
    Event listeners for interactivity

#### Steps:

    Create a dictionary of story chunks, where each chunk is a paragraph of the story.
    Give the player two choices at each step (e.g., "Go left" or "Go right").
    Clicking a choice updates the story text and moves to the next part.