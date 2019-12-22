package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;

@:unreflective
@:access(libgit2.Repository)
@:access(libgit2.Object)
class RevParse extends Common {
    public var repository:Repository;
    
    public function new(repository:Repository) {
        super();
        this.repository = repository;
    }
    
    public function single(spec:String):Object {
        var o = new Object();
        
        var r = LibGit2.git_revparse_single(RawPointer.addressOf(o.pointer), repository.pointer, spec);
        checkError(r);
        
        return o;
    }
}