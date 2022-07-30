package game.cafe;

import flambe.System;
import flambe.script.Repeat;
import flambe.math.Point;
import flambe.script.Delay;
import flambe.script.Parallel;
import flambe.animation.Ease;
import flambe.script.CallFunction;
import flambe.script.AnimateTo;
import flambe.script.Sequence;
import flambe.script.Script;
import flambe.math.FMath;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;
import game.MathUtil;

using game.SpriteUtil;

class ArmUtil {
	public static inline var SEGMENT_LENGTH_TOP = 392;
	public static inline var SEGMENT_LENGTH_BOTTOM = 400;
	public static inline var UPPERARM_WIDTH = 78;
	public static inline var LOWERARM_WIDTH = 99;
	public static inline var ARM_OVERLAP = 35;
	public static inline var REACH = SEGMENT_LENGTH_TOP + SEGMENT_LENGTH_BOTTOM - ARM_OVERLAP;

	public static function wave(onComplete:Void->Void, root:Entity, upperSpite:Sprite, lowerSprite:Sprite, angles:{top:Float, bottom:Float, canReach:Bool}, isFlipped:Bool):Void {
		calcAngles(200, -430, angles, isFlipped);
		var angleTop1 = angles.top;
		var angleBottom1 = angles.bottom;
		calcAngles(200, -230, angles, isFlipped);
		var angleTop2 = angles.top;
		var angleBottom2 = angles.bottom;

		upperSpite.rotation._ = angleTop1;
		lowerSprite.rotation._ = angleBottom1;
		root.add(new Script()).get(Script).run(new Sequence([
			new Repeat(new Sequence([
				new Parallel([
					new AnimateTo(upperSpite.rotation, angleTop2, 0.24, Ease.cubeIn),
					new AnimateTo(lowerSprite.rotation, angleBottom2, 0.24, Ease.cubeIn),
				]),
				new Parallel([
					new AnimateTo(upperSpite.rotation, angleTop1, 0.3, Ease.cubeIn),
					new AnimateTo(lowerSprite.rotation, angleBottom1, 0.3, Ease.cubeIn),
				])
			]), 3),
			new Delay(0.5),
			new CallFunction(onComplete)
		]));
	}

	public static function success(onComplete:Void->Void, root:Entity, upperSprite:Sprite, lowerSprite:Sprite, angles:{top:Float, bottom:Float, canReach:Bool},
			isFlipped:Bool):Void {
		var rootSpr = root.get(Sprite);

		var local1 = rootSpr.localXY(System.stage.width / 2 + 70, System.stage.height / 2 - 150);
		calcAngles(local1.x, local1.y, angles, isFlipped);
		var angleTop1 = MathUtil.normDegrees(angles.top);
		var angleBottom1 = MathUtil.normDegrees(angles.bottom);
		var local2 = rootSpr.localXY(System.stage.width / 2 + 70, System.stage.height / 2 - 75);
		calcAngles(local2.x, local2.y, angles, isFlipped);
		var angleTop2 = MathUtil.normDegrees(angles.top);
		var angleBottom2 = MathUtil.normDegrees(angles.bottom);

		var local3 = rootSpr.localXY(System.stage.width / 2 - 70, System.stage.height / 2 - 150);
		calcAngles(local3.x, local3.y, angles, isFlipped);
		var angleTop3 = MathUtil.normDegrees(angles.top);
		var angleBottom3 = MathUtil.normDegrees(angles.bottom);
		var local4 = rootSpr.localXY(System.stage.width / 2 - 70, System.stage.height / 2 - 75);
		calcAngles(local4.x, local4.y, angles, isFlipped);
		var angleTop4 = MathUtil.normDegrees(angles.top);
		var angleBottom4 = MathUtil.normDegrees(angles.bottom);

		upperSprite.rotation._ = angleTop1;
		lowerSprite.rotation._ = angleBottom1;
		root.add(new Script()).get(Script).run(new Sequence([
			new Repeat(new Sequence([
				new Parallel([
					new AnimateTo(upperSprite.rotation, angleTop2, 0.24, Ease.cubeIn),
					new AnimateTo(lowerSprite.rotation, angleBottom2, 0.24, Ease.cubeIn),
				]),
				new Parallel([
					new AnimateTo(upperSprite.rotation, angleTop1, 0.3, Ease.cubeIn),
					new AnimateTo(lowerSprite.rotation, angleBottom1, 0.3, Ease.cubeIn),
				])
			]), 2),
			new Repeat(new Sequence([
				new Parallel([
					new AnimateTo(upperSprite.rotation, angleTop3, 0.24, Ease.cubeIn),
					new AnimateTo(lowerSprite.rotation, angleBottom3, 0.24, Ease.cubeIn),
				]),
				new Parallel([
					new AnimateTo(upperSprite.rotation, angleTop4, 0.3, Ease.cubeIn),
					new AnimateTo(lowerSprite.rotation, angleBottom4, 0.3, Ease.cubeIn),
				])
			]), 2),
			new Delay(0.5),
			new CallFunction(onComplete)
		]));
	}

