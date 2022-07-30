package game.cafe;

import flambe.util.Value;
import flambe.math.Point;
import flambe.animation.Sine;
import flambe.Disposer;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.System;
import flambe.animation.AnimatedFloat;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;

using game.SpriteUtil;

class ThirstyArms extends Component {
	public static var INVALID_REACH = 99999;
	public var isAvailable:Bool = true;
	public var canReach(get, null):Bool;
	public var reachX:Value<Float>;
	public var reachY:Value<Float>;

	public function new(pack:AssetPack, width:Float, height:Float) {
		this.reachX = new Value(0.0);
		this.reachY = new Value(0.0);
		this.init(pack, width, height);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
		_disposer.dispose();
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

	private function get_canReach():Bool {
		return this._left.get(ThirstyArm).canReach;
	}

	private function init(pack:AssetPack, width:Float, height:Float) {
		this._root = new Entity().add(new Sprite().setXY(width / 2, height - 420));

		var x = 230;
		var y = 180;
		this._left = new Entity().add(new ThirstyArm(pack, -x + 10, y, false));
		this._right = new Entity().add(new ThirstyArm(pack, x + 10, y, true));

		this._root //
			.addChild(this._right).addChild(this._left); //

		_disposer = new Disposer();
		_disposer.add(this._left.get(ThirstyArm).reachX.changed.connect((to, _) -> {
			this.reachX._ = to;
		}));
		_disposer.add(this._left.get(ThirstyArm).reachY.changed.connect((to, _) -> {
			this.reachY._ = to;
		}));

		// this.reachX.chab
	}

	private var _root:Entity;
	private var _left:Entity;
	private var _right:Entity;
	private var _disposer:Disposer;
}

class ThirstyArm extends Component {
	public var isStale:Bool = false;
	public var canReach(get, null):Bool;
	public var reachX:Value<Float>;
	public var reachY:Value<Float>;

	public function new(pack:AssetPack, x:Float, y:Float, isFlipped:Bool) {
		this._isFlipped = isFlipped;
		this.reachX = new Value(0.0);
		this.reachY = new Value(0.0);
		this.init(pack, x, y);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
		this._disposer.dispose();
	}

	override function onUpdate(dt:Float) {
		if (this._isDown) {
			this.reaching();
		} else {
			this._idleAnim.update(dt);
			this.idleing();
		}
	}

	private function get_canReach():Bool {
		return this._angles.canReach;
	}

	private function setTarget(viewX:Float, viewY:Float):ThirstyArm {
		this._viewX = viewX;
		this._viewY = viewY;
		return this;
	}

	public function wave():ThirstyArm {
		this.isStale = true;
		var upperSprite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);
		ArmUtil.wave(() -> {
			this.isStale = false;
		}, this._root, upperSprite, lowerSprite, this._angles, this._isFlipped);
		return this;
	}

	public function slam():ThirstyArm {
		this.isStale = true;
		var upperSprite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);
		ArmUtil.slam(() -> {
			this.isStale = false;
		}, this._root, upperSprite, lowerSprite, this._angles, this._isFlipped);
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

	private function reaching() {
		if (isStale) {
			return;
		}
		var rootSpr = this._root.get(Sprite);
		var upperSpite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);

		var local = rootSpr.localXY(this._viewX, this._viewY);
		this.reachX._ = local.x;
		this.reachY._ = local.y;
		ArmUtil.calcAngles(local.x, local.y, this._angles, this._isFlipped);
		upperSpite.setRotation(_angles.top);
		lowerSprite.setRotation(_angles.bottom);
	}

	private function idleing() {
		var upperSpite = this._upper.get(Sprite);
		var lowerSprite = this._lower.get(Sprite);
		this.reachX._ = ThirstyArms.INVALID_REACH;
		this.reachY._ = ThirstyArms.INVALID_REACH;
		ArmUtil.calcAngles(0, this._idleAnim._, this._angles, this._isFlipped);
		upperSpite.setRotation(_angles.top);
		lowerSprite.setRotation(_angles.bottom);
	}

	private function init(pack:AssetPack, x:Float, y:Float) {
		this._disposer = new Disposer();
		this._root = new Entity().add(new Sprite().setXY(x, y));
		this._upper = new Entity() //
			.add(new ImageSprite(pack.getTexture("cafe/body/armTop")) //
				.setAnchor(ArmUtil.UPPERARM_WIDTH / 2, 0));
		this._lower = new Entity() //
			.add(new ImageSprite(pack.getTexture("cafe/body/armBottom")) //
				.setXY(ArmUtil.UPPERARM_WIDTH / 2, ArmUtil.SEGMENT_LENGTH_TOP) //
				.setAnchor(ArmUtil.LOWERARM_WIDTH / 2, ArmUtil.ARM_OVERLAP));

		this._idleAnim.behavior = new Sine(-500, -400, 0.5);

		this._root.addChild(this._upper);
		this._upper.addChild(this._lower);
		this._lower.addChild(_elbowPoint = new Entity().add(new Sprite()));

		if (!this._isFlipped) {
			this._disposer.add(System.pointer.down.connect(e -> {
				this._viewX = e.viewX;
				this._viewY = e.viewY;
				this._isDown = true;
			}));

			this._disposer.add(System.pointer.move.connect(e -> {
				if (this._isDown) {
					this._viewX = e.viewX;
					this._viewY = e.viewY;
				}
			}));

			this._disposer.add(System.pointer.up.connect(e -> {
				if (this._isDown) {
					this._isDown = false;
					this._viewX = e.viewX;
					this._viewY = e.viewY;
				}
			}));
		}
	}

	private var _root:Entity;
	private var _upper:Entity;
	private var _lower:Entity;
	private var _elbowPoint:Entity;
	// private var _hand:Entity;
	private var _isFlipped:Bool;
	private var _viewX:Float = 0;
	private var _viewY:Float = 0;
	private var _isDown:Bool = false;
	private var _idleAnim = new AnimatedFloat(0);
	private var _disposer:Disposer;
	private var _angles:{top:Float, bottom:Float, canReach:Bool} = {top: 0, bottom: 0, canReach: false};
}
