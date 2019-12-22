package libgit2;

import cpp.ConstCharStar;
import cpp.NativeArray;
import cpp.Pointer;
import cpp.RawPointer;
import libgit2.Callbacks.UsernamePassword;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitRepository;
import sys.FileSystem;
import sys.io.File;

@:headerClassCode('
static int my_git_cred_cb(git_cred ** cred, const char * url, const char * username_from_url, unsigned int allowed_types, void * payload) {
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
class Repository extends Common {
    private var _repo:RawPointer<GitRepository> = null;
    
    private static var _currentUsername:String = null;
    private static var _currentPassword:String = null;
    
    public var plainTextCredentials:UsernamePassword = null;
    
    public function new() {
        super();
    }

    private var _callbacks:Callbacks;
    public var callbacks(get, set):Callbacks;
    private function get_callbacks():Callbacks {
        if (_callbacks == null) {
            _callbacks = new Callbacks();
        }
        return _callbacks;
    }
    private function set_callbacks(value:Callbacks):Callbacks {
        _callbacks = value;
        return value;
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
    
    
    // this works!
    public function fullTest() {
        var localBranch = "HEAD";
        var remoteBranch = "refs/heads/master";
        
        var sig:RawPointer<GitSignature> = null;
        var r = LibGit2.git_signature_now(RawPointer.addressOf(sig), "Ian Harrigan", "ianharrigan@hotmail.com");
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        
        var index:RawPointer<GitIndex> = null;
        var r = LibGit2.git_repository_index(RawPointer.addressOf(index), _repo);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_signature_free(sig);
            throw error;
        }

        
        // this adds a file
        File.saveContent("C:\\Work\\Personal\\TestPrivateRepo\\test_my_file.txt", "" + Date.now());
        var r = LibGit2.git_index_add_bypath(index, "test_my_file.txt");
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_index_free(index);
            LibGit2.git_signature_free(sig);
            throw error;
        }
        
        var tree_oid = GitOid.alloc();
        var r = LibGit2.git_index_write_tree(RawPointer.addressOf(tree_oid), index);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_index_free(index);
            LibGit2.git_signature_free(sig);
            throw error;
        }

        var tree:RawPointer<GitTree> = null;
        r = LibGit2.git_tree_lookup(RawPointer.addressOf(tree), _repo, RawPointer.addressOf(tree_oid));
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_index_free(index);
            LibGit2.git_signature_free(sig);
            throw error;
        }
        
        
        var parent_oid = GitOid.alloc();
        var r = LibGit2.git_reference_name_to_id(RawPointer.addressOf(parent_oid), _repo, localBranch);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_tree_free(tree);
            LibGit2.git_index_free(index);
            LibGit2.git_signature_free(sig);
            throw error;
        }
        
        var parent:RawPointer<GitCommit> = null;
        var r = LibGit2.git_commit_lookup(RawPointer.addressOf(parent), _repo, RawPointer.addressOf(parent_oid));
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_tree_free(tree);
            LibGit2.git_index_free(index);
            LibGit2.git_signature_free(sig);
            throw error;
        }
        
        
        var oid_commit = GitOid.alloc();
        r = LibGit2.git_commit_create(RawPointer.addressOf(oid_commit), _repo, localBranch, sig, sig, null, "some message10101010101 - " + Date.now(), tree, 1, untyped __cpp__("(const git_commit**)&parent"));
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_commit_free(parent);
            LibGit2.git_tree_free(tree);
            LibGit2.git_index_free(index);
            LibGit2.git_signature_free(sig);
            throw error;
        }

        LibGit2.git_commit_free(parent);
        LibGit2.git_tree_free(tree);
        LibGit2.git_index_free(index);
        LibGit2.git_signature_free(sig);
        
        
        
        
        
        
        
        var remoteName = "origin";
        
        // PUSH
        var remote:RawPointer<GitRemote> = null;
        var r = LibGit2.git_remote_lookup(RawPointer.addressOf(remote), _repo, remoteName);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }

        var cbs = GitRemoteCallbacks.alloc();
