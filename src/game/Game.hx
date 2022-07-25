package game;

import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Game extends Component {
	public function new(pack:AssetPack, width:Int, height:Int) {
		this.init(pack, width, height);
	}

	override public function onAdded() {
		this.owner.addChild(this._root);
	}

	override public function onRemoved() {
		this.owner.removeChild(this._root);
	}

	public function init(pack:AssetPack, width:Int, height:Int) {
		this._root = new Entity();
		this._barTable = new Entity().add(new BarTable(width, height));
		this._meterTime = new Entity().add(new Meter(20, 40));
		this._meterDrink = new Entity().add(new Meter(width - 120, 40).setFill(.25));
		this._root.addChild(this._barTable).addChild(this._meterTime).addChild(this._meterDrink);
	}

	private var _root:Entity;
	private var _meterTime:Entity;
	private var _meterDrink:Entity;
	private var _barTable:Entity;
}
