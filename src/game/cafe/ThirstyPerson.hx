package game.cafe;

import flambe.animation.Sine;
import flambe.animation.AnimatedFloat;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.Component;

class ThirstyPerson extends Component {
	public function new(width:Int, height:Int) {
		this.init(width, height);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function bindTo(anchorX :AnimatedFloat, anchorY :AnimatedFloat, rotation:AnimatedFloat) {
		this._root.get(Sprite).anchorX.bindTo(anchorX);
		this._root.get(Sprite).anchorY.bindTo(anchorY);
		this._root.get(Sprite).rotation.bindTo(rotation);
	}

	public function init(width:Int, height:Int) {
		this._root = new Entity().add(new Sprite().setXY(width / 2, height - 350));

		this._torso = new Entity().add(new ThirstyPersonTorso());
		this._head = new Entity().add(new ThirstyPersonHead());

		this._root //
			.addChild(this._torso) //
			.addChild(this._head);
	}

	private var _root:Entity;
	private var _head:Entity;
	private var _torso:Entity;
}

class ThirstyPersonHead extends Component {
	public function new() {
		this.init();
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function init() {
		this._root = new Entity().add(new Sprite());
		this._head = new Entity().add(new FillSprite(0xfffff0, 210, 210).setXY(0, -190).centerAnchor());
		this._root.addChild(this._head);
		this._root.get(Sprite).anchorX.behavior = new Sine(-20, 20, 2);
		this._root.get(Sprite).anchorY.behavior = new Sine(-5, 10, 3);
		this._root.get(Sprite).rotation.behavior = new Sine(-5, 5, 5);
	}

	private var _root:Entity;
	private var _head:Entity;
}

class ThirstyPersonTorso extends Component {
	public function new() {
		this.init();
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function init() {
		this._root = new Entity().add(new Sprite());
		this._torso = new Entity().add(new FillSprite(0x00ff00, 300, 300).centerAnchor());
		this._root.addChild(this._torso);
	}

	private var _root:Entity;
	private var _torso:Entity;
}
