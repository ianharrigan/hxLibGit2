package libgit2;

import cpp.RawConstPointer;
import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitRevWalk;
import libgit2.externs.LibGit2.LibGit2Flags;

class SortFlags {
    public static var None          = LibGit2Flags.GIT_SORT_NONE;
    public static var Topological   = LibGit2Flags.GIT_SORT_TOPOLOGICAL;
    public static var Time          = LibGit2Flags.GIT_SORT_TIME;
    public static var Reverse       = LibGit2Flags.GIT_SORT_REVERSE;
}

@:unreflective
@:access(libgit2.Repository)
@:access(libgit2.Oid)
class RevWalk extends Common {
    public var repository:Repository;
    
    private var pointer:RawPointer<GitRevWalk> = null;
        
    public function new(repository:Repository) {
        super();
        this.repository = repository;
        var r = LibGit2.git_revwalk_new(RawPointer.addressOf(pointer), repository.pointer);
        checkError(r);
    }
    
    public var sorting(null, set):Int;
    private function set_sorting(value:Int):Int {
        LibGit2.git_revwalk_sorting(pointer, value);
        return value;
    }
    
    public function pushHead() {
        var r = LibGit2.git_revwalk_push_head(pointer);
        checkError(r);
    }
    
    public function hideGlob(glob:String) {
        var r = LibGit2.git_revwalk_hide_glob(pointer, glob);
        checkError(r);
    }
    
    public function hide(oid:Oid) {
        LibGit2.git_revwalk_hide(pointer, oid.pointer);
    }
    
    public function iterator(spec:String):RevWalkIterator {
        var it = new RevWalkIterator(this);
        
        var parser = new RevParse(repository);
        var o = parser.single(spec);
        hide(o.oid);
        o.free();
        
        return it;
    }
}