package game.cafe;

import game.text.TextGame;
import flambe.display.ImageSprite;
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
	public var isGameplay(default, null):Bool = false;

	public function new(pack:AssetPack, width:Float, height:Float) {
		_pack = pack;
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
		if (!_timeComplete && isGameplay) {
			if (_thirstyPerson.state != Mad) {
				if (isDrinking() && _thirstyPerson.state != Drinking) {
					_thirstyPerson.drink();
					Audio.playSound_("sfx/cafe/chug");
				} else if (!isDrinking() && _thirstyPerson.state != Thirsty) {
					_thirstyPerson.thirst();
				}
			}

			if (isDrinking()) {
				_fillAmount += dt;
			} else if (isSpilling()) {
				if (_spillAmount == 0) {
					Audio.playSound_("sfx/cafe/bottleSplash");
				}
				_spillAmount += dt;
			}

			if (_spillAmount > MAX_SPILL) {
				_spillAmount = 0;
				_thirstyPerson.mad();
				_background.mad();
				_barDrinks.toss();
				_liquid.visible = false;
				_cooldown = 0;
			}

			if (_thirstyPerson.state == Mad) {
				_cooldown += dt;
				if (_cooldown > 2.2) {
					_thirstyPerson.thirst();
					_background.smile();
				}
			}

			_timeElapsed += dt;
			var fillScale = _fillAmount / FILL_MAX;
			this._meterDrink.get(Meter).setFill(fillScale);
			var scale = 1 - _timeElapsed / TIME_DURATION;

			if (!_isWarning && (TIME_DURATION - _timeElapsed) < 10) {
				_isWarning = true;
				Audio.playSound_("sfx/cafe/timer");
			}

			this._meterTime.get(Meter).setFill(scale);
			if (_timeElapsed >= TIME_DURATION) {
				_timeComplete = true;
				Audio.playSound_("sfx/cafe/partyHarder");
				var spr = new ImageSprite(_pack.getTexture("cafe/fail"));
				this._root.addChild(new Entity().add(spr.centerAnchor().setXY(960, 540)));
				spr.rotation.behavior = new Sine(-5, 5, 4);
				spr.scaleX.behavior = new Sine(0.9, 1, 2);
				spr.scaleY.behavior = new Sine(0.9, 1, 2);
			} else if (_fillAmount >= FILL_MAX) {
				_timeComplete = true;
				this.dispose();
				System.root.add(new TextGame(_pack, 1920, 1080));
			}
		}
	}

	private inline function isDrinking():Bool {
		var isInX = _reachX > 130 && _reachX < 280;
		var isInY = _reachY > -580 && _reachY < -470;
		return isInX && isInY && _barDrinks.drink != null;
	}

	private inline function isSpilling():Bool {
		return _reachY < -470 && _barDrinks.drink != null;
	}

	private function init(pack:AssetPack, width:Float, height:Float) {
		Audio.playTitle_();
		_anchorX._ = 1900;
		var METER_Y = 180;
		this._disposer = new Disposer();
		this._root = new Entity();
		this._meterTime = new Entity().add(new Meter(pack, 100, METER_Y, "timeFront", "timeMid"));
		this._meterDrink = new Entity().add(new Meter(pack, 1760, METER_Y, "drinkFront", "drinkMid"));
		this._root //
			.add(new Sprite())
			.add(_background = new Background(pack)) //
			.addChild(new Entity().add(_playButton = new Button(pack, "cafe/playButton", width / 2, 780))) //
			.addChild(new Entity().add(this._thirstyPerson = new ThirstyPerson(pack, width, height))) //
			.add(new BarTable(pack, height)) //
			.addChild(new Entity().add(this._thirstyArms = new ThirstyArms(pack, width, height))) //
			.add(this._liquid = new Liquid(pack, "cafe")) //
			.add(this._barDrinks = new Bar(pack, this._liquid, this))
			.addChild(new Entity().add(_homeButton = new Button(pack, "homeButton", width - 121, 90))) //
			.addChild(this._meterTime) //
			.addChild(this._meterDrink); //

		this._thirstyPerson.bindTo(_anchorX, _anchorY, _rotation);
		this._thirstyArms.bindTo(_anchorX, _anchorY, _rotation);
		this._liquid.visible = false;

		_disposer.add(_homeButton.click.connect(() -> {
			this.dispose();
			Audio.playSound_("click");
			System.root.add(new CafeGame(pack, width, height));
		}));

		this._disposer.add(_playButton.click.connect(() -> {
			this.nextState();
			Audio.playSound_("click");
		}).once());

		this._disposer.add(this._thirstyArms.reachX.changed.connect((to, _) -> {
			this._reachX = to;
		}));

		this._disposer.add(this._thirstyArms.reachY.changed.connect((to, _) -> {
			this._reachY = to;
		}));

		this._meterDrink.get(Meter).setFill(0);
		this._meterTime.get(Meter).setFill(1);
	}

	public function nextState() {
		this._root.get(Background).nextState();
		_anchorY.behavior = new Sine(5, 0, 3);
		isGameplay = true;
		_playButton.dispose();
		this._meterTime.get(Meter).show(false);
		this._meterDrink.get(Meter).show(false);

		this._root.add(new Script()).get(Script).run(new Sequence([
			new AnimateTo(_anchorX, -200, 1, Ease.cubeOut),
			new CallFunction(() -> {
				_anchorX._ = 0;
				_anchorX.behavior = new Sine(-200, 200, 2);
			})
		]));
	}

	private var _root:Entity;
	private var _pack:AssetPack;
	private var _meterTime:Entity;
	private var _meterDrink:Entity;
	private var _barDrinks:Bar;
	private var _playButton:Button;
	private var _homeButton:Button;
	private var _background:Background;
	private var _thirstyPerson:ThirstyPerson;
	private var _thirstyArms:ThirstyArms;
	private var _liquid:Liquid;
	private var _disposer:Disposer;
	private var _anchorX = new AnimatedFloat(0);
	private var _anchorY = new AnimatedFloat(0);
	private var _rotation = new AnimatedFloat(0);
	private var _drinkAmount = 0.0;
	private var _timeElapsed = 0.0;
	private var _fillAmount = 0.0;
	private var _spillAmount = 0.0;
	private var _timeComplete = false;
	private var _reachX:Float = 0.0;
	private var _reachY:Float = 0.0;
	private var _cooldown:Float = 0.0;
	private var _isWarning = false;

	private static inline var TIME_DURATION = 30;
	private static inline var MAX_SPILL = 2;
	private static inline var FILL_MAX = 5;
}