//        r = LibGit2.git_remote_init_callbacks(RawPointer.addressOf(cbs), untyped __cpp__("GIT_REMOTE_CALLBACKS_VERSION"));
        r = LibGit2.git_remote_init_callbacks(RawPointer.addressOf(cbs), LibGit2RemoteCallbacks.REMOTE_CALLBACKS_VERSION);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote);
            throw error;
        }
        
        if (plainTextCredentials == null && callbacks.plaintextCredentials != null) {
            plainTextCredentials = callbacks.plaintextCredentials();
        }
        
        _currentUsername = plainTextCredentials.username;
        _currentPassword = plainTextCredentials.password;
        
        cbs.credentials = untyped __cpp__("&libgit2::Repository_obj::my_git_cred_cb");
        
        
        var options = GitPushOptions.alloc();
//        r = LibGit2.git_push_options_init(RawPointer.addressOf(options), untyped __cpp__("GIT_PUSH_OPTIONS_VERSION"));
        r = LibGit2.git_push_options_init(RawPointer.addressOf(options), LibGit2PushOptions.PUSH_OPTIONS_VERSION);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote);
            throw error;
        }
        
        options.callbacks = cbs;
        

        var pushRefSpecs = new GitStrArrayBuilder();
        pushRefSpecs.build([localBranch + ":" + remoteBranch]);
        r = LibGit2.git_remote_push(remote, RawPointer.addressOf(pushRefSpecs.native), RawPointer.addressOf(options));
        pushRefSpecs.free();
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote);
            throw error;
        }
        
        
        
        r = LibGit2.git_remote_upload(remote, null, RawPointer.addressOf(options));
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote);
            throw error;
        }
        
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote);
            throw error;
        }
        
        r = LibGit2.git_repository_state_cleanup(_repo);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote);
            throw error;
        }
        
        var resetPathSpecs = new GitStrArrayBuilder();
        resetPathSpecs.build([localBranch]);
        r = LibGit2.git_reset_default(_repo, null, RawPointer.addressOf(resetPathSpecs.native));
        resetPathSpecs.free();
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_remote_free(remote);
            throw error;
        }
        
        LibGit2.git_remote_disconnect(remote);
        LibGit2.git_remote_free(remote);
    }
    
    
    private function createCommit() {
        var sig:RawPointer<GitSignature> = null;
        var r = LibGit2.git_signature_now(RawPointer.addressOf(sig), "Ian Harrigan", "ianharrigan@hotmail.com");
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        
        var index:RawPointer<GitIndex> = null;
        var r = LibGit2.git_repository_index(RawPointer.addressOf(index), _repo);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }

        
        // this adds a file
        File.saveContent("C:\\Work\\Personal\\TestPrivateRepo\\test_my_file.txt", "" + Date.now());
        
