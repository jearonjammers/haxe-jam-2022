package game.runner;

import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class PersonLegs extends Component {
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
		this._root = new Entity() //
			.add(new Sprite().setXY(x, y)) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/body/shorts")) //
				.centerAnchor().setXY(0, -5))) //
			.addChild(new Entity().add(_leg1 = new PersonLeg(pack, false))) //
			.addChild(new Entity().add(_leg2 = new PersonLeg(pack, true)));
	}

	public function setBalance(balance:Float):Void {
		this._leg1.setBalance(balance);
		this._leg2.setBalance(balance);
	}

	public function move(type:PersonMoveType, time:Float) {
		_leg1.move(type, time);
		_leg2.move(type, time);
	}

	private var _leg1:PersonLeg;
	private var _leg2:PersonLeg;
	private var _root:Entity;
}
