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

class ThirstyArmActions extends Component {
	public static var upperAngle:Float = 0;
	public static var lowerAngle:Float = 0;
	public static inline var SEGMENT_LENGTH = 310;
	public static inline var UPPERARM_WIDTH = 85;
	public static inline var LOWERARM_WIDTH = 80;
	public static inline var ARM_OVERLAP = 5;
	public static inline var HAND_DIM = 90;
	public static inline var REACH = SEGMENT_LENGTH * 2 - ARM_OVERLAP;

	public static function wave(onComplete:Void->Void, root :Entity, upperSpite:Sprite, lowerSprite:Sprite, isFlipped:Bool):Void {
		calcAngles(200, -430, isFlipped);
		var angleTop1 = upperAngle;
		var angleBottom1 = lowerAngle;
		calcAngles(200, -230, isFlipped);
		var angleTop2 = upperAngle;
		var angleBottom2 = lowerAngle;

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

	public function success(onComplete:Void->Void, root :Entity, upperSprite:Sprite, lowerSprite:Sprite, isFlipped:Bool):Void {
		var rootSpr = root.get(Sprite);

		var local1 = rootSpr.localXY(System.stage.width / 2 + 70, System.stage.height / 2 - 150);
		calcAngles(local1.x, local1.y, isFlipped);
		var angleTop1 = MathUtil.normDegrees(upperAngle);
		var angleBottom1 = MathUtil.normDegrees(lowerAngle);
		var local2 = rootSpr.localXY(System.stage.width / 2 + 70, System.stage.height / 2 - 75);
		calcAngles(local2.x, local2.y, isFlipped);
		var angleTop2 = MathUtil.normDegrees(upperAngle);
		var angleBottom2 = MathUtil.normDegrees(lowerAngle);

		var local3 = rootSpr.localXY(System.stage.width / 2 - 70, System.stage.height / 2 - 150);
		calcAngles(local3.x, local3.y, isFlipped);
		var angleTop3 = MathUtil.normDegrees(upperAngle);
		var angleBottom3 = MathUtil.normDegrees(lowerAngle);
		var local4 = rootSpr.localXY(System.stage.width / 2 - 70, System.stage.height / 2 - 75);
		calcAngles(local4.x, local4.y, isFlipped);
		var angleTop4 = MathUtil.normDegrees(upperAngle);
		var angleBottom4 = MathUtil.normDegrees(lowerAngle);

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

	public static function slam(onComplete:Void->Void, root :Entity, upperSprite:Sprite, lowerSprite:Sprite, isFlipped:Bool):Void {
		calcAngles(300, 230, isFlipped);
		var angleTop1 = upperAngle;
		var angleBottom1 = lowerAngle;
		calcAngles(300, -730, isFlipped);
		var angleTop2 = upperAngle;
		var angleBottom2 = lowerAngle;

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

	public static function calcAngles(localX:Float, localY:Float, isFlipped:Bool) {
		_scratchLocal.x = localX;
		_scratchLocal.y = localY;
		var rawAngle = getAngle(_scratchLocal.x, _scratchLocal.y);
		var isReflected = hasReflectAngle(MathUtil.quadrant(rawAngle), isFlipped);

		var _localY = isReflected ? -_scratchLocal.y : _scratchLocal.y;
		var angleRads = getAngle(_scratchLocal.x, _localY);
		var distance = _scratchLocal.distanceTo(0, 0);
		var distRemain = REACH - distance;
		if (distRemain > 0) {
			var overlap = ARM_OVERLAP / 2;
			var solve = MathUtil.solveTriangle(SEGMENT_LENGTH - overlap, SEGMENT_LENGTH - overlap, distance);
			if (solve != null) {
				var angleA = angleRads - 1.5708 - solve.a;
				var angleB = solve.a + solve.b;

				if (isReflected) {
					upperAngle = FMath.toDegrees(MathUtil.reflectAngle(angleA, true));
					lowerAngle = FMath.toDegrees(MathUtil.reflectAngle(angleB, false));
				} else {
					upperAngle = FMath.toDegrees(angleA);
					lowerAngle = FMath.toDegrees(angleB);
				}
			}
		} else {
			upperAngle = FMath.toDegrees(rawAngle) - 90;
			lowerAngle = 0;
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
