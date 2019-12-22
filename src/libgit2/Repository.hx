package libgit2;

import cpp.RawPointer;
import libgit2.RevWalk.SortFlags;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitRepository;

@:headerClassCode('
static int credentialsCallback(git_cred ** cred, const char * url, const char * username_from_url, unsigned int allowed_types, void * payload) {
    if ((allowed_types & GIT_CREDTYPE_USERPASS_PLAINTEXT) != 0) {
        return git_cred_userpass_plaintext_new(cred, libgit2::Repository_obj::_currentUsername.c_str(), libgit2::Repository_obj::_currentPassword.c_str());
    } else {
        /* Some other kind of authentication was requested */
        return -1;
    }

    return 1; /* unable to provide authentication data */
}
')

@:unreflective
@:access(libgit2.Index)
@:access(libgit2.Oid)
@:access(libgit2.Signature)
@:access(libgit2.Tree)
@:access(libgit2.Remote)
class Repository extends Common {
    private var pointer:RawPointer<GitRepository> = null;
    
    private var _path:String;
    
    public var user:UserDetails = null;
    
    public function open(path:String) {
        var r = LibGit2.git_repository_open(RawPointer.addressOf(pointer), path);
        checkError(r);
        
        _path = path;
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
    
    public function commits(spec:String = "HEAD~10"):CommitIterator {
        var walker = createWalker(SortFlags.Time | SortFlags.Topological);
        var it = new CommitIterator(this, walker.iterator(spec));
        return it;
    }
    
    public var index(get, null):Index;
    private function get_index():Index {
        var i = new Index(this);
        var r = LibGit2.git_repository_index(RawPointer.addressOf(i.pointer), pointer);
        checkError(r);
        return i;
    }
    
    public function reference(name:String):Reference {
        var ref = new Reference(this, name);
        return ref;
    }
    
    public function addPath(path:String, index:Index = null) {
        var freeIndex = false;
        if (index == null) {
            index = this.index;
            freeIndex = true;
        }
        
        index.addPath(path);
        
        if (freeIndex == true) {
            index.free();
        }
    }
    
    public function createCommit(message:String, ref:String = "HEAD", author:Signature = null, committer:Signature = null, tree:Tree = null, parents:Array<Commit> = null):Commit {
        var freeAuthor = false;
        if (author == null) {
            author = user.signature;
            freeAuthor = true;
        }
        
        var freeCommitter = false;
        if (committer == null) {
            committer = user.signature;
            freeCommitter = true;
        }
        
        var freeTree = false;
        var index = null;
        if (tree == null) {
            index = this.index;
            tree = index.tree;
            freeTree = true;
        }
        
        var freeParents = false;
        if (parents == null) {
            var parentRef = reference(ref);
            parents = [];
            parents.push(parentRef.commit);
            freeParents = true;
        }

        var parentList:RawPointer<RawPointer<GitCommit>> = untyped __cpp__('new git_commit*[{0}]', parents.length);
        var n = 0;
        for (p in parents) {
            untyped __cpp__('{0}[{1}] = {2}', parentList, n, parents[n].pointer);
            n++;
        }
        var commitOid:Oid = new Oid();
        var r = LibGit2.git_commit_create(commitOid.pointer, pointer, ref, author.pointer, committer.pointer, null, message, tree.pointer, parents.length, untyped __cpp__("(const git_commit**)&parentList[0]"));
        checkError(r);
        
        untyped __cpp__('delete parentList');
        
        var commit = new Commit(this);
        commit.oid = commitOid;
        
        if (freeAuthor == true) {
            author.free();
        }
        
        if (freeCommitter == true) {
            committer.free();
        }
        
        if (freeTree == true) {
            tree.free();
            index.free();
        }
        
        if (freeParents == true) {
            for (p in parents) {
                p.free();
            }
        }
        
        return commit;
    }
    
    public function remote(name:String = "origin"):Remote {
        var r = new Remote(this);
        r.lookup(name);
        return r;
    }
    
    private static var _currentUsername:String = null;
    private static var _currentPassword:String = null;
    public function push(remoteName:String = "origin", refSpec:String = "HEAD:refs/heads/master") {
        var remote = remote(remoteName);
        
        var remoteCallbacks = GitRemoteCallbacks.alloc();
        var r = LibGit2.git_remote_init_callbacks(RawPointer.addressOf(remoteCallbacks), LibGit2RemoteCallbacks.REMOTE_CALLBACKS_VERSION);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote.pointer);
            throw error;
        }
        
        if (user != null) {
            _currentUsername = user.username;
            _currentPassword = user.password;
            remoteCallbacks.credentials = untyped __cpp__("&libgit2::Repository_obj::credentialsCallback");
        }
        
        var pushOptions = GitPushOptions.alloc();
        r = LibGit2.git_push_options_init(RawPointer.addressOf(pushOptions), LibGit2PushOptions.PUSH_OPTIONS_VERSION);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote.pointer);
            throw error;
        }
        
        pushOptions.callbacks = remoteCallbacks;
        
        var pushRefSpecs = new GitStrArrayBuilder();
        pushRefSpecs.build([refSpec]);
        r = LibGit2.git_remote_push(remote.pointer, RawPointer.addressOf(pushRefSpecs.native), RawPointer.addressOf(pushOptions));
        pushRefSpecs.free();
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote.pointer);
            throw error;
        }
        
        r = LibGit2.git_remote_upload(remote.pointer, null, RawPointer.addressOf(pushOptions));
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote.pointer);
            throw error;
        }
        
        LibGit2.git_remote_disconnect(remote.pointer);
        LibGit2.git_remote_free(remote.pointer);
    }
    
    public function stateCleanup() {
        var r = LibGit2.git_repository_state_cleanup(pointer);
        checkError(r);
    }
    
    public function reset(pathSpec:String = "HEAD") {
        var resetPathSpecs = new GitStrArrayBuilder();
        resetPathSpecs.build([pathSpec]);
        var r = LibGit2.git_reset_default(pointer, null, RawPointer.addressOf(resetPathSpecs.native));
        resetPathSpecs.free();
        checkError(r);
    }
}