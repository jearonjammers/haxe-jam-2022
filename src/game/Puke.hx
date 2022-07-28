package game;

import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Puke extends Component {
	public function new(pack :AssetPack) {
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init(pack :AssetPack) {
		this._root = new Entity();
	}

	private var _root:Entity;
}
