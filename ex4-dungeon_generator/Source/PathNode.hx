package;

class PathNode {
    public var x:Int;
    public var y:Int;
    public var g:Int; // Cost from start node
    public var h:Int; // Heuristic (distance to goal)
    public var f:Int; // Total cost (g + h)
    public var parent:Null<PathNode>; // Reference to parent node

    public function new(x:Int, y:Int, g:Int = 0, h:Int = 0, parent:Null<PathNode> = null) {
        this.x = x;
        this.y = y;
        this.g = g;
        this.h = h;
        this.f = g + h;
        this.parent = parent;
    }
}
