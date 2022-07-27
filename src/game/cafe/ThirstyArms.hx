package game.cafe;

import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.System;
import flambe.animation.AnimatedFloat;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;

using game.SpriteUtil;

class ThirstyArms extends Component {
	public function new(pack:AssetPack, width:Int, height:Int) {
		this.init(pack, width, height);
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

	public function bindTo(anchorX:AnimatedFloat, anchorY:AnimatedFloat, rotation:AnimatedFloat) {
		this._root.get(Sprite).anchorX.bindTo(anchorX);
		this._root.get(Sprite).anchorY.bindTo(anchorY);
		this._root.get(Sprite).rotation.bindTo(rotation);
	}

	public function wave():ThirstyArms {
		this._right.get(ThirstyArm).wave();
		return this;
	}

	public function slam():ThirstyArms {
		this._right.get(ThirstyArm).slam();
		return this;
	}

	public function success():ThirstyArms {
		this._left.get(ThirstyArm).success();
		this._right.get(ThirstyArm).success();
		return this;
	}

	public function reset():ThirstyArms {
		this._left.get(ThirstyArm).reset();
		this._right.get(ThirstyArm).reset();
		return this;
	}

	public function init(pack:AssetPack, width:Int, height:Int) {
		this._root = new Entity().add(new Sprite().setXY(width / 2, height - 420));

		var x = 230;
		var y = 180;
		this._left = new Entity().add(new ThirstyArm(pack, -x + 10, y, false));
		this._right = new Entity().add(new ThirstyArm(pack, x + 10, y, true));

		this._root //
			.addChild(this._right).addChild(this._left); //
	}

	private var _root:Entity;
	private var _left:Entity;
	private var _right:Entity;
}

class ThirstyArm extends Component {
	public var isStale:Bool = false;

	public function new(pack:AssetPack, x:Float, y:Float, isFlipped:Bool) {
		this.init(pack, x, y);
		this._isFlipped = isFlipped;
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onStart() {
		var offset = this._isFlipped ? 260 : -260;
		var x = System.stage.width / 2 + offset;
		var y = System.stage.height / 2 + 180;
		this._startX = this._viewX = x;
		this._startY = this._viewY = y;
	}

	public function reset() {
		this._viewX = this._startX;
		this._viewY = this._startY;
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
		var upperSprite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);
		ThirstyArmActions.wave(() -> {
			this.isStale = false;
		}, this._root, upperSprite, lowerSprite, this._isFlipped);
		return this;
	}

	public function slam():ThirstyArm {
		this.isStale = true;
		var upperSprite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);
		ThirstyArmActions.slam(() -> {
			this.isStale = false;
		}, this._root, upperSprite, lowerSprite, this._isFlipped);
		return this;
	}

	public function success():ThirstyArm {
		this.isStale = true;
		var upperSprite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);
		ThirstyArmActions.success(() -> {
			this.isStale = false;
		}, this._root, upperSprite, lowerSprite, this._isFlipped);
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
		ThirstyArmActions.calcAngles(local.x, local.y, this._isFlipped);
		upperSpite.setRotation(ThirstyArmActions.upperAngle);
		lowerSprite.setRotation(ThirstyArmActions.lowerAngle);
	}

	private inline function getAngle(x:Float, y:Float):Float {
		return Math.atan2(y, x);
	}

	public function init(pack:AssetPack, x:Float, y:Float) {
		this._root = new Entity().add(new Sprite().setXY(x, y));
		this._upper = new Entity() //
			.add(new ImageSprite(pack.getTexture("body/armTop")) //
				.setAnchor(ThirstyArmActions.UPPERARM_WIDTH / 2, 0));
		this._lower = new Entity() //
			.add(new ImageSprite(pack.getTexture("body/armBottom")) //
				.setXY(ThirstyArmActions.UPPERARM_WIDTH / 2, ThirstyArmActions.SEGMENT_LENGTH_TOP) //
				.setAnchor(ThirstyArmActions.LOWERARM_WIDTH / 2, ThirstyArmActions.ARM_OVERLAP));

		this._hand = new Entity().add(new Sprite().setXY(ThirstyArmActions.LOWERARM_WIDTH / 2, ThirstyArmActions.SEGMENT_LENGTH_BOTTOM));
		this._hand.addChild(new Entity().add(new ImageSprite(pack.getTexture("body/hand")).setAnchor(52, 80)));

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
	private var _startX:Float = 0;
	private var _startY:Float = 0;
}
