//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package flambe.platform.html;

import flambe.util.Logger;

class HtmlLogHandler
    implements LogHandler
{
    public static function isSupported () :Bool
    {
        return js.Syntax.plainCode("typeof console") == "object" && js.Syntax.plainCode("console").info != null;
    }

    public function new (tag :String)
    {
        _tagPrefix = tag + ": ";
    }

    public function log (level :LogLevel, message :String)
    {
        message = _tagPrefix + message;

        switch (level) {
        case Info:
            (js.Syntax.plainCode("console")).info(message);
        case Warn:
            (js.Syntax.plainCode("console")).warn(message);
        case Error:
            (js.Syntax.plainCode("console")).error(message);
        }
    }

    private var _tagPrefix :String;
}
