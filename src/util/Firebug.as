import flash.external.ExternalInterface;

class util.Firebug {

  public static var level:Number = 0;
  public static var types:Object = {
    debug: 0,
    info: 1,
    warn: 2,
    error: 3
  }

  /**
   * Use getter/setter.
   * TODO: Verify performance is comparable.
   */
  public static function setLevel(newLevel:String):Void {
    level = types[newLevel];
  }

  public static function out():Void {
    
    var type:String = arguments[0];
    // out expects "warn", "info", etc as first argument.
    if (types[type] == undefined) {
      // Set if needed.
      type = "debug";
      arguments.unshift(type);
    }
    // Only trace messages above a certain level.
    if (types[type] < level) {
      //return;
    }
    if (ExternalInterface.available) {
      ExternalInterface.call("trace", objectify(arguments));
    } else if (trace != Firebug.out) {
      // Remove output type from args.
      arguments.shift();
      trace(type + ": " + arguments.join(', '));
    }
  }

  public static function debug():Void {
    arguments.unshift("debug");
    out.apply(Firebug, arguments);
  }

  // Does its best to convert all sorts of data types into something JS can
  // handle. Almost a JSON serialize function in that its output is JSON-like
  // but still an object (not a string).
  public static function objectify(obj:Object):Object {
    // Handles all primitive values which can be "false". (or undefined!)
    if (arguments.length > 1) {
      return objectify(arguments);
    }
    var result:Object;
    var type:String = (obj instanceof Array) ? 'array' : String(typeof(obj));
    switch (type) {
      case 'array':
        result = [];
      break;

      case 'object':
        result = {};
      break;

      case 'movieclip':
        result = {
          __type: type,
          __path: obj + ""
        };
      break;

      case 'undefined':
      case 'null':
      case 'boolean':
        return obj;
      break;

      default:
        return obj.toString();
      break;
    }
    // Check for cycles: objects which point to visited objects.
    if (obj.hasOwnProperty("__visited")) {
      return "CYCLE DETECTED";
    }
    obj.__visited = true;
    _global['ASSetPropFlags'](obj, ["__visited"], 1);

    // Arrays and Objects come here: though they can be printed there may be
    //  entries which cannot be printed.
    for (var key:String in obj) {
      result[key] = objectify(obj[key]);
    }

    // Unpollute the input.
    if (obj.hasOwnProperty("__visited")) {
      delete obj.__visited;
    }
    return result;
  }

}

