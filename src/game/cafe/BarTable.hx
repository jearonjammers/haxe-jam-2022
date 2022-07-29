package game.cafe;

import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class BarTable extends Component {
	public function new(pack:AssetPack, height:Float) {
		this.init(pack, height);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	private function init(pack:AssetPack, height:Float) {
		this._root = new Entity();
		var table = pack.getTexture("cafe/table");
		this._root.addChild(new Entity().add(new ImageSprite(table).setXY(-3, height - table.height)));
	}

	private var _root:Entity;
}
