package game.runner;

import flambe.util.Value;
import flambe.input.KeyboardEvent;
import flambe.System;
import flambe.Disposer;
import flambe.Entity;
import flambe.Component;

class ControlDesktop extends Component {
	public var state:Value<ControlState>;

	public function new() {
		this.state = new Value(ControlState.Idle);
		this.init();
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
		_disposer.dispose();
	}

	private function onkeyUp(e:KeyboardEvent):Void {
		this.state._ = Idle;
	}

	private function onkeyDown(e:KeyboardEvent):Void {
		switch e.key {
			case Up:
				this.state._ = Up;
			case Down:
				this.state._ = Down;
			case Right:
				this.state._ = Right;
			case Space:
				this.state._ = Space;
			case _:
		}
	}

	private function init() {
		this._root = new Entity();
		_disposer = new Disposer();
		_disposer.add(System.keyboard.down.connect(onkeyDown));
		_disposer.add(System.keyboard.up.connect(onkeyUp));
	}

	private var _root:Entity;
	private var _disposer:Disposer;
}
