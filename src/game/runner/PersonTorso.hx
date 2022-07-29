package game.runner;

import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class PersonTorso extends Component {
	public function new(pack:AssetPack, x :Float, y :Float) {
		this.init(pack, x, y);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init(pack:AssetPack, x :Float, y :Float) {
		this._root = new Entity() //
			.add(new Sprite().setXY(x, y)) //
			.addChild(new Entity() //
				.add(_arm1 = new PersonArm(pack, false)))
			.addChild(new Entity() //
				.add(new ImageSprite(pack.getTexture("runner/body/body")).setAnchor(32, 135))) //
			.addChild(new Entity() //
				.add(_arm2 = new PersonArm(pack, true))); //
	}

	public function move(type:PersonMoveType, time:Float) {
		_arm1.move(type, time);
		_arm2.move(type, time);
	}

	private var _arm1:PersonArm;
	private var _arm2:PersonArm;
	private var _root:Entity;
}
