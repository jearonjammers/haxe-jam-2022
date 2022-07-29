package game.runner;

import flambe.animation.Sine;
import flambe.animation.AnimatedFloat;
import flambe.display.FillSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class RunnerGame extends Component {
	public function new(pack:AssetPack, width:Float, height:Float) {
		this.init(pack, width, height);
	}

	override function onUpdate(dt:Float) {
		this._move.update(dt);
		this._root.get(Person).moveTo(this._move._, 980);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init(pack:AssetPack, width:Float, height:Float) {
		var METER_Y = 144;
		this._root = new Entity();
		this._root //
			.add(new FillSprite(0xEB3B24, width, height)) //
			.addChild(new Entity().add(new FillSprite(0x0957E9, width, 180).setXY(0, height - 180))) //
			.addChild(new Entity().add(new FillSprite(0xffffff, width, 6).setXY(0, height - 186))) //
			.add(new Person(pack)) //
			.add(new Meter(pack, 1760, METER_Y, "drinkFront").show(true)); //
		this._move = new AnimatedFloat(0);
		this._move.behavior = new Sine(300, 800, 2);
	}

	private var _root:Entity;
	private var _move:AnimatedFloat;
}
