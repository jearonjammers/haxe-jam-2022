package game;

import flambe.display.Graphics;
import flambe.math.Rectangle;
import flambe.display.Sprite;

class Container extends Sprite {
	public function new(width:Int, height:Int):Void {
		super();
		this._width = width;
		this._height = height;
		this.scissor = new Rectangle(0, 0, this._width, this._height);
	}

	override public function getNaturalWidth():Float {
		return this._width;
	}

	override public function getNaturalHeight():Float {
		return this._height;
	}

	override function draw(g:Graphics) {
		g.fillRect(0xcccccc, 0, 0, this._width, this._height);
	}

	@:expose public static function getSize(imgWidth:Int, imgHeight:Int, containerWidth:Int, containerHeight:Int):{x:Float, y:Float, scale:Float} {
		var imgRatio = (imgHeight / imgWidth); // original img ratio
		var containerRatio = (containerHeight / containerWidth); // container ratio

		var finalWidth = 0.0; // the scaled img width
		var finalHeight = 0.0;

		if (containerRatio < imgRatio) {
			finalHeight = containerHeight;
			finalWidth = (containerHeight / imgRatio);
		} else {
			finalWidth = containerWidth;
			finalHeight = (containerWidth * imgRatio);
		}

		_scratch.scale = finalWidth / imgWidth;
		_scratch.x = (containerWidth - finalWidth) / 2;
		_scratch.y = (containerHeight - finalHeight) / 2;

		return _scratch;
	}

	public function setSize(containerWidth:Int, containerHeight:Int):Container {
		var size = getSize(this._width, this._height, containerWidth, containerHeight);
		this.setScale(size.scale);
		this.setXY(size.x, size.y);

		return this;
	}

	private var _width:Int;
	private var _height:Int;
	private static var _scratch:{x:Float, y:Float, scale:Float} = {x: 0, y: 0, scale: 1};
}
