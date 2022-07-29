package game.runner;

import flambe.animation.Sine;
import flambe.animation.AnimatedFloat;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class PersonLeg extends Component {
	public function new(pack:AssetPack, isFront:Bool) {
		this._isFront = isFront;
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	override function onUpdate(dt:Float) {
		_progress.update(dt);
		setCyclePercent(_progress._);
	}

	public function move(type:PersonMoveType, time:Float) {
		this._type = type;
		switch type {
			case Jump:
				_progress.behavior = _isFront ? new Sine(1, -1, time) : new Sine(-1, 1, time);
			case Crouch:
				_progress.behavior = _isFront ? new Sine(1, -1, time) : new Sine(-1, 1, time);
			case Walk:
				_progress.behavior = _isFront ? new Sine(1, -1, time) : new Sine(-1, 1, time);
			case Surf:
				_progress.behavior = new Sine(0, 0, time);
			case Idle:
				_progress.behavior = new Sine(0, 0, time);
		}
	}

	public function setBalance(balance:Float):Void {
		this._balance = balance;
	}

	private function setCyclePercent(p:Float) {
		var JUMP_OFFSET_TOP = -60;

		var CROUCH_OFFSET_TOP = 60;
		var CROUCH_OFFSET_BOTTOM = 110;
		var SHOE_OFFSET = -48;
		_topPivot.rotation._ = switch [p >= 0, _type] {
			case [true, Jump]: _isFront ? p * -10 - JUMP_OFFSET_TOP : p * -10 - JUMP_OFFSET_TOP;
			case [true, Crouch]: p * -60 - CROUCH_OFFSET_TOP;
			case [true, Walk]: p * -60;
			case [true, Surf]: _isFront ? -20 : 20;
			case [true, Idle]: 0;
			//
			case [false, Jump]: _isFront ? p * -10 - JUMP_OFFSET_TOP : p * -10 - JUMP_OFFSET_TOP;
			case [false, Crouch]: p * -10 - CROUCH_OFFSET_TOP;
			case [false, Walk]: p * -10;
			case [false, Surf]: _isFront ? -20 : 20;
			case [false, Idle]: 0;
		}
		_bottom.rotation._ = switch [p >= 0, _type] {
			case [true, Jump]: p * 10;
			case [true, Crouch]: p * 60 + CROUCH_OFFSET_BOTTOM;
			case [true, Walk]: p * 60;
			case [true, Surf]: 0;
			case [true, Idle]: 0;
			//
			case [false, Jump]: p * -5;
			case [false, Crouch]: p * -10 + CROUCH_OFFSET_BOTTOM;
			case [false, Walk]: p * -10;
			case [false, Surf]: 0;
			case [false, Idle]: 0;
		}
		var footBalance = this._balance;
		_foot.rotation._ = switch [p >= 0, _type] {
			case [true, Jump]: 0;
			case [true, Crouch]: p * 5 + SHOE_OFFSET + footBalance;
			case [true, Walk]: p * 5 + footBalance;
			case [true, Surf]: (_isFront ? 20 : -20) + footBalance;
			case [true, Idle]: 0;
			//
			case [false, Jump]: 0;
			case [false, Crouch]: p * 15 + SHOE_OFFSET + footBalance;
			case [false, Walk]: p * 15 + footBalance;
			case [false, Surf]: (_isFront ? 20 : -20) + footBalance;
			case [false, Idle]: 0;
		}
	}

	private function init(pack:AssetPack) {
		var texName = _isFront ? "runner/body/pantFront" : "runner/body/pantBack";
		var x = _isFront ? -10 : 10;
		this._root = new Entity() //
			.add(_topPivot = new Sprite().setXY(x, 0)) //
			.addChild(new Entity() //
				.add(_bottom = new ImageSprite(pack.getTexture("runner/body/leg")) //
					.setAnchor(7, 10).setXY(-3, 78)) //
				.addChild(new Entity() //
					.add(_foot = new ImageSprite(pack.getTexture("runner/body/shoe")) //
						.setAnchor(8, 5) //
						.setXY(2, 110)))) //
			.addChild(new Entity() //
				.add(_top = new ImageSprite(pack.getTexture(texName)) //
					.setAnchor(14, 15))); //
	}

	private var _root:Entity;
	private var _topPivot:Sprite;
	private var _top:Sprite;
	private var _bottom:Sprite;
	private var _foot:Sprite;
	private var _isFront:Bool;
	private var _type:PersonMoveType = Walk;
	private var _progress = new AnimatedFloat(0);
	private var _balance:Float = 0;
}
