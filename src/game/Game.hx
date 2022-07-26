package game;

import flambe.display.ImageSprite;
import flambe.SpeedAdjuster;
import flambe.animation.Sine;
import flambe.animation.AnimatedFloat;
import flambe.input.PointerEvent;
import flambe.System;
import flambe.Disposer;
import game.cafe.ThirstyArms;
import game.cafe.Meter;
import game.cafe.BarTable;
import game.cafe.ThirstyPerson;
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
		this._disposer.dispose();
	}

	override function onUpdate(dt:Float) {
		return;
		_anchorX.update(dt);
		_anchorY.update(dt);
		_rotation.update(dt);
		_elapsed += dt;
		if (_elapsed > 5) {
			_elapsed = 0;
			if (Math.random() > 0.5) {
				_thirstyArms.wave();
			} else {
				_thirstyArms.slam();
			}
		}
	}

	public function init(pack:AssetPack, width:Int, height:Int) {
		_anchorX.behavior = new Sine(-40, 40, 2);
		_anchorY.behavior = new Sine(-10, 20, 3);
		_rotation.behavior = new Sine(-5, 5, 4);

		this._disposer = new Disposer();
		this._root = new Entity();
		this._meterTime = new Entity().add(new Meter(20, 40));
		this._meterDrink = new Entity().add(new Meter(width - 120, 40).setFill(.25));
		this._root //
			.add(new Background(pack)) //
			.add(new PlayButton(pack)) //
				// .add(this._thirstyPerson = new ThirstyPerson(width, height)) //
			.add(this._barTable = new BarTable(pack, height)); //
		// .add(this._thirstyArms = new ThirstyArms(width, height)) //
		// .addChild(this._meterTime) //
		// .addChild(this._meterDrink); //

		// this._thirstyPerson.bindTo(_anchorX, _anchorY, _rotation);
		// this._thirstyArms.bindTo(_anchorX, _anchorY, _rotation);

		// var isDown = false;
		// function onPointer(e:PointerEvent) {
		// 	_thirstyArms.setTarget(e.viewX, e.viewY);
		// }

		// this._disposer.add(System.pointer.down.connect(e -> {
		// 	isDown = true;
		// 	onPointer(e);
		// }));
		// this._disposer.add(System.pointer.up.connect(e -> {
		// 	if (isDown) {
		// 		onPointer(e);
		// 		this._thirstyArms.reset();
		// 		isDown = false;
		// 	}
		// }));
		// this._disposer.add(System.pointer.move.connect(e -> {
		// 	if (isDown) {
		// 		onPointer(e);
		// 	}
		// }));
	}

	private var _root:Entity;
	private var _meterTime:Entity;
	private var _meterDrink:Entity;
	private var _barTable:BarTable;
	private var _thirstyPerson:ThirstyPerson;
	private var _thirstyArms:ThirstyArms;
	private var _disposer:Disposer;
	private var _elapsed = 0.0;
	private var _anchorX = new AnimatedFloat(0);
	private var _anchorY = new AnimatedFloat(0);
	private var _rotation = new AnimatedFloat(0);
}