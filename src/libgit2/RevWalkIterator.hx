package libgit2;
import cpp.RawPointer;
import libgit2.externs.LibGit2;

@:unreflective
@:access(libgit2.Oid)
@:access(libgit2.RevWalk)
class RevWalkIterator {
    private var _oid:Oid = new Oid();
    private var _walker:RevWalk;
    
    public function new(walker:RevWalk) {
        _walker = walker;
    }
    
    public function hasNext() {
        var r = LibGit2.git_revwalk_next(_oid.pointer, _walker.pointer);
        return (r == 0);
    }

    public function next():Oid {
        return _oid;
    }
}