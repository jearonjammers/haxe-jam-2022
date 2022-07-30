package game.runner;

import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Tree extends Component {
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
			.add(new ImageSprite(pack.getTexture("runner/tree")).setXY(x, y)); //
	}

	private var _root:Entity;
}
