package libgit2.externs;

import cpp.Char;
import cpp.ConstCharStar;
import cpp.ConstStar;
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
    
    @:native("git_oid_tostr")                       public static function git_oid_tostr(out:CharStar, n:Int, oid:RawPointer<GitOid>):Void;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class LibGit2Flags {
    public static var GIT_SORT_NONE:Int             = untyped __cpp__("GIT_SORT_NONE");
    public static var GIT_SORT_TOPOLOGICAL:Int      = untyped __cpp__("GIT_SORT_TOPOLOGICAL");
    public static var GIT_SORT_TIME:Int             = untyped __cpp__("GIT_SORT_TIME");
    public static var GIT_SORT_REVERSE:Int          = untyped __cpp__("GIT_SORT_REVERSE");
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
@:native("git_time_t")
extern abstract GitTimeT(Int) from(Int) to(Int) {
	@:to public inline function toInt():Int {
		return this;
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
