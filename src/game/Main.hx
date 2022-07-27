package game;

import flambe.web.WebView;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.System;

class Main {
	static function main() {
		System.init();
	}

	public static var vueSplash = js.Lib.require("./src/components/Splash.vue");

	@:expose static function start(width:Int, height:Int):Void {
		var container = new Container(width, height);
		container.visible = false;
		System.root.add(container);
		System.stage.resize.connect(() -> {
			container.setSize(System.stage.width, System.stage.height);
		});
		System.stage.resize.emit();
		var bootstrap = Manifest.fromAssets("bootstrap");
		System.loadAssetPack(bootstrap).success.connect(onBootstrapLoaded.bind(width, height)).once();
	}

	static function onDev(width:Int, height:Int, pack:AssetPack):Void {
		var loader = new Loader(pack, width, height);
		System.root.add(loader);
		System.root.get(Container).visible = true;
		var main = Manifest.fromAssets("main");
		System.loadAssetPack(main).success.connect(mainPack -> {
			loader.dispose();
			onGameLoaded(width, height, mainPack);
		}).once();
	}

	static function onBootstrapLoaded(width:Int, height:Int, pack:AssetPack):Void {
		var splash:WebView = null;
		splash = System.web.addView(vueSplash, {
			onClick: () -> {
				// initialize audio
				pack.getSound("silence").play();
				// remove splash screen
				splash.dispose();
				var loader = new Loader(pack, width, height);

				System.root.add(loader);
				// show game container
				System.root.get(Container).visible = true;
				// load Main
				var main = Manifest.fromAssets("main");
				System.loadAssetPack(main).success.connect(mainPack -> {
					loader.dispose();
					onGameLoaded(width, height, mainPack);
				}).once();
			}
		}, {width: width, height: height});
	}

	static function onGameLoaded(width:Int, height:Int, pack:AssetPack):Void {
		System.root.add(new Game(pack, width, height));
	}
}
