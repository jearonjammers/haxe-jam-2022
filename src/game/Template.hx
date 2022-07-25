package game;

import flambe.Entity;
import flambe.Component;

class Template extends Component {
	public function new() {
		this.init();
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	public function init() {
		this._root = new Entity();
	}

	private var _root:Entity;
}
