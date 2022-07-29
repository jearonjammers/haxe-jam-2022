package game.cafe;

import flambe.System;
import flambe.display.Sprite;
import game.cafe.Bar;
import flambe.animation.Ease;
import flambe.script.CallFunction;
import flambe.script.AnimateTo;
import flambe.script.Sequence;
import flambe.script.Script;
import flambe.animation.Sine;
import flambe.animation.AnimatedFloat;
import flambe.Disposer;
import game.cafe.ThirstyArms;
import game.cafe.BarTable;
import game.cafe.ThirstyPerson;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class CafeGame extends Component {
	public function new(pack:AssetPack, width:Float, height:Float) {
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
		_anchorX.update(dt);
		_anchorY.update(dt);
		_rotation.update(dt);
		if (_isGameplay) {
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
	}

	private function init(pack:AssetPack, width:Float, height:Float) {
		_anchorX._ = 1900;
		var METER_Y = 180;
		this._disposer = new Disposer();
		this._root = new Entity();
		this._meterTime = new Entity().add(new Meter(pack, 100, METER_Y, "timeFront").setFill(0.4));
		this._meterDrink = new Entity().add(new Meter(pack, 1760, METER_Y, "drinkFront"));
		this._root //
			.add(new Sprite())
			.add(new Background(pack)) //
			.addChild(new Entity().add(_playButton = new Button(pack, "playButton", width / 2, 780))) //
			.addChild(new Entity().add(this._thirstyPerson = new ThirstyPerson(pack, width, height))) //
			.add(new BarTable(pack, height)) //
			.addChild(new Entity().add(this._thirstyArms = new ThirstyArms(pack, width, height))) //
			.add(this._liquid = new Liquid(pack)) //
			.add(this._barDrinks = new Bar(pack, this._liquid))
			.addChild(new Entity().add(_homeButton = new Button(pack, "homeButton", width - 121, 90))) //
			.addChild(this._meterTime) //
			.addChild(this._meterDrink); //

		this._thirstyPerson.bindTo(_anchorX, _anchorY, _rotation);
		this._thirstyArms.bindTo(_anchorX, _anchorY, _rotation);

		_disposer.add(_homeButton.click.connect(() -> {
			this.dispose();
			System.root.add(new CafeGame(pack, width, height));
		}));

		this._disposer.add(_playButton.click.connect(this.nextState).once());
	}

	public function nextState() {
		this._root.get(Background).nextState();
		// _anchorY.behavior = new Sine(0, 0, 3);
		_anchorY.behavior = new Sine(5, 0, 3);
		_isGameplay = true;
		_playButton.dispose();
		this._meterTime.get(Meter).show(false);
		this._meterDrink.get(Meter).show(false);

		this._root.add(new Script()).get(Script).run(new Sequence([
			new AnimateTo(_anchorX, -200, 1, Ease.cubeOut),
			new CallFunction(() -> {
				// _anchorX.behavior = new Sine(0, 0, 2);
				_anchorX.behavior = new Sine(-200, 200, 2);
			})
		]));
	}

	private var _root:Entity;
	private var _meterTime:Entity;
	private var _meterDrink:Entity;
	private var _barDrinks:Bar;
	private var _playButton:Button;
	private var _homeButton:Button;
	private var _thirstyPerson:ThirstyPerson;
	private var _thirstyArms:ThirstyArms;
	private var _liquid:Liquid;
	private var _disposer:Disposer;
	private var _elapsed = 0.0;
	private var _isGameplay:Bool = false;
	private var _anchorX = new AnimatedFloat(0);
	private var _anchorY = new AnimatedFloat(0);
	private var _rotation = new AnimatedFloat(0);
}
