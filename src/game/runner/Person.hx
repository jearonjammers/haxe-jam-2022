package game.runner;

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
		if (_hasFallen) {
			return;
		}
		_elapsed += dt;
		switch movetype {
			case Jump, Surf:
				if (_elapsed >= 1) {
					this.move(Walk);
				}
			case Crouch:
				if (_elapsed >= 0.5) {
					this.move(Walk);
				}
			case _:
		}
		if (_isDown) {
			this._velo += dt * _balanceMult;
		} else {
			this._velo -= dt * _balanceMult;
		}
		_balance += this._velo;
		handleRotation();
		if (_anchor.rotation._ == -MAX_ANGLE || _anchor.rotation._ == MAX_ANGLE) {
			hasFallen.emit();
			this.move(Idle);
			_hasFallen = true;
		}
	}

	private function handleRotation() {
		var b = FMath.clamp(_balance, -MAX_ANGLE, MAX_ANGLE);
		var scale = Ease.sineOut(Math.abs(b / MAX_ANGLE));
		_anchor.rotation._ = b < 0 ? MAX_ANGLE * -scale : MAX_ANGLE * scale;
		_legs.setBalance(-_anchor.rotation._);
	}

	private function init(pack:AssetPack) {
		this._root = new Entity();
		this._root //
			.add(_anchor = new Sprite().setXY(620, 980).setAnchor(0, 180)) //
			.addChild(new Entity() //
				.add(_lowerPivot = new Sprite()) //
				.add(_legs = new PersonLegs(pack, 0, 0)) //
				.addChild(new Entity() //
					.add(_upperPivot = new Sprite()) //
					.add(_torso = new PersonTorso(pack, 0, 0)) //
					.add(_head = new PersonHead(pack))));
	}

	public function move(type:PersonMoveType) {
		if (movetype == type || _hasFallen) {
			return;
		}
		var time = 0.4;
		movetype = type;
		_elapsed = 0;

		switch type {
			case Jump:
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
				_lowerPivot.anchorY.behavior = new Sine(0, 0, time / 2);
				_upperPivot.rotation.behavior = new Sine(-2, 2, time);
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

	private static inline var MAX_ANGLE = 80;
}
