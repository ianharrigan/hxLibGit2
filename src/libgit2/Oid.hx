package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.CharStar;
import libgit2.externs.LibGit2.GitOid;

class Oid extends Common {
    private var oid:GitOid;
    private var pointer:RawPointer<GitOid> = null;
    
    public function new(alloc:Bool = true) {
        super();
        if (alloc == true) {
            oid = GitOid.alloc();
            pointer = RawPointer.addressOf(oid);
        }
    }
    
    public var asString(get, null):String;
    private function get_asString():String {
        var oidstr = CharStar.alloc(42);
        LibGit2.git_oid_tostr(oidstr, 41, pointer);
        CharStar.free(oidstr);
        return new String(oidstr);
    }
    
    public function toString() {
        return asString;
    }
}