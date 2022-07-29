package game.cafe;

import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.animation.Sine;
import flambe.animation.AnimatedFloat;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;

class ThirstyPerson extends Component {
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
		this._head = new Entity().add(new ImageSprite(pack.getTexture("body/head")).setXY(0, -275).centerAnchor());
		this._root.addChild(this._head);
		this._root.get(Sprite).anchorX.behavior = new Sine(-2, 2, 2);
		this._root.get(Sprite).anchorY.behavior = new Sine(0, 10, 3);
		this._root.get(Sprite).rotation.behavior = new Sine(-5, 5, 5);
	}

	private var _root:Entity;
	private var _head:Entity;
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
		this._torso = new Entity().add(new ImageSprite(pack.getTexture("body/body")).centerAnchor());
		this._root.addChild(this._torso);
	}

	private var _root:Entity;
	private var _torso:Entity;
}
