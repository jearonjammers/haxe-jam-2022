package game.runner;

import flambe.animation.Sine;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class RunnerSun extends Component {
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
			.addChild(new Entity().add(_burst = new ImageSprite(pack.getTexture("runner/sun/sunBurst")) //
				.centerAnchor())) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/sun/sun")) //
				.centerAnchor())) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/sun/ear")) //
				.setXY(-120, -30))) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/sun/eye")) //
				.setXY(10, 30))) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/sun/eye")) //
				.setXY(95, 30))) //
			.addChild(new Entity().add(new ImageSprite(pack.getTexture("runner/sun/mouth")) //
				.setAnchor(35, 3).setXY(90, 120))); //
		_burst.y.behavior = new Sine(0, 10, 1);
		_burst.rotation.behavior = new Sine(-5, 5, 2);
		this._root.get(Sprite).anchorX.behavior = new Sine(-20, 20, 4);
		this._root.get(Sprite).anchorY.behavior = new Sine(-10, 0, 1);
		this._root.get(Sprite).rotation.behavior = new Sine(-5, 5, 8);
	}

	private var _root:Entity;
	private var _burst:Sprite;
}
