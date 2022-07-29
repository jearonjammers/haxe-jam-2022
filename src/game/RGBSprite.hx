package game;

import flambe.math.FMath;
import flambe.display.Graphics;
import flambe.display.Sprite;

class RGBSprite extends Sprite {
	public function new(r1:Float, g1:Float, b1:Float, r2:Float, g2:Float, b2:Float, width:Float, height:Float) {
		super();
		_percent = 1;
		_r1 = r1;
		_g1 = g1;
		_b1 = b1;
		_r2 = r2;
		_g2 = g2;
		_b2 = b2;
		_width = width;
		_height = height;
	}

	override public function draw(g_:Graphics) {
		var decColor = (r() << 16) + (g() << 8) + b();
		g_.fillRect(decColor, 0, 0, _width, _height);
	}

	override public function getNaturalWidth():Float {
		return _width;
	}

	override public function getNaturalHeight():Float {
		return _height;
	}

	public function setPercent(p:Float):Void {
		_percent = FMath.clamp(p, 0, 1);
	}

	private function r():Int {
		var p1 = _percent;
		var p2 = 1 - p1;
		return Math.round(p1 * _r1 + p2 * _r2);
	}

	private function g():Int {
		var p1 = _percent;
		var p2 = 1 - p1;
		return Math.round(p1 * _g1 + p2 * _g2);
	}

	private function b():Int {
		var p1 = _percent;
		var p2 = 1 - p1;
		return Math.round(p1 * _b1 + p2 * _b2);
	}

	private var _percent:Float;
	private var _r1:Float;
	private var _g1:Float;
	private var _b1:Float;
	private var _r2:Float;
	private var _g2:Float;
	private var _b2:Float;
	private var _width:Float;
	private var _height:Float;
}
