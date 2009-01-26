import flash.external.ExternalInterface;

class util.Firebug {

  public static var depth:Number = 4;
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
  
  public static function setDepth(newDepth:Number):Void {
    depth = newDepth;
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
      return;
    }
    if (ExternalInterface.available) {
      var obj:Object = objectify(arguments, depth);
      ExternalInterface.call("trace", obj);
      //ExternalInterface.call("console.log", stringify(obj));
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
  public static function objectify(obj:Object,
                                   opt_depth:Number,
                                   opt_parent:Object,
                                   opt_key:String):Object {
    opt_depth--;
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

      case 'string':
      case 'undefined':
      case 'null':
      case 'boolean':
      case 'number':
        return obj;
      break;

      case 'function':
        var code:Number = -1;
        if (opt_key.substr(0, 3) == 'get') {
          code = opt_key.charCodeAt(3);          
        } else if (opt_key.substr(0, 2) == 'is') {
          code = opt_key.charCodeAt(2);
        }
        if (code >= "A".charCodeAt(0) && code <= "Z".charCodeAt(0)) {
          // Looks like a getter function
          return objectify(opt_parent[opt_key](), 0);
        }
      default:
        return obj.toString();
      break;
    }
    // Check for cycles: objects which point to visited objects.
    if (obj.hasOwnProperty("__visited")) {
      return "CYCLE DETECTED";
    } else if (opt_depth < 0) {
      return "TOO DEEP";
    }
    obj.__visited = true;
    _global['ASSetPropFlags'](obj, ["__visited"], 1);

    // Arrays and Objects come here: though they can be printed there may be
    //  entries which cannot be printed.
    for (var key:String in obj) {
      result[filterKey(key)] = objectify(obj[key], opt_depth, obj, key);
      if (result[key] == "TOO DEEP" || result[key] == "[type Function]") {
        delete result[key];
      }
    }

    // Unpollute the input.
    if (obj.hasOwnProperty("__visited")) {
      delete obj.__visited;
    }
    return result;
  }
  
  public static function stringify(obj:Object):String {
    var result:String = '{\n';
    var type:String = typeof(obj);
    switch (type) {
      case 'object':
      break;
      default:
        return obj.toString();
    }
    for (var key:String in obj) {
      result += key + ': ' + stringify(obj[key]) + ',\n';
    }
    return result + '}\n';
  }
  
  public static function filterKey(key:String):String {
    var filtered:String = '';
    var length:Number = key.length;
    var badString = false;
    for (var i = 0; i < length; i++) {
      var char:String = key.charAt(i);
      switch (char) {
        case ":":
          badString = true;
        //break;
        default:
          filtered += key.charAt(i);
        break;
      }
    }
    return badString? "'"+filtered+"'" : filtered;
  }

}

