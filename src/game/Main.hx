package game;

import flambe.web.WebView;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.System;
import flambe.display.Sprite;

class Main {
	static function main() {
		System.init();
	}

	public static var vueSplash = js.Lib.require("./src/components/Splash.vue");
	public static var vueHelloWorld = js.Lib.require("./src/components/HelloWorld.vue");

	@:expose static function start(width:Int, height:Int):Void {
		var container = new Container(width, height);
		// container.visible = false;
		System.root.add(container);
		System.stage.resize.connect(() -> {
			container.setSize(System.stage.width, System.stage.height);
		});
		System.stage.resize.emit();
		var mainManifest = Manifest.fromAssets("main");
		System.loadAssetPack(mainManifest).success.connect(onLoaded.bind(width, height)).once();
	}

	static function onLoaded(width:Int, height:Int, pack:AssetPack):Void {
		System.root.add(new Game(pack, width, height));
	}
}
