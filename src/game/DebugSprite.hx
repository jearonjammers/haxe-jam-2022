package game;

import game.cafe.ArmUtil;
import flambe.display.Graphics;
import flambe.display.Sprite;

class DebugSprite extends Sprite {
	public function new():Void {
		super();
	}

	override function draw(g:Graphics) {
		g.fillRect(0x333333, _xRect, _yRect, _widthRect, _heightRect);
		g.save();
		g.rotate(_anglesTri.top + 90);
		g.fillRect(0xff0000, _xTri, _yTri, 2, ArmUtil.SEGMENT_LENGTH_TOP);
		g.restore();
	}

	public function tri(x:Float, y:Float, angles:{top:Float, bottom:Float}):Void {
		_xTri = x;
		_yTri = y;
		_anglesTri.top = angles.top;
		_anglesTri.bottom = angles.bottom;
	}

	public function rect(x:Float, y:Float, width:Float, height:Float):Void {
		_xRect = x;
		_yRect = y;
		_widthRect = width;
		_heightRect = height;
	}

	private var _xTri:Float = 0;
	private var _yTri:Float = 0;
	private var _anglesTri:{top:Float, bottom:Float} = {top: 0, bottom: 0};

	private var _xRect:Float = 0;
	private var _yRect:Float = 0;
	private var _widthRect:Float = 0;
	private var _heightRect:Float = 0;
}
