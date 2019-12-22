package libgit2;
import cpp.RawPointer;
import libgit2.externs.LibGit2;

@:unreflective
@:access(libgit2.Repository)
@:access(libgit2.Oid)
class Reference extends Common {
    public var repository:Repository;
    public var name:String;
    
    public function new(repository:Repository, name:String) {
        super();
        this.repository = repository;
        this.name = name;
    }
    
    public var oid(get, null):Oid;
    private function get_oid():Oid {
        var oid = new Oid();
        var r = LibGit2.git_reference_name_to_id(oid.pointer, repository.pointer, name);
        checkError(r);
        return oid;
    }
    
    public var commit(get, null):Commit;
    private function get_commit():Commit {
        var c = new Commit(repository);
        c.lookup(oid);
        return c;
    }
}