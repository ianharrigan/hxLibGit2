package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitRemote;

@:unreflective
@:access(libgit2.Repository)
class Remote extends Common {
    private var pointer:RawPointer<GitRemote> = null;
    
    public var repository:Repository;
    
    public function new(repository:Repository) {
        super();
        this.repository = repository;
    }
    
    public function lookup(name:String) {
        var r = LibGit2.git_remote_lookup(RawPointer.addressOf(pointer), repository.pointer, name);
        checkError(r);
    }
    
    public function disconnect() {
        LibGit2.git_remote_disconnect(pointer);
    }
    
    public override function free() {
        LibGit2.git_remote_free(pointer);
    }
}