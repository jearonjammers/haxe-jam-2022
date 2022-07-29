package game.runner;

import flambe.display.FillSprite;
import flambe.animation.Ease;
import flambe.animation.Sine;
import flambe.animation.AnimatedFloat;
import flambe.math.FMath;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Person extends Component {
	public function new(pack:AssetPack) {
		this.init(pack);
	}

	override function onUpdate(dt:Float) {
		_progressLegs.update(dt);
		_leg1.setPercent(-_progressLegs._);
		_leg2.setPercent(_progressLegs._);
		_arm1.setPercent(-_progressLegs._);
		_arm2.setPercent(_progressLegs._);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

    public function moveTo(x :Float, y :Float) : Void {
        this._root.get(Sprite).x._ = x;
        this._root.get(Sprite).y._ = y;
    }

	private function init(pack:AssetPack) {
		this._root = new Entity();
		this._root //
			.add(new Sprite().setAnchor(0, 180)) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/body/shorts")) //
				.centerAnchor().setXY(0, -5))) //
			.addChild(new Entity().add(_leg1 = new PersonLeg(pack, false))) //
			.addChild(new Entity().add(_leg2 = new PersonLeg(pack, true)))
			.addChild(new Entity() //
				.add(_bodyPivot = new Sprite()) //
				.addChild(new Entity() //
					.add(_arm1 = new PersonArm(pack, false)))
				.addChild(new Entity() //
					.add(new ImageSprite(pack.getTexture("runner/body/body")).setAnchor(32, 135))) //
				.addChild(new Entity() //
					.add(_arm2 = new PersonArm(pack, true))) //
				.addChild(new Entity() //
					.add(_head = new ImageSprite(pack.getTexture("runner/body/head")) //
						.setXY(0, -96) //
						.setAnchor(63, 148)))); //
		this.run(0.4);
	}

	private function run(time:Float) {
		this._root.get(Sprite).anchorY.behavior = new Sine(180, 185, time / 2);
		_progressLegs.behavior = new Sine(1, -1, time);
		_bodyPivot.rotation.behavior = new Sine(15, 8, time / 2);
		_head.rotation.behavior = new Sine(-13, -4, time / 2);
	}

	private var _leg1:PersonLeg;
	private var _leg2:PersonLeg;
	private var _arm1:PersonArm;
	private var _arm2:PersonArm;
	private var _progressLegs = new AnimatedFloat(0);
	private var _progressBody = new AnimatedFloat(0);
	private var _root:Entity;
	private var _bodyPivot:Sprite;
	private var _head:Sprite;
}

class PersonLeg extends Component {
	public function new(pack:AssetPack, isFront:Bool) {
		this.init(pack, isFront);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function setPercent(val:Float):PersonLeg {
		val = FMath.clamp(val, -1, 1);
		if (val >= 0) {
			var p = Ease.linear(val);
			var rotationTop = p * 60;
			_topPivot.rotation._ = -rotationTop;
			var rotationBottom = p * 60;
			_bottom.rotation._ = rotationBottom;
			var foot = p * 5;
			_foot.rotation._ = foot;
		} else {
			var p = -Ease.sineOut(Math.abs(val));
			var rotationTop = p * 10;
			_topPivot.rotation._ = -rotationTop;
			var rotationBottom = p * 10;
			_bottom.rotation._ = -rotationBottom;
			var foot = p * 15;
			_foot.rotation._ = foot;
		}
		return this;
	}

	private function init(pack:AssetPack, isFront:Bool) {
		var texName = isFront ? "runner/body/pantFront" : "runner/body/pantBack";
		var x = isFront ? -10 : 10;
		this._root = new Entity() //
			.add(_topPivot = new Sprite().setXY(x, 0)) //
			.addChild(new Entity() //
				.add(_bottom = new ImageSprite(pack.getTexture("runner/body/leg")) //
					.setAnchor(7, 10).setXY(-3, 78)) //
				.addChild(new Entity() //
					.add(_foot = new ImageSprite(pack.getTexture("runner/body/shoe")) //
						.setAnchor(7, 5) //
						.setXY(2, 100)))) //
			.addChild(new Entity() //
				.add(_top = new ImageSprite(pack.getTexture(texName)) //
					.setAnchor(14, 15))); //
	}

	private var _root:Entity;
	private var _topPivot:Sprite;
	private var _top:Sprite;
	private var _bottom:Sprite;
	private var _foot:Sprite;
}

class PersonArm extends Component {
	public function new(pack:AssetPack, isFront:Bool) {
		this.init(pack, isFront);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function setPercent(val:Float):PersonArm {
		val = FMath.clamp(val, -1, 1);
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
		return this;
	}

	private function init(pack:AssetPack, isFront:Bool) {
		var x = isFront ? -18 : 14;
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
}
