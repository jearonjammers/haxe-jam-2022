package game.cafe;

import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.animation.Sine;
import flambe.animation.AnimatedFloat;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;

enum ThirstyPersonState {
	Drinking;
	Mad;
	Thirsty;
}

class ThirstyPerson extends Component {
	public var state(get, null):ThirstyPersonState = Thirsty;

	public function new(pack:AssetPack, width:Float, height:Float) {
		this.init(pack, width, height);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function bindTo(anchorX:AnimatedFloat, anchorY:AnimatedFloat, rotation:AnimatedFloat) {
		this._root.get(Sprite).anchorX.bindTo(anchorX);
		this._root.get(Sprite).anchorY.bindTo(anchorY);
		this._root.get(Sprite).rotation.bindTo(rotation);
	}

	public function drink() {
		this._head.get(ThirstyPersonHead).drink();
	}

	public function thirst() {
		this._head.get(ThirstyPersonHead).thirst();
	}

	public function mad() {
		this._head.get(ThirstyPersonHead).mad();
	}

	private function get_state():ThirstyPersonState {
		return this._head.get(ThirstyPersonHead).state;
	}

	private function init(pack:AssetPack, width:Float, height:Float) {
		this._root = new Entity().add(new Sprite().setXY(width / 2, 860));

		this._torso = new Entity().add(new ThirstyPersonTorso(pack));
		this._head = new Entity().add(new ThirstyPersonHead(pack));

		this._root //
			.addChild(this._torso) //
			.addChild(this._head);
	}

	private var _root:Entity;
	private var _head:Entity;
	private var _torso:Entity;
}

class ThirstyPersonHead extends Component {
	public var state:ThirstyPersonState = Thirsty;

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
		this._root = new Entity().add(new Sprite());
		this._head = new Entity().add(new ImageSprite(_pack.getTexture("cafe/body/head")).setXY(0, -275).centerAnchor());
		this._root.addChild(this._head);
		this._root.get(Sprite).anchorX.behavior = new Sine(-2, 2, 2);
		this._root.get(Sprite).anchorY.behavior = new Sine(0, 10, 3);
		this._root.get(Sprite).rotation.behavior = new Sine(-5, 5, 5);
		this._root.addChild(_features = new Entity());

		thirst();
	}

	public function drink() {
		this.state = Drinking;
		_features.disposeChildren();
		var eyes = new ImageSprite(_pack.getTexture("cafe/body/eyesDrinking"));
		_features //
			.addChild(new Entity().add(new ImageSprite(_pack.getTexture("cafe/body/mouthCool")) //
				.setXY(10, -155).centerAnchor())) //
			.addChild(new Entity().add(eyes //
				.setXY(0, -290) //
				.centerAnchor())); //
	}

	public function thirst() {
		this.state = Thirsty;
		_features.disposeChildren();
		var eyes = new ImageSprite(_pack.getTexture("cafe/body/eyesCool"));
		_features //
			.addChild(new Entity().add(new ImageSprite(_pack.getTexture("cafe/body/mouthCool")) //
				.setXY(10, -155).centerAnchor())) //
			.addChild(new Entity().add(eyes //
				.setXY(0, -290) //
				.centerAnchor())); //
		eyes.scaleY.behavior = new Sine(1, 0.9, 0.5);
	}

	public function mad() {
		this.state = Mad;
		_features.disposeChildren();
		var eyes = new ImageSprite(_pack.getTexture("cafe/body/eyesMad"));
		_features //
			.addChild(new Entity().add(new ImageSprite(_pack.getTexture("cafe/body/mouthMad")) //
				.setXY(-2, -155).centerAnchor())) //
			.addChild(new Entity().add(eyes //
				.setXY(0, -290) //
				.centerAnchor())); //
	}

	private var _root:Entity;
	private var _head:Entity;
	private var _features:Entity;
	private var _pack:AssetPack;
}

class ThirstyPersonTorso extends Component {
	public function new(pack:AssetPack) {
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init(pack:AssetPack) {
		this._root = new Entity().add(new Sprite());
		this._torso = new Entity().add(new ImageSprite(pack.getTexture("cafe/body/body")).centerAnchor());
		this._root.addChild(this._torso);
	}

	private var _root:Entity;
	private var _torso:Entity;
}
