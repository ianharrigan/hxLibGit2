package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitRevWalk;

class SortFlags {
    public static var None          = LibGit2Flags.GIT_SORT_NONE;
    public static var Topological   = LibGit2Flags.GIT_SORT_TOPOLOGICAL;
    public static var Time          = LibGit2Flags.GIT_SORT_TIME;
    public static var Reverse       = LibGit2Flags.GIT_SORT_REVERSE;
}

@:unreflective
@:access(libgit2.Repository)
class RevWalk extends Common {
    public var repository:Repository;
    
    private var _walker:RawPointer<GitRevWalk> = null;
        
    public function new(repository:Repository) {
        super();
        this.repository = repository;
        var r = LibGit2.git_revwalk_new(RawPointer.addressOf(_walker), repository._repo);
        checkError(r);
    }
    
    public var sorting(null, set):Int;
    private function set_sorting(value:Int):Int {
        LibGit2.git_revwalk_sorting(_walker, value);
        return value;
    }
    
    public function pushHead() {
        LibGit2.git_revwalk_push_head(_walker);
    }
    
    public function hideGlob(glob:String) {
        LibGit2.git_revwalk_hide_glob(_walker, glob);
    }

    public function start(spec:String) {
        var obj:RawPointer<GitObject> = null;
        LibGit2.git_revparse_single(RawPointer.addressOf(obj), repository._repo, spec);
        LibGit2.git_revwalk_hide(_walker, LibGit2.git_object_id(obj));
        LibGit2.git_object_free(obj);
        if (_currentCommit != null) {
            _currentCommit.free();
            _currentCommit = null;
        }
    }
    
    private var _currentOid:GitOid = GitOid.alloc();
    public function next():Bool {
        if (_currentCommit != null) {
            _currentCommit.free();
            _currentCommit = null;
        }
        var r = (LibGit2.git_revwalk_next(RawPointer.addressOf(_currentOid), _walker) == 0);
        var pCommit:RawPointer<GitCommit> = null;
        var e = LibGit2.git_commit_lookup(RawPointer.addressOf(pCommit), repository._repo, RawPointer.addressOf(_currentOid));
        checkError(e);
        _currentCommit = Commit.fromPointer(pCommit, _currentOid);
        return r;
    }
    
    private var _currentCommit:Commit = null;
    public var commit(get, null):Commit;
    private function get_commit():Commit {
        return _currentCommit;
    }
}