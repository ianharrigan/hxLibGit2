package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitCommit;

@:unreflective
@:access(libgit2.Repository2)
@:access(libgit2.Oid)
@:access(libgit2.Signature2)
class Commit2 extends Common {
    private var pointer:RawPointer<GitCommit> = null;
    
    public var repository:Repository2;
    
    public var oid:Oid;
    
    public function new(repository:Repository2) {
        super();
        this.repository = repository;
    }
    
    public override function free() {
        if (pointer != null) {
            LibGit2.git_commit_free(pointer);
            pointer = null;
        }
    }
    
    public function lookup(oid:Oid) {
        free();
        var r = LibGit2.git_commit_lookup(RawPointer.addressOf(pointer), repository.pointer, oid.pointer);
        checkError(r);
        this.oid = oid;
    }
    
    public var message(get, null):String;
    private function get_message():String {
        return LibGit2.git_commit_message(pointer);
    }
    
    public var author(get, null):Signature2;
    private function get_author():Signature2 {
        var sig = new Signature2();
        sig.pointer = untyped __cpp__("(git_signature *){0}", LibGit2.git_commit_author(pointer));
        return sig;
    }
    
    public var committer(get, null):Signature2;
    private function get_committer():Signature2 {
        var sig = new Signature2();
        sig.pointer = untyped __cpp__("(git_signature *){0}", LibGit2.git_commit_committer(pointer));
        return sig;
    }
}