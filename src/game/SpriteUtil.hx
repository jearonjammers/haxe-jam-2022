package game;

import flambe.display.Sprite;
import flambe.math.Point;

class SpriteUtil {
	public static function localXY(sprite:Sprite, viewX:Float, viewY:Float):Point {
		var mat = sprite.getViewMatrix();
		if (!mat.inverseTransform(viewX, viewY, SPRITE_SCRATCH)) {
			SPRITE_SCRATCH.set(0, 0);
		}
		return SPRITE_SCRATCH;
	}

	private static var SPRITE_SCRATCH:Point = new Point();
}
