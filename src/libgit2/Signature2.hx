package libgit2;

import cpp.ConstStar;
import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitSignature;

@:unreflective
class Signature2 extends Common {
    private var pointer:RawPointer<GitSignature> = null;
    
    public function new(name:String = null, email:String = null) {
        super();
        
        if (name != null && email != null) {
            var r = LibGit2.git_signature_now(RawPointer.addressOf(pointer), name, email);
            checkError(r);
        }
    }
    
    public var name(get, null):String;
    private function get_name():String {
        return untyped __cpp__("{0}->name", pointer);
    }
    
    public var email(get, null):String;
    private function get_email():String {
        return untyped __cpp__("{0}->email", pointer);
    }
    
    public var epochWhen(get, null):Int;
    private function get_epochWhen():Int {
        return untyped __cpp__("(int) {0}->when.time", pointer);
    }
    
    public override function free() {
        LibGit2.git_signature_free(pointer);
    }
}