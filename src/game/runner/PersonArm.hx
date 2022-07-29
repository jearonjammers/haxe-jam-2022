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

	private function setCyclePercent(val:Float) {
		switch this._type {
			case Idle:
				_topPivot.rotation._ = 0;
				_bottom.rotation._ = 0;
				_hand.rotation._ = 0;
			case Crouch:
			case Walk:
				if (val >= 0) {
					var p = Ease.linear(val);
					var rotationTop = p * 60;
					_topPivot.rotation._ = -rotationTop;
					var rotationBottom = p * 60;
					_bottom.rotation._ = -rotationBottom;
					var hand = p * 0;
					_hand.rotation._ = hand;
				} else {
					var p = -Ease.sineOut(Math.abs(val));
					var rotationTop = p * 50;
					_topPivot.rotation._ = -rotationTop;
					var rotationBottom = p * 50;
					_bottom.rotation._ = rotationBottom;
					var hand = p * 20;
					_hand.rotation._ = -hand;
				}
			case Surf:
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
	private var _type:PersonMoveType = Idle;
	private var _progress = new AnimatedFloat(0);
}
