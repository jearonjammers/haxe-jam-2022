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
		this.move(Jump, 0.4);
	}

	public function move(type:PersonMoveType, time:Float) {
		switch type {
			case Jump:
				_lowerPivot.anchorY.behavior = new Sine(0, 0, time);
				_upperPivot.rotation.behavior = new Sine(-20, 2, time * 2);
			case Crouch:
				var offsetY = -72;
				_lowerPivot.anchorY.behavior = new Sine(0 + offsetY, 5 + offsetY, time / 2);
				_upperPivot.rotation.behavior = new Sine(45, 20, time / 2);
			case Walk:
				_lowerPivot.anchorY.behavior = new Sine(0, 5, time / 2);
				_upperPivot.rotation.behavior = new Sine(15, 8, time / 2);
			case Surf:
				_lowerPivot.anchorY.behavior = new Sine(0, 0, time / 2);
				_upperPivot.rotation.behavior = new Sine(-2, 2, time);
		}
		_head.move(type, time);
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
