//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package flambe.web;

import flambe.util.Disposable;

extern class VueComponent {
    @:native("default") var def: Dynamic;
}

interface WebView extends Disposable
{
    var def (default, null):VueComponent;
    var props (default, null):Dynamic;
}
