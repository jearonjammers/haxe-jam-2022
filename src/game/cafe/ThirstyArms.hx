package game.cafe;

import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;

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
		this._right = new Entity().add(new ThirstyArm(150, 0, true).setTarget(width + 200, 700));

		this._root //
			.addChild(this._left) //
			.addChild(this._right);
	}

	private var _root:Entity;
	private var _left:Entity;
	private var _right:Entity;
}

class ThirstyArm extends Component {
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

	private function updateReach() {
		var rootSpr = this._root.get(Sprite);
		var upperSpite = this._upper.get(Sprite);

		var local = rootSpr.localXY(this._viewX, this._viewY);
		var angleDeg = this._isFlipped ? rotFlip(local.x, local.y) : rotNorm(local.x, local.y);
		var distance = local.distanceTo(0, 0);
		upperSpite.setRotation(angleDeg - 90);
	}

	private inline function rotFlip(x:Float, y:Float):Float {
		return Math.atan2(y, x) * 180 / Math.PI;
	}

	private inline function rotNorm(x:Float, y:Float):Float {
		return Math.atan2(y, x) * 180 / Math.PI;
	}

	public function init(x:Float, y:Float) {
		this._root = new Entity().add(new Sprite().setXY(x, y));
		this._upper = new Entity() //
			.add(new FillSprite(0xff0000, UPPERARM_WIDTH, UPPERARM_LENGTH) //
				.setAnchor(UPPERARM_WIDTH / 2, ARM_OVERLAP));
		this._lower = new Entity() //
			.add(new FillSprite(0xffaaaa, LOWERARM_WIDTH, LOWERARM_LENGTH) //
				.setXY(UPPERARM_WIDTH / 2, UPPERARM_LENGTH - ARM_OVERLAP) //
				.setAnchor(LOWERARM_WIDTH / 2, ARM_OVERLAP));
		this._hand = new Entity() //
			.add(new FillSprite(0xffdddd, HAND_DIM, HAND_DIM) //
				.setXY(LOWERARM_WIDTH / 2, LOWERARM_LENGTH - ARM_OVERLAP) //
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

	private static var UPPERARM_LENGTH = 240;
	private static var UPPERARM_WIDTH = 85;
	private static var LOWERARM_LENGTH = 200;
	private static var LOWERARM_WIDTH = 80;
	private static var ARM_OVERLAP = 5;
	private static var HAND_DIM = 90;
}
