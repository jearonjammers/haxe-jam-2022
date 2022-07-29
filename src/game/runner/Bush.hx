package game.runner;

import flambe.animation.Sine;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Bush extends Component {
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
		this._root = new Entity();
		this._root //
			.add(new ImageSprite(pack.getTexture("runner/bush")).setXY(x, y)) //
			.addChild(new Entity().add(_berry1 = new ImageSprite(pack.getTexture("runner/bushBerry")) //
				.centerAnchor() //
				.setXY(220, 98))) //
			.addChild(new Entity().add(_berry2 = new ImageSprite(pack.getTexture("runner/bushBerry")) //
				.centerAnchor() //
				.setXY(313, 78))); //
	}

	private var _root:Entity;
	private var _berry1:Sprite;
	private var _berry2:Sprite;
	private var _elapsed:Float = 0;
    private var _duration1 = 2;
    private var _duration2 = 3;
}
