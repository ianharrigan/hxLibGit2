package libgit2;

@:unreflective
class Error {
    public var code:Int;
    public var message:String;
    public var klass:Int;
    
    public function new() {
    }
    
    public function toString():String {
        return StringTools.trim(message) + " (class: " + klass + ", code: " + code + ")";
    }
}