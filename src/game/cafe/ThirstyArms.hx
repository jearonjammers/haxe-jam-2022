package game.cafe;

import flambe.script.Delay;
import flambe.script.Parallel;
import flambe.animation.Ease;
import flambe.script.CallFunction;
import flambe.script.AnimateTo;
import flambe.script.Sequence;
import flambe.script.Script;
import flambe.math.FMath;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;
import game.MathUtil;

using game.SpriteUtil;

class ThirstyArms extends Component {
	public function new(width:Int, height:Int) {
		this.init(width, height);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function setTarget(viewX:Float, viewY:Float):ThirstyArms {
		this._left.get(ThirstyArm).setTarget(viewX, viewY);
		this._right.get(ThirstyArm).setTarget(viewX, viewY);
		return this;
	}

	public function init(width:Int, height:Int) {
		this._root = new Entity().add(new Sprite().setXY(width / 2, height - 420));

		this._left = new Entity().add(new ThirstyArm(-150, 0, false).setTarget(width - 200, 400));
		this._right = new Entity().add(new ThirstyArm(150, 0, true).setTarget(width + 200, 700).wave());

		this._root //
			.addChild(this._left) //
			.addChild(this._right);
	}

	private var _root:Entity;
	private var _left:Entity;
	private var _right:Entity;
}

class ThirstyArm extends Component {
	public var isStale:Bool = false;

	public function new(x:Float, y:Float, isFlipped:Bool) {
		this.init(x, y);
		this._isFlipped = isFlipped;
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	override function onUpdate(dt:Float) {
		this.updateReach();
	}

	public function setTarget(viewX:Float, viewY:Float):ThirstyArm {
		this._viewX = viewX;
		this._viewY = viewY;
		_hasUpdate = true;
		return this;
	}

	public function wave():ThirstyArm {
		this.isStale = true;

		var upperSpite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);
		upperSpite.rotation._ = 210;
		this._root.add(new Script()).get(Script).run(new Sequence([
			new Parallel([
				new AnimateTo(upperSpite.rotation, 260, 0.6, Ease.cubeIn),
				new AnimateTo(lowerSprite.rotation, -100, 0.6, Ease.cubeIn),
			]),
			new Parallel([
				new AnimateTo(upperSpite.rotation, 210, 0.5, Ease.cubeIn),
				new AnimateTo(lowerSprite.rotation, 0, 0.5, Ease.cubeIn),
			]),
			new Parallel([
				new AnimateTo(upperSpite.rotation, 300, 0.6, Ease.cubeIn),
				new AnimateTo(lowerSprite.rotation, -100, 0.6, Ease.cubeIn),
			]),
			new Parallel([
				new AnimateTo(upperSpite.rotation, 210, 0.5, Ease.cubeIn),
				new AnimateTo(lowerSprite.rotation, 0, 0.5, Ease.cubeIn),
			]),
			new Delay(0.4),
			new CallFunction(() -> {
				this.isStale = false;
			})
		]));

		return this;
	}

	private inline function reflectAngle(q:Int):Bool {
		var isReflected = false;
		if (!this._isFlipped) {
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

	private function updateReach() {
		if (!_hasUpdate || isStale) {
			return;
		}
		_hasUpdate = false;
		var rootSpr = this._root.get(Sprite);
		var upperSpite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);

		var local = rootSpr.localXY(this._viewX, this._viewY);
		var rawAngle = getAngle(local.x, local.y);
		var isReflected = reflectAngle(MathUtil.quadrant(rawAngle));

		var localY = isReflected ? -local.y : local.y;
		var angleRads = getAngle(local.x, localY);
		var distance = local.distanceTo(0, 0);
		var distRemain = REACH - distance;
		if (distRemain > 0) {
			var overlap = ARM_OVERLAP / 2;
			var solve = MathUtil.solveTriangle(SEGMENT_LENGTH - overlap, SEGMENT_LENGTH - overlap, distance);
			if (solve != null) {
				var angleA = angleRads - 1.5708 - solve.a;
				var angleB = solve.a + solve.b;

				if (isReflected) {
					upperSpite.setRotation(FMath.toDegrees(MathUtil.reflectAngle(angleA, true)));
					lowerSprite.setRotation(FMath.toDegrees(MathUtil.reflectAngle(angleB, false)));
				} else {
					upperSpite.setRotation(FMath.toDegrees(angleA));
					lowerSprite.setRotation(FMath.toDegrees(angleB));
				}
			}
		} else {
			upperSpite.setRotation(FMath.toDegrees(rawAngle) - 90);
			lowerSprite.setRotation(0);
		}
	}

	private inline function getAngle(x:Float, y:Float):Float {
		return Math.atan2(y, x);
	}

	public function init(x:Float, y:Float) {
		this._root = new Entity().add(new Sprite().setXY(x, y));
		this._upper = new Entity() //
			.add(new FillSprite(0xff0000, UPPERARM_WIDTH, SEGMENT_LENGTH) //
				.setAnchor(UPPERARM_WIDTH / 2, 0));
		this._lower = new Entity() //
			.add(new FillSprite(0xffaaaa, LOWERARM_WIDTH, SEGMENT_LENGTH) //
				.setXY(UPPERARM_WIDTH / 2, SEGMENT_LENGTH) //
				.setAnchor(LOWERARM_WIDTH / 2, ARM_OVERLAP));
		this._hand = new Entity() //
			.add(new FillSprite(0xffdddd, HAND_DIM, HAND_DIM) //
				.setXY(LOWERARM_WIDTH / 2, SEGMENT_LENGTH) //
				.centerAnchor());

		this._root.addChild(this._upper);
		this._upper.addChild(this._lower);
		this._lower.addChild(this._hand);
	}

	private var _root:Entity;
	private var _upper:Entity;
	private var _lower:Entity;
	private var _hand:Entity;
	private var _isFlipped:Bool;
	private var _viewX:Float = 0;
	private var _viewY:Float = 0;
	private var _hasUpdate:Bool = false;

	private static var SEGMENT_LENGTH = 230;
	private static var UPPERARM_WIDTH = 85;
	private static var LOWERARM_WIDTH = 80;
	private static var ARM_OVERLAP = 5;
	private static var HAND_DIM = 90;
	private static var REACH = SEGMENT_LENGTH * 2 - ARM_OVERLAP;
}
