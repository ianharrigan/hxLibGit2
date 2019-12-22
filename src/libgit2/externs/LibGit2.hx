package libgit2.externs;

import cpp.Char;
import cpp.ConstCharStar;
import cpp.ConstStar;
import cpp.NativeArray;
import cpp.Pointer;
import cpp.RawConstPointer;
import cpp.RawPointer;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:buildXml("<include name='${haxelib:hxLibGit2}/../Build.xml'/>")
@:include("git2.h")
@:unreflective
@:structAccess
extern class LibGit2 {
    @:native("git_libgit2_init")                    public static function git_libgit2_init():Void;
    @:native("git_libgit2_shutdown")                public static function git_libgit2_shutdown():Void;
    @:native("giterr_last")                         public static function giterr_last():ConstStar<GitError>;
    
    @:native("git_repository_open")                 public static function git_repository_open(out:RawPointer<RawPointer<GitRepository>>, path:ConstCharStar):Int;
    @:native("git_repository_free")                 public static function git_repository_free(repo:RawPointer<GitRepository>):Void;
    @:native("git_repository_index")                public static function git_repository_index(out:RawPointer<RawPointer<GitIndex>>, repo:RawPointer<GitRepository>):Int;
    @:native("git_repository_state_cleanup")        public static function git_repository_state_cleanup(repo:RawPointer<GitRepository>):Int;

    @:native("git_index_add_bypath")                public static function git_index_add_bypath(index:RawPointer<GitIndex>, path:ConstCharStar):Int;
    @:native("git_index_get_byindex")               public static function git_index_get_byindex(index:RawPointer<GitIndex>, n:Int):RawConstPointer<GitIndexEntry>;
    @:native("git_index_write_tree")                public static function git_index_write_tree(out:RawPointer<GitOid>, index:RawPointer<GitIndex>):Int;
    @:native("git_index_free")                      public static function git_index_free(index:RawPointer<GitIndex>):Void;

    @:native("git_reference_name_to_id")            public static function git_reference_name_to_id(out:RawPointer<GitOid>, repo:RawPointer<GitRepository>, name:ConstCharStar):Int;
    
    @:native("git_revwalk_new")                     public static function git_revwalk_new(out:RawPointer<RawPointer<GitRevWalk>>, repo:RawPointer<GitRepository>):Int;
    @:native("git_revwalk_sorting")                 public static function git_revwalk_sorting(walk:RawPointer<GitRevWalk>, sort_mode:Int):Void;
    @:native("git_revwalk_push_head")               public static function git_revwalk_push_head(walk:RawPointer<GitRevWalk>):Int;
    @:native("git_revwalk_hide_glob")               public static function git_revwalk_hide_glob(walk:RawPointer<GitRevWalk>, glob:ConstCharStar):Int;
    @:native("git_revparse_single")                 public static function git_revparse_single(out:RawPointer<RawPointer<GitObject>>, repo:RawPointer<GitRepository>, spec:ConstCharStar):Int;
    @:native("git_revwalk_hide")                    public static function git_revwalk_hide(walk:RawPointer<GitRevWalk>, commit_id:RawPointer<GitOid>):Int;
    @:native("git_revwalk_next")                    public static function git_revwalk_next(out:RawPointer<GitOid>, walk:RawPointer<GitRevWalk>):Int;
    
    @:native("git_object_id")                       public static function git_object_id(obj:RawPointer<GitObject>):RawPointer<GitOid>;
    @:native("git_object_free")                     public static function git_object_free(obj:RawPointer<GitObject>):Void;
    
    @:native("git_commit_lookup")                   public static function git_commit_lookup(out:RawPointer<RawPointer<GitCommit>>, repo:RawPointer<GitRepository>, oid:RawPointer<GitOid>):Int;
    @:native("git_commit_message")                  public static function git_commit_message(commit:RawPointer<GitCommit>):ConstCharStar;
    @:native("git_commit_free")                     public static function git_commit_free(commit:RawPointer<GitCommit>):Void;
    @:native("git_commit_author")                   public static function git_commit_author(commit:RawPointer<GitCommit>):ConstStar<GitSignature>;
    @:native("git_commit_committer")                public static function git_commit_committer(commit:RawPointer<GitCommit>):ConstStar<GitSignature>;
    @:native("git_commit_create")                   public static function git_commit_create(id:RawPointer<GitOid>, repo:RawPointer<GitRepository>, update_ref:ConstCharStar, author:RawPointer<GitSignature>, commiter:RawPointer<GitSignature>, message_encoding:ConstCharStar, message:ConstCharStar, tree:RawPointer<GitTree>, parent_count:Int, parents:Dynamic):Int;
    
    @:native("git_blob_create_from_buffer")         public static function git_blob_create_from_buffer(id:RawPointer<GitOid>, repo:RawPointer<GitRepository>, buffer:ConstCharStar, len:Int):Int;
    @:native("git_blob_lookup")                     public static function git_blob_lookup(blob:RawPointer<RawPointer<GitBlob>>, repo:RawPointer<GitRepository>, id:RawPointer<GitOid>):Int;
    @:native("git_blob_free")                       public static function git_blob_free(blob:RawPointer<GitBlob>):Void;

    @:native("git_treebuilder_new")                 public static function git_treebuilder_new(out:RawPointer<RawPointer<GitTreeBuilder>>, repo:RawPointer<GitRepository>, source:RawPointer<GitTree>):Int;
    @:native("git_treebuilder_insert")              public static function git_treebuilder_insert(out:RawPointer<RawPointer<GitTreeEntry>>, bld:RawPointer<GitTreeBuilder>, filename:ConstCharStar, id:RawPointer<GitOid>, filemode:GitFileModeT):Int;
    @:native("git_treebuilder_write")               public static function git_treebuilder_write(id:RawPointer<GitOid>, bld:RawPointer<GitTreeBuilder>):Int;
    @:native("git_treebuilder_free")                public static function git_treebuilder_free(bld:RawPointer<GitTreeBuilder>):Void;
    
    @:native("git_tree_lookup")                     public static function git_tree_lookup(out:RawPointer<RawPointer<GitTree>>, repo:RawPointer<GitRepository>, id:RawPointer<GitOid>):Int;
    @:native("git_tree_free")                       public static function git_tree_free(tree:RawPointer<GitTree>):GitTree;

    @:native("git_signature_now")                   public static function git_signature_now(out:RawPointer<RawPointer<GitSignature>>, name:ConstCharStar, email:ConstCharStar):Int;
    @:native("git_signature_free")                  public static function git_signature_free(sig:RawPointer<GitSignature>):Void;

    @:native("git_remote_lookup")                   public static function git_remote_lookup(out:RawPointer<RawPointer<GitRemote>>, repo:RawPointer<GitRepository>, name:ConstCharStar):Int;
    @:native("git_remote_connect")                  public static function git_remote_connect(remote:RawPointer<GitRemote>, direction:GitDirection, callbacks:RawPointer<GitRemoteCallbacks>, proxy_opts:RawPointer<GitProxyOptions>, custom_headers:RawPointer<GitStrArray>):Int;
    @:native("git_remote_add_push")                 public static function git_remote_add_push(repo:RawPointer<GitRepository>, remote:ConstCharStar, refspec:ConstCharStar):Int;
    @:native("git_remote_push")                     public static function git_remote_push(repo:RawPointer<GitRemote>, refspecs:RawPointer<GitStrArray>, opts:RawPointer<GitPushOptions>):Int;
    @:native("git_remote_upload")                   public static function git_remote_upload(repo:RawPointer<GitRemote>, refspecs:GitStrArray, opts:RawPointer<GitPushOptions>):Int;
    @:native("git_remote_free")                     public static function git_remote_free(remote:RawPointer<GitRemote>):Void;
    @:native("git_remote_disconnect")               public static function git_remote_disconnect(remote:RawPointer<GitRemote>):Void;
    @:native("git_remote_init_callbacks")           public static function git_remote_init_callbacks(callbacks:RawPointer<GitRemoteCallbacks>, version:Int):Int;
    @:native("git_remote_name")                     public static function git_remote_name(remote:RawPointer<GitRemote>):ConstCharStar;
    @:native("git_remote_get_push_refspecs")        public static function git_remote_get_push_refspecs(array:RawPointer<GitStrArray>, remote:RawPointer<GitRemote>):Int;

    @:native("git_push_options_init")               public static function git_push_options_init(options:RawPointer<GitPushOptions>, version:Int):Int;

    @:native("git_reset_default")                   public static function git_reset_default(array:RawPointer<GitRepository>, target:RawPointer<GitObject>, pathspecs:RawPointer<GitStrArray>):Int;
    
    @:native("git_oid_tostr")                       public static function git_oid_tostr(out:CharStar, n:Int, oid:RawPointer<GitOid>):Void;
    @:native("git_strarray_free")                   public static function git_strarray_free(out:CharStar, n:Int, oid:RawPointer<GitOid>):Void;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class LibGit2Flags {
    public static var GIT_SORT_NONE:Int                         = untyped __cpp__("GIT_SORT_NONE");
    public static var GIT_SORT_TOPOLOGICAL:Int                  = untyped __cpp__("GIT_SORT_TOPOLOGICAL");
    public static var GIT_SORT_TIME:Int                         = untyped __cpp__("GIT_SORT_TIME");
    public static var GIT_SORT_REVERSE:Int                      = untyped __cpp__("GIT_SORT_REVERSE");
}

class LibGit2FileMode {
    public static var GIT_FILEMODE_UNREADABLE:GitFileModeT      = untyped __cpp__("GIT_FILEMODE_UNREADABLE");
    public static var GIT_FILEMODE_TREE:GitFileModeT            = untyped __cpp__("GIT_FILEMODE_TREE");
    public static var GIT_FILEMODE_BLOB:GitFileModeT            = untyped __cpp__("GIT_FILEMODE_BLOB");
    public static var GIT_FILEMODE_BLOB_EXECUTABLE:GitFileModeT = untyped __cpp__("GIT_FILEMODE_BLOB_EXECUTABLE");
    public static var GIT_FILEMODE_LINK:GitFileModeT            = untyped __cpp__("GIT_FILEMODE_LINK");
    public static var GIT_FILEMODE_COMMIT:GitFileModeT          = untyped __cpp__("GIT_FILEMODE_COMMIT");
}

class LibGit2Direction {
    public static var GIT_DIRECTION_FETCH:GitDirection          = untyped __cpp__("GIT_DIRECTION_FETCH");
    public static var GIT_DIRECTION_PUSH:GitDirection           = untyped __cpp__("GIT_DIRECTION_PUSH");
}

@:headerInclude("git2.h")
class LibGit2RemoteCallbacks {
    public static var REMOTE_CALLBACKS_VERSION              = untyped __cpp__("GIT_REMOTE_CALLBACKS_VERSION");
}

@:headerInclude("git2.h")
class LibGit2PushOptions {
    public static var PUSH_OPTIONS_VERSION              = untyped __cpp__("GIT_PUSH_OPTIONS_VERSION");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_repository")
extern class GitRepository {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_index")
extern class GitIndex {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_index_entry")
extern class GitIndexEntry {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_object")
extern class GitObject {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_commit")
extern class GitCommit {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_remote")
extern class GitRemote {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_oid")
extern class GitOid {
    public static inline function alloc():GitOid {
        return untyped __cpp__("{}");
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_revwalk")
extern class GitRevWalk {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_blob")
extern class GitBlob {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_error")
extern class GitError {
    var klass:Int;
    var message:ConstCharStar;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_signature")
extern class GitSignature {
    var name:CharStar;
    var email:CharStar;
    var when:GitTime;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_tree")
extern class GitTree {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_tree_entry")
extern class GitTreeEntry {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_treebuilder")
extern class GitTreeBuilder {
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_time")
extern class GitTime {
    var time:GitTimeT;
    var offset:Int;
    var sign:Char;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_push_options")
extern class GitPushOptions {
    public static inline function alloc():GitPushOptions {
        return untyped __cpp__("{}");
    }
    
    public var callbacks:GitRemoteCallbacks;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_time_t")
extern abstract GitTimeT(Int) from(Int) to(Int) {
	@:to public inline function toInt():Int {
		return this;
    }
}

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_filemode_t")
extern class GitFileModeT {
}

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_direction")
extern class GitDirection {
}

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_remote_callbacks")
extern class GitRemoteCallbacks {
    public static inline function alloc():GitRemoteCallbacks {
        return untyped __cpp__("{}");
    }
    public var credentials:Dynamic;
}

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_proxy_options")
extern class GitProxyOptions {
}

@:include("git2.h")
@:unreflective
@:structAccess
@:native("git_strarray")
extern class GitStrArray {
    public static inline function alloc():GitStrArray {
        return untyped __cpp__("{}");
    }
    var count:Int;
    var strings:RawPointer<RawPointer<Char>>;
}

@:unreflective
class GitStrArrayBuilder {
    public var native:GitStrArray;
    
    public function new() {
        native = GitStrArray.alloc();
    }
    
    public function build(items:Array<String>) {
        native.count = items.length;
        native.strings = untyped __cpp__('new char*[{0}]', items.length);
        var n = 0;
        for (i in items) {
            native.strings[n] = untyped __cpp__('const_cast<char*>({1}.c_str())', n, i);
            n++;
        }
    }
    
    public function free() {
        untyped __cpp__('delete {0}.strings', native);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extern abstract CharStar(RawPointer<Char>) to(RawPointer<Char>) {
	inline function new(s:String) {
		this = untyped s.__s;
    }

    public static inline function alloc(size:Int):CharStar {
        return untyped __cpp__("new char[{0}]", size);
    }
    
    public static inline function free(c:CharStar):Void {
        untyped __cpp__("delete[] {0}", c);
    }
        
	@:from
	static public inline function fromString(s:String):CharStar
		return new CharStar(s);

	@:to public inline function toString():String
		return new String(untyped this);

	@:to public inline function toPointer():RawPointer<Char>
		return this;
}
