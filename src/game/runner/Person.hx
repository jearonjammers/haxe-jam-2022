package game.runner;

import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Sequence;
import flambe.script.Script;
import flambe.display.ImageSprite;
import flambe.animation.Ease;
import flambe.util.Signal0;
import flambe.math.FMath;
import flambe.animation.Sine;
import flambe.display.Sprite;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.Component;

class Person extends Component {
	public var movetype:PersonMoveType = PersonMoveType.Crouch;
	public var hasFallen:Signal0 = new Signal0();

	public function new(pack:AssetPack) {
		this.init(pack);
	}

	override function onAdded() {
		owner.addChild(this._root);
	}

	override function onRemoved() {
		owner.removeChild(this._root);
	}

	override function onUpdate(dt:Float) {
		if (_hasFallen || _isSturdy) {
			return;
		}
		_elapsed += dt;
		switch movetype {
			case Jump:
				if (_elapsed >= JUMP_DURATION) {
					this.move(Walk);
					this._anchor.y._ = FLOOR_Y;
				} else {
					var jumpProgress = _elapsed / JUMP_DURATION;
					if (jumpProgress <= 0.5) {
						var p = Ease.cubeOut(jumpProgress * 2);
						var height = p * JUMP_HEIGHT;
						this._anchor.y._ = FLOOR_Y - height;
					} else {
						var p = Ease.expoOut(1 - (jumpProgress * 2 - jumpProgress));
						var height = p * JUMP_HEIGHT;
						this._anchor.y._ = FLOOR_Y - height;
					}
				}
			case Surf:
				if (_elapsed >= SURF_DURATION) {
					this.move(Walk);
				}
			case Crouch:
				if (_elapsed >= CROUCH_DURATION) {
					this.move(Walk);
				}
			case _:
		}
		if (_startMult < 1) {
			_startMult = FMath.clamp(_startMult + dt * 0.5, 0, 1);
		}
		if (movetype == Surf) {
			_balanceMult += dt * 1.5;
		} else {
			_balanceMult *= 0.98;
		}
		_balanceMult = FMath.clamp(_balanceMult, 1, 10);
		if (_isDown) {
			this._velo += dt * 1.25 * _startMult * _balanceMult;
		} else {
			this._velo -= dt * 1.25 * _startMult * _balanceMult;
		}
		_balance += this._velo;
		handleRotation();
		if (_anchor.rotation._ == -MAX_ANGLE || _anchor.rotation._ == MAX_ANGLE) {
			hasFallen.emit();
			this.move(Idle);
			this._anchor.y.animateTo(FLOOR_Y, 0.25, Ease.bounceOut);
			_hasFallen = true;
		}
	}

	private function handleRotation() {
		var b = FMath.clamp(_balance, -MAX_ANGLE, MAX_ANGLE);
		var scale = Ease.sineOut(Math.abs(b / MAX_ANGLE));
		if (scale > 0.999) {
			scale = 1;
		} else if (scale < 0.0001) {
			scale = 0;
		}
		_anchor.rotation._ = b < 0 ? MAX_ANGLE * -scale : MAX_ANGLE * scale;
		_legs.setBalance(-_anchor.rotation._);
	}

	private function init(pack:AssetPack) {
		this._root = new Entity();
		this._root //
			.add(_anchor = new Sprite().setXY(620, FLOOR_Y).setAnchor(0, 180)) //
			.addChild(new Entity() //
				.add(_lowerPivot = new Sprite()) //
				.add(_legs = new PersonLegs(pack, 0, 0)) //
				.addChild(new Entity() //
					.add(_upperPivot = new Sprite()) //
					.add(_torso = new PersonTorso(pack, 0, 0)) //
					.add(_head = new PersonHead(pack)))
				.add(this._liquid = new Liquid(pack, "runner"))); //

		this._liquid.setXY(50, -100, 130, 0);
		this._liquid.visible = false;

		this._root //
			.addChild(new Entity() //
				.add(_instruct1 = new ImageSprite(pack.getTexture("runner/instructMove")).setXY(120, -300))) //
			.addChild(new Entity() //
				.add(_instruct2 = new ImageSprite(pack.getTexture("runner/instructSurf")).setXY(120, -340))); //
		_instruct2.visible = false;

		this._root.add(new Script()).get(Script).run(new Sequence([new Delay(3), new CallFunction(handleInstruct1)]));
	}

	private function handleInstruct1():Void {
		if (!_hasHandledInstruct1) {
			_instruct1.visible = false;
			_instruct2.visible = true;
			_hasHandledInstruct1 = true;
		}
	}

	private function handleInstruct2():Void {
		if (_hasHandledInstruct1 && !_hasHandledInstruct2) {
			_instruct2.visible = false;
			_hasHandledInstruct2 = true;
		}
	}

	public function move(type:PersonMoveType) {
		if (movetype == type || _hasFallen || _isSturdy) {
			return;
		}
		this._liquid.visible = false;
		var time = 0.4;
		movetype = type;
		_elapsed = 0;

		switch type {
			case Jump:
				Audio.playSound_("sfx/runner/jump");
				_lowerPivot.anchorY.behavior = new Sine(0, 0, time);
				_upperPivot.rotation.behavior = new Sine(-20, 2, time * 2);
			case Crouch:
				var offsetY = -72;
				_lowerPivot.anchorY.behavior = new Sine(0 + offsetY, 5 + offsetY, time / 2);
				_upperPivot.rotation.behavior = new Sine(45, 20, time / 2);
			case Walk:
				_lowerPivot.anchorY.behavior = new Sine(0, 5, time / 2);
				_upperPivot.rotation.behavior = new Sine(15, 8, time / 2);
			case Surf:
				Audio.playSound_("sfx/runner/crouch");
				_lowerPivot.anchorY.behavior = new Sine(0, 0, time / 2);
				_upperPivot.rotation.behavior = new Sine(-2, 2, time);
				this._liquid.visible = true;
				handleInstruct2();
			case Idle:
				_lowerPivot.anchorY.behavior = new Sine(0, 0, time / 2);
				_upperPivot.rotation.behavior = new Sine(-2, 2, time);
		}
		_head.move(type, time);
		_legs.move(type, time);
		_torso.move(type, time);
	}

	public inline function press() {
		_isDown = true;
	}

	public inline function lift() {
		_isDown = false;
	}

	public inline function sturdy() {
		_balance = 0;
		this.move(Walk);
		handleRotation();
		_isSturdy = true;
	}

	private var _legs:PersonLegs;
	private var _torso:PersonTorso;
	private var _head:PersonHead;
	private var _root:Entity;
	private var _anchor:Sprite;
	private var _lowerPivot:Sprite;
	private var _upperPivot:Sprite;
	private var _elapsed:Float = 0;
	private var _isDown:Bool = false;
	private var _hasFallen:Bool = false;
	private var _balance:Float = 0;
	private var _velo:Float = 0;
	private var _balanceMult:Float = 1;
	private var _startMult:Float = 0;
	private var _isSturdy:Bool = false;
	private var _liquid:Liquid;
	private var _instruct1:Sprite;
	private var _instruct2:Sprite;
	private var _hasHandledInstruct1:Bool = false;
	private var _hasHandledInstruct2:Bool = false;

	private static inline var MAX_ANGLE = 80;
	private static inline var JUMP_DURATION = 1;
	private static inline var SURF_DURATION = 1;
	private static inline var CROUCH_DURATION = 0.5;
	private static inline var FLOOR_Y = 980;
	private static inline var JUMP_HEIGHT = 500;
}
