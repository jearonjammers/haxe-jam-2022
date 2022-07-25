//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt
package flambe.platform.html;

import flambe.subsystem.WebSystem;
import flambe.web.WebView;

class HtmlWeb implements WebSystem {
	@:expose public var stack(default, null):Array<WebView>;

	public function new() {
		this.stack = [];
	}

	public function addView(comp:VueComponent, methods:Dynamic, props:Dynamic):WebView {
		var def = js.Syntax.code("{extends: {0}, methods: {1}}", comp.def, methods);
		var view = new VueWebView(def, props, this.stack);
		this.stack.push(view);
		return view;
	}
}

class VueWebView implements WebView {
	public var def(default, null):VueComponent;
	public var props(default, null):Dynamic;

	public function new(def:VueComponent, props:Dynamic, stack:Array<WebView>) {
		this.def = def;
		this.props = props;
		this._stack = stack;
	}

	public function dispose() {
		this._stack.remove(this);
	}

	private var _stack:Array<WebView>;
}
