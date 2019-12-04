package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitCommit;

@:unreflective
class Commit extends Common {
    private var _commit:RawPointer<GitCommit> = null;
    
    public function new() {
        super();
    }
    
    private var _oid:String = null;
    public var oid(get, null):String;
    private function get_oid():String {
        return _oid;
    }
    
    private var _message:String;
    public var message(get, null):String;
    private function get_message():String {
        return StringTools.trim(_message);
    }
    
    public var author:Signature = null;
    public var committer:Signature = null;
    
    public override function free() {
        super.free();
        if (_commit != null) {
            LibGit2.git_commit_free(_commit);
            _commit = null;
        }
    }
    
    public static function fromPointer(p:RawPointer<GitCommit>, oid:GitOid):Commit {
        var commit = new Commit();
        commit._commit = p;
        
        var oidstr = CharStar.alloc(10);
        LibGit2.git_oid_tostr(oidstr, 9, RawPointer.addressOf(oid));
        commit._oid = new String(oidstr);
        CharStar.free(oidstr);
        
        commit._message = LibGit2.git_commit_message(p);
        
        var author = LibGit2.git_commit_author(p);
        if (author != null) {
            commit.author = new Signature(author.name, author.email, untyped __cpp__("(int){0}", author.when.time));
        }
        var committer = LibGit2.git_commit_committer(p);
        if (committer != null) {
            commit.committer = new Signature(committer.name, committer.email, untyped __cpp__("(int){0}", committer.when.time));
        }
        
        return commit;
    }
}