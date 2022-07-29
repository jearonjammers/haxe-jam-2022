package game.runner;

import flambe.animation.Sine;
import flambe.display.Sprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Person extends Component {
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
		this._root = new Entity();
		this._root //
			.add(new Sprite().setXY(620, 900).setAnchor(0, 180)) //
			.addChild(new Entity() //
				.add(_lowerPivot = new Sprite()) //
				.add(_legs = new PersonLegs(pack, 0, 0)) //
				.addChild(new Entity() //
					.add(_upperPivot = new Sprite()) //
					.add(_torso = new PersonTorso(pack, 0, 0)) //
					.add(_head = new PersonHead(pack))));
		this.move(Walk, 2);
	}

	public function move(type:PersonMoveType, time:Float) {
		switch type {
			case Idle:
			case Crouch:
				// _lowerPivot.anchorY.behavior = new Sine(-45, -75, time / 2);
				// _upperPivot.rotation.behavior = new Sine(15, 8, time / 2);
			case Walk:
				_lowerPivot.anchorY.behavior = new Sine(0, 5, time / 2);
				_upperPivot.rotation.behavior = new Sine(15, 8, time / 2);
			case Surf:
		}
		// _head.move(type, time);
		_legs.move(type, time);
		_torso.move(type, time);
	}

	private var _legs:PersonLegs;
	private var _torso:PersonTorso;
	private var _head:PersonHead;
	private var _root:Entity;
	private var _lowerPivot:Sprite;
	private var _upperPivot:Sprite;
}
