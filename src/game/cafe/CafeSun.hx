package game.cafe;

import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.animation.Sine;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class CafeSun extends Component {
	public function new(pack:AssetPack, x:Float, y:Float) {
		this.init(pack, x, y);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function smile() {
		_sun.smile();
	}

	public function mad() {
		_sun.mad();
		Audio.playSound_("sfx/cafe/angrySun");
		Audio.playSound_("sfx/cafe/sunMouth");
	}

	private function init(pack:AssetPack, x:Float, y:Float) {
		this._root = new Entity();
		this._root //
			.add(new Sprite().setXY(x, y)).add(_sun = new BackgroundSun(pack));
	}

	private var _root:Entity;
	private var _sun:BackgroundSun;
}

class BackgroundSun extends Component {
	public function new(pack:AssetPack) {
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	override function onUpdate(dt:Float) {
		_stripes.rotation._ += dt * 20;
	}

	public function smile() {
		_mouth.smile();
	}

	public function mad() {
		_mouth.mad();
	}

	private function init(pack:AssetPack) {
		this._root = new Entity();
		this._root.add(new Sprite());
		this._root.get(Sprite).anchorX.behavior = new Sine(-20, 20, 5);
		this._root.get(Sprite).anchorY.behavior = new Sine(20, 0, 2.5);

		this._root //
			.addChild(new Entity().add(_stripes = new ImageSprite(pack.getTexture("cafe/sun/sunStripes")).centerAnchor())) //
			.addChild(new Entity().add(_sun = new ImageSprite(pack.getTexture("cafe/sun/sun")).centerAnchor())) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("cafe/sun/ear")).setXY(-125, -35))) //
			.addChild(new Entity().add(new BackgroundSunEye(pack, -14, -50))) //
			.addChild(new Entity().add(new BackgroundSunEye(pack, 72, -50))) //
			.add(_mouth = new BackgroundSunSmile(pack)); //
	}

	private var _root:Entity;
	private var _stripes:Sprite;
	private var _sun:Sprite;
	private var _eyeLeft:BackgroundSunEye;
	private var _eyeRight:BackgroundSunEye;
	private var _mouth:BackgroundSunSmile;
}

class BackgroundSunSmile extends Component {
	public function new(pack:AssetPack) {
		_pack = pack;
		this.init();
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init() {
		this._root = new Entity();
		this.smile();
	}

	public function smile() {
		this._root.disposeChildren();
		this._root //
			.addChild(new Entity().add(new ImageSprite(_pack.getTexture("cafe/sun/mouthSmile")).setXY(10, 55)));
	}

	public function mad() {
		this._root.disposeChildren();
		this._root //
			.addChild(new Entity().add(new ImageSprite(_pack.getTexture("cafe/sun/mouthOpen")).setXY(40, 55)));
	}

	private var _root:Entity;
	private var _pack:AssetPack;
}

class BackgroundSunEye extends Component {
	public function new(pack:AssetPack, x:Float, y:Float) {
		this.init(pack, x, y);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init(pack:AssetPack, x:Float, y:Float) {
		this._root = new Entity().add(new Sprite().setXY(x, y));
		var eyeTex = pack.getTexture("cafe/sun/eye");
		this._root.addChild(new Entity().add(new FillSprite(0xF4DEC9, eyeTex.width - 4, eyeTex.height - 4).setXY(2, 2)));
		this._root.addChild(new Entity().add(_pupil = new ImageSprite(pack.getTexture("cafe/sun/eyePupil")).setXY(38, 70).centerAnchor()));
		this._root.addChild(new Entity().add(new ImageSprite(eyeTex)));
		this._root.addChild(new Entity().add(_brow = new ImageSprite(pack.getTexture("cafe/sun/eyebrow")).setXY(36, 10).centerAnchor()));
	}

	private var _root:Entity;
	private var _pupil:Sprite;
	private var _brow:Sprite;
}
