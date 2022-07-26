package game;

import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.animation.Sine;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Background extends Component {
	public function new(pack:AssetPack) {
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function init(pack:AssetPack) {
		var CLOUD_X_DIST = 30;
		var CLOUD_Y_DIST = 15;
		var CLOUD_TIME = 5;

		this._root = new Entity();
		this._root.add(new ImageSprite(pack.getTexture("mainBack")));
		var titleTex = pack.getTexture("title");
		this._title = new Entity().add(new ImageSprite(titleTex).centerAnchor().setXY(390 + titleTex.width / 2, 179 + titleTex.height / 2));
		this._title.get(Sprite).rotation.behavior = new Sine(-3, 3, CLOUD_TIME);

		this._flamingo = new ImageSprite(pack.getTexture("flamingo")).setXY(1131, 594);
		this._flamingo.x.behavior = new Sine(1131 - CLOUD_X_DIST, 1131 + CLOUD_X_DIST, CLOUD_TIME);
		this._flamingo.rotation.behavior = new Sine(-5, 5, CLOUD_TIME * 2);

		var cloud1 = new ImageSprite(pack.getTexture("cloud")).setXY(0, 54);
		var cloud2 = new ImageSprite(pack.getTexture("cloud")).setXY(1039, 168);
		var cloud3 = new ImageSprite(pack.getTexture("cloud")).setXY(1340, 51);

		cloud1.x.behavior = new Sine(-CLOUD_X_DIST, CLOUD_X_DIST, CLOUD_TIME);
		cloud1.y.behavior = new Sine(54 - CLOUD_Y_DIST, 54 + CLOUD_Y_DIST, CLOUD_TIME * 2);
		cloud2.x.behavior = new Sine(1039 - CLOUD_X_DIST, 1039 + CLOUD_X_DIST, CLOUD_TIME);
		cloud2.y.behavior = new Sine(168 - CLOUD_Y_DIST, 168 + CLOUD_Y_DIST, CLOUD_TIME * 2);
		cloud3.x.behavior = new Sine(1340 - CLOUD_X_DIST, 1340 + CLOUD_X_DIST, CLOUD_TIME);
		cloud3.y.behavior = new Sine(51 - CLOUD_Y_DIST, 51 + CLOUD_Y_DIST, CLOUD_TIME * 2);

		this._root //
			.addChild(new Entity().add(cloud1))
			.addChild(new Entity().add(cloud2))
			.addChild(new Entity().add(cloud3))
			.add(new BackgroundSun(pack))
			.addChild(this._title) //
			.addChild(new Entity().add(this._flamingo)); //
	}

	private var _root:Entity;
	private var _title:Entity;
	private var _flamingo:Sprite;
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

	public function init(pack:AssetPack) {
		this._root = new Entity();
		this._root.add(new Sprite().setXY(300, 90));
		this._root.get(Sprite).anchorX.behavior = new Sine(-20, 20, 5);
		this._root.get(Sprite).anchorY.behavior = new Sine(20, 0, 2.5);

		this._root //
			.addChild(new Entity().add(_stripes = new ImageSprite(pack.getTexture("sun/sunStripes")).centerAnchor())) //
			.addChild(new Entity().add(_sun = new ImageSprite(pack.getTexture("sun/sun")).centerAnchor())) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("sun/ear")).setXY(-125, -35))) //
			.addChild(new Entity().add(new BackgroundSunEye(pack, -14, -50))) //
			.addChild(new Entity().add(new BackgroundSunEye(pack, 72, -50))) //
			.add(new BackgroundSunSmile(pack)); //
	}

	private var _root:Entity;
	private var _stripes:Sprite;
	private var _sun:Sprite;
	private var _eyeLeft:BackgroundSunEye;
	private var _eyeRight:BackgroundSunEye;
}

class BackgroundSunSmile extends Component {
	public function new(pack:AssetPack) {
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function init(pack:AssetPack) {
		this._root = new Entity();
		this._root //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("sun/mouthSmile")).setXY(10, 55)));
	}

	private var _root:Entity;
	private var _smile1:Sprite;
	private var _smile2:Sprite;
	private var _smile3:Sprite;
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

	public function init(pack:AssetPack, x:Float, y:Float) {
		this._root = new Entity().add(new Sprite().setXY(x, y));
		var eyeTex = pack.getTexture("sun/eye");
		this._root.addChild(new Entity().add(new FillSprite(0xF4DEC9, eyeTex.width - 4, eyeTex.height - 4).setXY(2, 2)));
		this._root.addChild(new Entity().add(_pupil = new ImageSprite(pack.getTexture("sun/eyePupil")).setXY(38, 70).centerAnchor()));
		this._root.addChild(new Entity().add(new ImageSprite(eyeTex)));
		this._root.addChild(new Entity().add(_brow = new ImageSprite(pack.getTexture("sun/eyebrow")).setXY(24, -12).centerAnchor()));
	}

	private var _root:Entity;
	private var _pupil:Sprite;
	private var _brow:Sprite;
}