	public static function slam(onComplete:Void->Void, root:Entity, upperSprite:Sprite, lowerSprite:Sprite, angles:{top:Float, bottom:Float, canReach:Bool},
			isFlipped:Bool):Void {
		calcAngles(300, 230, angles, isFlipped);
		var angleTop1 = angles.top;
		var angleBottom1 = angles.bottom;
		calcAngles(300, -730, angles, isFlipped);
		var angleTop2 = angles.top;
		var angleBottom2 = angles.bottom;

		upperSprite.rotation._ = angleTop1;
		lowerSprite.rotation._ = angleBottom1;
		root.add(new Script()).get(Script).run(new Sequence([
			new Parallel([
				new AnimateTo(upperSprite.rotation, angleTop2, 0.5, Ease.cubeIn),
				new AnimateTo(lowerSprite.rotation, angleBottom2, 0.5, Ease.cubeIn),
			]),
			new Parallel([
				new AnimateTo(upperSprite.rotation, angleTop1, 0.135, Ease.bounceOut),
				new AnimateTo(lowerSprite.rotation, angleBottom1, 0.135, Ease.bounceOut),
			]),
			new Delay(0.5),
			new CallFunction(onComplete)
		]));
	}

	public static function calcAngles(localX:Float, localY:Float, angles:{top:Float, bottom:Float, canReach:Bool}, isFlipped:Bool) {
		_scratchLocal.x = localX;
		_scratchLocal.y = localY;
		var rawAngle = getAngle(_scratchLocal.x, _scratchLocal.y);
		var isReflected = hasReflectAngle(MathUtil.quadrant(rawAngle), isFlipped);

		var _localY = isReflected ? -_scratchLocal.y : _scratchLocal.y;
		var angleRads = getAngle(_scratchLocal.x, _localY);
		var distance = _scratchLocal.distanceTo(0, 0);
		var distRemain = REACH - distance;
		angles.canReach = distRemain > 0;
		if (angles.canReach ) {
			var overlap = ARM_OVERLAP / 2;
			var solve = MathUtil.solveTriangle(SEGMENT_LENGTH_BOTTOM - overlap, SEGMENT_LENGTH_TOP - overlap, distance);
			if (solve != null) {
				var angleA = angleRads - 1.5708 - solve.a;
				var angleB = solve.a + solve.b;

				if (isReflected) {
					angles.top = FMath.toDegrees(MathUtil.reflectAngle(angleA, true));
					angles.bottom = FMath.toDegrees(MathUtil.reflectAngle(angleB, false));
				} else {
					angles.top = FMath.toDegrees(angleA);
					angles.bottom = FMath.toDegrees(angleB);
				}
			}
		} else {
			angles.top = FMath.toDegrees(rawAngle) - 90;
			angles.bottom = 0;
		}
	}

	public static function getAngle(x:Float, y:Float):Float {
		return Math.atan2(y, x);
	}

	private static function hasReflectAngle(q:Int, isFlipped:Bool):Bool {
		var isReflected = false;
		if (!isFlipped) {
			if (q == 0 || q == 1) {
				isReflected = true;
			}
		} else {
			if (q == 3 || q == 2) {
				isReflected = true;
			}
		}
		return isReflected;
	}

	private static var _scratchLocal:Point = new Point();
}
