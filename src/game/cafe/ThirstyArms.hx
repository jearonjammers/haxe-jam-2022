package game.cafe;

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

	public function wave():ThirstyArms {
		this._right.get(ThirstyArm).wave();
		return this;
	}

	public function slam():ThirstyArms {
		this._right.get(ThirstyArm).slam();
		return this;
	}

	public function init(width:Int, height:Int) {
		this._root = new Entity().add(new Sprite().setXY(width / 2, height - 420));

		this._left = new Entity().add(new ThirstyArm(-150, 0, false).setTarget(width - 200, 400));
		this._right = new Entity().add(new ThirstyArm(150, 0, true).setTarget(width + 200, 700));

		this._root //
			.addChild(this._right)
			.addChild(this._left); //
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
		return this;
	}

	public function wave():ThirstyArm {
		this.isStale = true;

		calcAngles(200, -430);
		var angleTop1 = _upperAngle;
		var angleBottom1 = _lowerAngle;
		calcAngles(200, -230);
		var angleTop2 = _upperAngle;
		var angleBottom2 = _lowerAngle;

		var upperSpite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);
		upperSpite.rotation._ = angleTop1;
		lowerSprite.rotation._ = angleBottom1;
		this._root.add(new Script()).get(Script).run(new Sequence([
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
			new CallFunction(() -> {
				this.isStale = false;
			})
		]));

		return this;
	}

	public function slam():ThirstyArm {
		this.isStale = true;

		calcAngles(300, 230);
		var angleTop1 = _upperAngle;
		var angleBottom1 = _lowerAngle;
		calcAngles(300, -730);
		var angleTop2 = _upperAngle;
		var angleBottom2 = _lowerAngle;

		var upperSpite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);
		upperSpite.rotation._ = angleTop1;
		lowerSprite.rotation._ = angleBottom1;
		this._root.add(new Script()).get(Script).run(new Sequence([
			new Parallel([
				new AnimateTo(upperSpite.rotation, angleTop2, 0.5, Ease.cubeIn),
				new AnimateTo(lowerSprite.rotation, angleBottom2, 0.5, Ease.cubeIn),
			]),
			new Parallel([
				new AnimateTo(upperSpite.rotation, angleTop1, 0.135, Ease.bounceOut),
				new AnimateTo(lowerSprite.rotation, angleBottom1, 0.135, Ease.bounceOut),
			]),
			new Delay(0.5),
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
		if (isStale) {
			return;
		}
		var rootSpr = this._root.get(Sprite);
		var upperSpite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);

		var local = rootSpr.localXY(this._viewX, this._viewY);
		calcAngles(local.x, local.y);
		upperSpite.setRotation(_upperAngle);
		lowerSprite.setRotation(_lowerAngle);
	}

	private function calcAngles(localX:Float, localY:Float) {
		_scratchLocal.x = localX;
		_scratchLocal.y = localY;
		var rawAngle = getAngle(_scratchLocal.x, _scratchLocal.y);
		var isReflected = reflectAngle(MathUtil.quadrant(rawAngle));

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
					_upperAngle = FMath.toDegrees(MathUtil.reflectAngle(angleA, true));
					_lowerAngle = FMath.toDegrees(MathUtil.reflectAngle(angleB, false));
				} else {
					_upperAngle = FMath.toDegrees(angleA);
					_lowerAngle = FMath.toDegrees(angleB);
				}
			}
		} else {
			_upperAngle = FMath.toDegrees(rawAngle) - 90;
			_lowerAngle = 0;
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
	private var _upperAngle:Float = 0;
	private var _lowerAngle:Float = 0;
	private var _scratchLocal:Point = new Point();

	private static var SEGMENT_LENGTH = 290;
	private static var UPPERARM_WIDTH = 85;
	private static var LOWERARM_WIDTH = 80;
	private static var ARM_OVERLAP = 5;
	private static var HAND_DIM = 90;
	private static var REACH = SEGMENT_LENGTH * 2 - ARM_OVERLAP;
}