var r = LibGit2.git_index_add_bypath(index, "test_my_file.txt");
var error = checkError(r, false);
if (error != null) {
    throw error;
}
        
        

        var tree_oid = GitOid.alloc();
        var r = LibGit2.git_index_write_tree(RawPointer.addressOf(tree_oid), index);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }

        var tree:RawPointer<GitTree> = null;
        r = LibGit2.git_tree_lookup(RawPointer.addressOf(tree), _repo, RawPointer.addressOf(tree_oid));
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        
        var parent_oid = GitOid.alloc();
        var r = LibGit2.git_reference_name_to_id(RawPointer.addressOf(parent_oid), _repo, "HEAD");
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        var parent:RawPointer<GitCommit> = null;
        var r = LibGit2.git_commit_lookup(RawPointer.addressOf(parent), _repo, RawPointer.addressOf(parent_oid));
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        
        var oid_commit = GitOid.alloc();
        var x = [parent];
        r = LibGit2.git_commit_create(RawPointer.addressOf(oid_commit), _repo, "HEAD", sig, sig, null, "some message99999 - " + Date.now(), tree, 1, untyped __cpp__("(const git_commit**)&parent"));
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        LibGit2.git_repository_state_cleanup(_repo);
    }
    
    public function test2() {
        createCommit();
        //open("C:\\Work\\Personal\\TestPrivateRepo\\");
        test();
    }
    
    public function test() {
        
        /*

        
        */
        
        
        
        /*
        createCommit();
        return;
        */
        
        
        
        
        
        
        
        
        
        
        
        
        // push it
        var remote:RawPointer<GitRemote> = null;
        var r = LibGit2.git_remote_lookup(RawPointer.addressOf(remote), _repo, "origin");
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }

        trace("--------------------------------> here");
        untyped __cpp__("printf(\"THIS IS A TEST\\n\")");
        var cbs = GitRemoteCallbacks.alloc();
        r = LibGit2.git_remote_init_callbacks(RawPointer.addressOf(cbs), untyped __cpp__("GIT_REMOTE_CALLBACKS_VERSION"));
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        cbs.credentials = untyped __cpp__("&my_git_cred_cb");
        
        
        
        /*
        r = LibGit2.git_remote_connect(remote, untyped __cpp__("GIT_DIRECTION_PUSH"), RawPointer.addressOf(cbs), null, null);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        */

        /*
        var strarray:GitStrArray = GitStrArray.alloc();
        
        r = LibGit2.git_remote_get_push_refspecs(RawPointer.addressOf(strarray), remote);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }

        trace("------------------------------------------> RSPEC COUNT: " + Std.int(strarray.count));
        if (strarray.count > 0) {
            for (i in 0...strarray.count) {
                untyped __cpp__('printf("------------------------------- REF{0}> %s\\n", strarray.strings[{0}])', i);
            }
        }
        trace("bo2222222222222222222222222222222222222222222222222222222222222b  ");
        trace(LibGit2.git_remote_name(remote));
        */
        
        //return;
        
