package game.runner;

import flambe.animation.Sine;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class EnemyCar extends Component {
	public function new(pack:AssetPack, index:Int, x:Float, y:Float) {
		this.init(pack, index, x, y);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	override function onUpdate(dt:Float) {
		this._root.get(Sprite).x._ -= 500 * dt;
		_elapsed += dt;
		if (_elapsed > 3) {
			this.owner.dispose();
		}
	}

	private function init(pack:AssetPack, index:Int, x:Float, y:Float) {
		Audio.playSound_("sfx/runner/car");
		var car = new ImageSprite(pack.getTexture("runner/car/car"));
		var carEye = new ImageSprite(pack.getTexture("runner/car/carEye"));
		var carStar = new ImageSprite(pack.getTexture("runner/car/carStar"));
		var carWheel1 = new ImageSprite(pack.getTexture("runner/car/carWheel"));
		var carWheel2 = new ImageSprite(pack.getTexture("runner/car/carWheel"));
		this._root = new Entity() //
			.add(new Sprite().setAnchor(0, 30).setXY(x, y)) //
			.addChild(new Entity().add(car //
				.setAnchor(226, 220).setXY(0, 0))) //
			.addChild(new Entity().add(carEye //
				.setXY(-80, -94).setAnchor(34, 92))) //
			.addChild(new Entity().add(carStar //
				.setXY(25, -58) //
				.centerAnchor())) //
			.addChild(new Entity().add(carWheel1 //
				.setXY(-95, 0) //
				.centerAnchor())) //
			.addChild(new Entity().add(carWheel2 //
				.setXY(139, 0) //
				.centerAnchor())); //

		var time = 0.25;
		car.anchorY.behavior = new Sine(220, 210, time);
		car.rotation.behavior = new Sine(-3, 0, time);
		carEye.anchorY.behavior = new Sine(92, 82, time);
		carStar.anchorY.behavior = new Sine(34, 24, time);

		if (index == 0) {
			this._root.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/instructJump")).setXY(-220, -470)));
		}
	}

	private var _root:Entity;
	private var _elapsed = 0.0;
}
