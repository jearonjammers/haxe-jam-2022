package game.runner;

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
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init(pack:AssetPack) {
		this._root = new Entity();
		this._root //
			.add(new Sprite().setXY(300, 300)) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/body/shorts")) //
				.centerAnchor().setXY(0, -5))) //
			.addChild(new Entity().add(_leg1 = new PersonLeg(pack, false))) //
			.addChild(new Entity().add(_leg2 = new PersonLeg(pack, true)))
			.addChild(new Entity() //
                .add(_bodyPivot = new ImageSprite(pack.getTexture("runner/body/body")).setAnchor(32, 135))); //
        this.run(0.75);
	}

	private function run(time:Float) {
		_progressLegs.behavior = new Sine(1, -1, time);
		_bodyPivot.rotation.behavior = new Sine(15, 8, time / 2);
	}

	private var _leg1:PersonLeg;
	private var _leg2:PersonLeg;
	private var _progressLegs = new AnimatedFloat(0);
	private var _progressBody = new AnimatedFloat(0);
	private var _root:Entity;
	private var _bodyPivot:Sprite;
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
		} else {
			var p = -Ease.sineOut(Math.abs(val));
			var rotationTop = p * 30;
			_topPivot.rotation._ = -rotationTop;
			var rotationBottom = p * 10;
			_bottom.rotation._ = -rotationBottom;
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
					.setAnchor(7, 10).setXY(-3, 78))) //
			.addChild(new Entity() //
				.add(_top = new ImageSprite(pack.getTexture(texName)) //
					.setAnchor(14, 15))); //
	}

	private var _root:Entity;
	private var _topPivot:Sprite;
	private var _top:Sprite;
	private var _bottom:Sprite;
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
			_bottom.rotation._ = rotationBottom;
		} else {
			var p = -Ease.sineOut(Math.abs(val));
			var rotationTop = p * 30;
			_topPivot.rotation._ = -rotationTop;
			var rotationBottom = p * 10;
			_bottom.rotation._ = -rotationBottom;
		}
		return this;
	}

	private function init(pack:AssetPack, isFront:Bool) {
		var time = 1;
		var texName = isFront ? "runner/body/pantFront" : "runner/body/pantBack";
		var x = isFront ? -10 : 10;
		this._root = new Entity() //
			.add(_topPivot = new Sprite().setXY(x, 0)) //
			.addChild(new Entity() //
				.add(_bottom = new ImageSprite(pack.getTexture("runner/body/leg")) //
					.setAnchor(7, 10).setXY(-3, 78))) //
			.addChild(new Entity() //
				.add(_top = new ImageSprite(pack.getTexture(texName)) //
					.setAnchor(14, 15))); //
	}

	private var _root:Entity;
	private var _topPivot:Sprite;
	private var _top:Sprite;
	private var _bottom:Sprite;
}