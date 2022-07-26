package game.cafe;

import flambe.display.ImageSprite;
import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.Component;

class BarTable extends Component {
	public function new(pack:AssetPack, height:Int) {
		this.init(pack, height);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function init(pack:AssetPack, height:Int) {
		this._root = new Entity();
		var table = pack.getTexture("table");
		this._root.add(new ImageSprite(table).setXY(-3, height - table.height));
		_slots = [];
		for (i in 0...5) {
			var x = 250 * i + 380;
			var y = i % 2 == 0 ? 80 : 150;
			var e = new Entity().add(new FillSprite(0xff00ff, 80, 80).setXY(x, y));
			_slots.push(e);
			this._root.addChild(e);
		}
	}

	private var _root:Entity;
	private var _slots:Array<Entity>;
}
