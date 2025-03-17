package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Lib;

class Main extends Sprite {
    public function new() {
        super();
        var bmp = generatePerlinNoise(200, 200);
        addChild(bmp);
    }

    function generatePerlinNoise(width:Int, height:Int):Bitmap {
        var bmpData = new BitmapData(width, height, false, 0x000000);

        for (x in 0...width) {
            for (y in 0...height) {
                var noiseValue = perlin2D(x / 20, y / 20);
                var brightness = Std.int((noiseValue + 1) * 127.5);
                var color = (brightness << 16) | (brightness << 8) | brightness;
                bmpData.setPixel(x, y, color);
            }
        }
        return new Bitmap(bmpData);
    }

    function perlin2D(x:Float, y:Float):Float {
        var xi:Int = Std.int(Math.floor(x)) & 255;
        var yi:Int = Std.int(Math.floor(y)) & 255;
        //var xi:Int = Std.int(Math.floor(x)) % 256;
        //var yi:Int = Std.int(Math.floor(y)) % 256;
        var xf:Float = x - Math.floor(x);
        var yf:Float = y - Math.floor(y);

        var u:Float = fade(xf);
        var v:Float = fade(yf);

        var aa = grad(hash(xi, yi), xf, yf);
        var ab = grad(hash(xi, yi + 1), xf, yf - 1);
        var ba = grad(hash(xi + 1, yi), xf - 1, yf);
        var bb = grad(hash(xi + 1, yi + 1), xf - 1, yf - 1);
        /*
        var aa = grad(hash(Std.int(xi), Std.int(yi)), xf, yf);
        var ab = grad(hash(Std.int(xi), Std.int(yi + 1)), xf, yf - 1);
        var ba = grad(hash(Std.int(xi + 1), yi), xf - 1, yf);
        var bb = grad(hash(Std.int(xi + 1), Std.int(yi + 1)), xf - 1, yf - 1);
        */
        var x1 = lerp(aa, ba, u);
        var x2 = lerp(ab, bb, u);
        return lerp(x1, x2, v);
    }

    function fade(t:Float):Float {
        return t * t * t * (t * (t * 6 - 15) + 10); // Ken Perlin's smoothing function
    }

    function lerp(a:Float, b:Float, t:Float):Float {
        return a + t * (b - a);
    }

    function grad(hash:Int, x:Float, y:Float):Float {
        var h = hash & 3;
        var u = h < 2 ? x : y;
        var v = h < 2 ? y : x;
        return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
    }

    function hash(x:Int, y:Int):Int {
        var seed:Int = 723; // Keep seed an Int
        var hx:Int = ((x * 15731) ^ (y * 789221) ^ seed) & 0x7FFFFFFF; 
        return hx; 
    }
}
