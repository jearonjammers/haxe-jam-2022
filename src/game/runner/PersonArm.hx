package game.runner;

import flambe.animation.Ease;
import flambe.animation.Sine;
import flambe.animation.AnimatedFloat;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class PersonArm extends Component {
	public function new(pack:AssetPack, isFront:Bool) {
		_isFront = isFront;
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
		_progress.behavior = _isFront ? new Sine(1, -1, time) : new Sine(-1, 1, time);
	}

	private function setCyclePercent(p:Float) {
		_topPivot.rotation._ = switch [p >= 0, _type] {
			case [true, Jump]: -120 + (_isFront ? p * -5 : p * -5);
			case [true, Crouch]: p * -10 - 90;
			case [true, Walk]: p * -60;
			case [true, Surf]: _isFront ? p * -5 - 80 : p * -5 + 80;
			case [true, Idle]: 0;
			//
			case [false, Jump]: -120 + (_isFront ? p * -5 : p * -5);
			case [false, Crouch]: p * -10 - 90;
			case [false, Walk]: p * -50;
			case [false, Surf]: _isFront ? p * -5 - 80 : p * -5 + 80;
			case [false, Idle]: 0;
		}
		_bottom.rotation._ = switch [p >= 0, _type] {
			case [true, Jump]: 0;
			case [true, Crouch]: p * -70;
			case [true, Walk]: p * -60;
			case [true, Surf]: p * -10;
			case [true, Idle]: 0;
			//
			case [false, Jump]: 0;
			case [false, Crouch]: p * 20;
			case [false, Walk]: p * 50;
			case [false, Surf]: p * 10;
			case [false, Idle]: 0;
		}
		_hand.rotation._ = switch [p >= 0, _type] {
			case [true, Jump]: 0;
			case [true, Crouch]: 0;
			case [true, Walk]: 0;
			case [true, Surf]: 0;
			case [true, Idle]: 0;
			//
			case [false, Jump]: 0;
			case [false, Crouch]: p * 70;
			case [false, Walk]: p * -20;
			case [false, Surf]: p * 10;
			case [false, Idle]: 0;
		}
	}

	private function init(pack:AssetPack) {
		var x = _isFront ? -18 : 14;
		this._root = new Entity() //
			.add(_topPivot = new Sprite().setXY(x, -78)) //
			.addChild(new Entity() //
				.add(_bottom = new ImageSprite(pack.getTexture("runner/body/arm")) //
					.setAnchor(8, 10).setXY(-1, 68)) //
				.addChild(new Entity() //
					.add(_hand = new ImageSprite(pack.getTexture("runner/body/hand")) //
						.setAnchor(12, 6) //
						.setXY(10, 85)))) //
			.addChild(new Entity() //
				.add(_top = new ImageSprite(pack.getTexture("runner/body/shirt")) //
					.setAnchor(11, 5))); //
	}

	private var _root:Entity;
	private var _topPivot:Sprite;
	private var _top:Sprite;
	private var _bottom:Sprite;
	private var _hand:Sprite;
	private var _isFront:Bool;
	private var _type:PersonMoveType = Walk;
	private var _progress = new AnimatedFloat(0);
}
