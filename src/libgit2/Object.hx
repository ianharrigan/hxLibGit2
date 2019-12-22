package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitObject;

@:unreflective
@:access(libgit2.Oid)
class Object extends Common {
    var pointer:RawPointer<GitObject> = null;
    
    public var oid(get, null):Oid;
    private function get_oid():Oid {
        var oid = new Oid(false);
        oid.pointer = untyped __cpp__("(git_oid *){0}", LibGit2.git_object_id(pointer));
        return oid;
    }
    
    public override function free() {
        LibGit2.git_object_free(pointer);
    }
}