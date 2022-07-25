package game;

import flambe.display.FillSprite;
import flambe.Entity;
import flambe.Component;

class BarTable extends Component {
	public function new(width:Int, height:Int) {
		this.init(width, height);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function init(width:Int, height:Int) {
		this._root = new Entity();
		this._root.add(new FillSprite(0xfff000, width, 300).setXY(0, height - 300));
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