//        r = LibGit2.git_remote_add_push(_repo, "origin", "refs/heads/master");
//        r = LibGit2.git_remote_add_push(_repo, "origin", "refs/heads/master:refs/heads/master");
//        var refspec = "refs/heads/master:refs/remotes/origin/master";
/*
        var refspec = "refs/heads/master";
        var refspec = "refs/remotes/origin/master";
        var refspec = "refs/heads/master:refs/heads/master";
//        var refspec = "refs/heads/master:refs/remotes/origin/master";
//        var refspec = "refs/heads/master";
        trace("------------------------------------- REFSPEC: " + refspec);
        //r = LibGit2.git_remote_add_push(_repo, "origin", refspec);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }

        
        
            //var refspec = "refs/heads/master";
            var refspec = "refs/heads/master:refs/heads/master";
            //r = LibGit2.git_remote_add_push(_repo, "origin", refspec);
            var error = checkError(r, false);
            if (error != null) {
                throw error;
            }
        
        
        //for (i in 0...1) {
            var refspec = "refs/heads/master";
            //var refspec = "refs/heads/master:refs/heads/master";
            var refspec = ":refs/remotes/origin/master";
            r = LibGit2.git_remote_add_push(_repo, "origin", refspec);
            var error = checkError(r, false);
            if (error != null) {
                throw error;
            }
        //}
        */
        trace("--------------------------------> here");
        var options = GitPushOptions.alloc();
        r = LibGit2.git_push_options_init(RawPointer.addressOf(options), untyped __cpp__("GIT_PUSH_OPTIONS_VERSION"));
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        options.callbacks = cbs;
        
        untyped __cpp__('char *refspec = "HEAD:refs/heads/master";');
        untyped __cpp__('git_strarray refspecs = {&refspec, 1}');
        r = LibGit2.git_remote_push(remote, untyped __cpp__('&refspecs'), RawPointer.addressOf(options));
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        
        
        //options.callbacks = untyped __cpp__("{}");
        //options.callbacks.credentials = untyped __cpp__("&my_git_cred_cb");
        r = LibGit2.git_remote_upload(remote, null, RawPointer.addressOf(options));
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        LibGit2.git_remote_disconnect(remote);
        LibGit2.git_remote_free(remote);
        
        
        
        r = LibGit2.git_repository_state_cleanup(_repo);
        
        untyped __cpp__('char *refspec2 = "HEAD";');
        untyped __cpp__('git_strarray refspecs2 = {&refspec2, 1}');
        r = LibGit2.git_reset_default(_repo, null, untyped __cpp__('&refspecs2'));
        
        //FileSystem.deleteFile("C:\\Work\\Personal\\TestPrivateRepo\\test_my_file.txt");
        
        
        /*
        var sig:RawPointer<GitSignature> = null;
        var r = LibGit2.git_signature_now(RawPointer.addressOf(sig), "Ian Harrigan", "ianharrigan@hotmail.com");
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        
        var index:RawPointer<GitIndex> = null;
        var r = LibGit2.git_repository_index(RawPointer.addressOf(index), _repo);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }

        var r = LibGit2.git_index_add_bypath(index, "test_my_file.txt");
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        var entry = LibGit2.git_index_get_byindex(index, 0);
        
        var tree_oid = GitOid.alloc();
        var r = LibGit2.git_index_write_tree(RawPointer.addressOf(tree_oid), index);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        var tree:RawPointer<GitTree> = null;
        r = LibGit2.git_tree_lookup(RawPointer.addressOf(tree), _repo, RawPointer.addressOf(tree_oid));
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        var oid_commit = GitOid.alloc();
        r = LibGit2.git_commit_create(RawPointer.addressOf(oid_commit), _repo, "HEAD", sig, sig, null, "some message", tree, 0, null);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
            */
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        /*
        var oid_blob = GitOid.alloc();
        var contents = "this is a test content";
        var contentLen = contents.length;

        var r = LibGit2.git_repository_state_cleanup(_repo);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        var sig:RawPointer<GitSignature> = null;
        var r = LibGit2.git_signature_now(RawPointer.addressOf(sig), "Ian Harrigan", "ianharrigan@hotmail.com");
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }
        
        r = LibGit2.git_blob_create_from_buffer(RawPointer.addressOf(oid_blob), _repo, contents, contentLen);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_signature_free(sig);
            throw error;
        }
        
        var blob:RawPointer<GitBlob> = null;
        r = LibGit2.git_blob_lookup(RawPointer.addressOf(blob), _repo, RawPointer.addressOf(oid_blob));
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_signature_free(sig);
            LibGit2.git_blob_free(blob);
            throw error;
        }
        
        var tree_bld:RawPointer<GitTreeBuilder> = null;
        r = LibGit2.git_treebuilder_new(RawPointer.addressOf(tree_bld), _repo, null);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_signature_free(sig);
            LibGit2.git_blob_free(blob);
            throw error;
        }
        
        r = LibGit2.git_treebuilder_insert(null, tree_bld, "somefile.txt", RawPointer.addressOf(oid_blob), untyped __cpp__("GIT_FILEMODE_BLOB"));
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_signature_free(sig);
            LibGit2.git_blob_free(blob);
            LibGit2.git_treebuilder_free(tree_bld);
            throw error;
        }
        
        var oid_tree = GitOid.alloc();
        r = LibGit2.git_treebuilder_write(RawPointer.addressOf(oid_tree), tree_bld);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_signature_free(sig);
            LibGit2.git_blob_free(blob);
            LibGit2.git_treebuilder_free(tree_bld);
            throw error;
        }
        
        var tree_cmt:RawPointer<GitTree> = null;
        r = LibGit2.git_tree_lookup(RawPointer.addressOf(tree_cmt), _repo, RawPointer.addressOf(oid_tree));
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_signature_free(sig);
            LibGit2.git_blob_free(blob);
            LibGit2.git_treebuilder_free(tree_bld);
            throw error;
        }
        
        var oid_commit = GitOid.alloc();
        r = LibGit2.git_commit_create(RawPointer.addressOf(oid_commit), _repo, "origin/master", sig, sig, null, "some message", tree_cmt, 0, null);
        var error = checkError(r, false);
        if (error != null) {
            LibGit2.git_signature_free(sig);
            LibGit2.git_blob_free(blob);
            LibGit2.git_treebuilder_free(tree_bld);
            LibGit2.git_tree_free(tree_cmt);
            throw error;
        }
        
        LibGit2.git_signature_free(sig);
        LibGit2.git_blob_free(blob);
        LibGit2.git_treebuilder_free(tree_bld);
        LibGit2.git_tree_free(tree_cmt);
        
        trace("all done!");
        */
        
        
    }
}