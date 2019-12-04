package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitRepository;

@:unreflective
class Repository extends Common {
    private var _repo:RawPointer<GitRepository> = null;
    
    public function new() {
        super();
    }
    
    public function open(path:String) {
        var e = LibGit2.git_repository_open(RawPointer.addressOf(_repo), path);
        checkError(e);
    }
    
    public function createWalker(sorting:Null<Int> = null, pushHead:Bool = true, hideGlob:String = "tags/*"):RevWalk {
        var walker = new RevWalk(this);
        if (sorting != null) {
            walker.sorting = sorting;
        }
        if (pushHead == true) {
            walker.pushHead();
        }
        if (hideGlob != null) {
            walker.hideGlob(hideGlob);
        }
        return walker;
    }
}