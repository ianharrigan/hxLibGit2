package libgit2;

@:unreflective
class Signature extends Common {
    public var name:String;
    public var email:String;
    public var epochWhen:Int;
    
    public function new(name:String, email:String, epochWhen:Int) {
        super();
        this.name = name;
        this.email = email;
        this.epochWhen = epochWhen;
    }
    
    public function toString():String {
        return name + " (" + email + ") - " + epochWhen;
    }
}