package game;

import flambe.math.FMath;

class MathUtil {
	public static function solveTriangle(a:Float, b:Float, c:Float):Null<{a:Float, b:Float, c:Float}> {
		var angleA = solveAngle(b, c, a);
		var angleB = solveAngle(c, a, b);
		var angleC = solveAngle(a, b, c);
		if (angleA != null && angleB != null && angleC != null) {
			return {a: angleA, b: angleB, c: angleC}
		}
		return null;
	}

	// Returns angle C using law of cosines.
	private static function solveAngle(a:Float, b:Float, c:Float):Null<Float> {
		var temp = (a * a + b * b - c * c) / (2 * a * b);
		if (temp >= -1 && 0.9999999 >= temp)
			return Math.acos(temp);
		else if (1 >= temp) // Explained in https://www.nayuki.io/page/numerically-stable-law-of-cosines
			return Math.sqrt((c * c - (a - b) * (a - b)) / (a * b));
		else
			return null;
	}

	public static function reflectAngle(rad:Float, isX:Bool):Float {
		var c = Math.cos(rad);
		var s = Math.sin(rad);
		return isX ? Math.atan2(s, -c) : Math.atan2(-s, c);
	}

	public static function normDegrees(degrees:Float):Float {
		return (degrees % 360 + 360) % 360;
	}

	public static function quadrant(rad:Float):Int {
		var degrees = normDegrees(FMath.toDegrees(rad));
		if (degrees > 270) {
			return 3;
		} else if (degrees > 180) {
			return 2;
		} else if (degrees > 90) {
			return 1;
		}
		return 0;
	}
}
