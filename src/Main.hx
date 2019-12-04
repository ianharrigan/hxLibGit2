package;
import cpp.RawPointer;
import libgit2.Repository;
import libgit2.RevWalk.SortFlags;
import libgit2.externs.LibGit2;

class Main {
	static function main() {
        var r = new Repository();
        r.open("C:\\Work\\Personal\\TestPrivateRepo");
        var w = r.createWalker(SortFlags.Topological | SortFlags.Time);
        w.start("HEAD~10");
        while (w.next()) {
            var c = w.commit;
            trace("---------------------------------------------------------------------");
            trace("oid: " + c.oid);
            trace("message: " + c.message);
            trace("author: " + c.author);
            trace("committer: " + c.committer);
            trace("---------------------------------------------------------------------");
            trace("");
        }
        return;
        
        
        LibGit2.git_libgit2_init();
        
        var repo:RawPointer<GitRepository> = null;
        var error = LibGit2.git_repository_open(RawPointer.addressOf(repo), "C:\\Work\\Personal\\TestPrivateRepo");
        if (error < 0) {
            var git_error = LibGit2.giterr_last();
            trace(git_error.klass);
            trace(git_error.message);
        }
        
        var walker:RawPointer<GitRevWalk> = null;
        error = LibGit2.git_revwalk_new(RawPointer.addressOf(walker), repo);
        if (error < 0) {
            var git_error = LibGit2.giterr_last();
            trace(git_error.klass);
            trace(git_error.message);
        }

        LibGit2.git_revwalk_sorting(walker, LibGit2Flags.GIT_SORT_TOPOLOGICAL | LibGit2Flags.GIT_SORT_TIME);
        LibGit2.git_revwalk_push_head(walker);
        LibGit2.git_revwalk_hide_glob(walker, "tags/*");
        var obj:RawPointer<GitObject> = null;
        LibGit2.git_revparse_single(RawPointer.addressOf(obj), repo, "HEAD~10");
        LibGit2.git_revwalk_hide(walker, LibGit2.git_object_id(obj));
        LibGit2.git_object_free(obj);
        
        var oid:GitOid = GitOid.alloc();
        while (LibGit2.git_revwalk_next(RawPointer.addressOf(oid), walker) == 0) {
            trace("---------------------------------------------------------------------");
            var commit:RawPointer<GitCommit> = null;
            var oidstr = CharStar.alloc(10);
            
            LibGit2.git_commit_lookup(RawPointer.addressOf(commit), repo, RawPointer.addressOf(oid));
            LibGit2.git_oid_tostr(oidstr, 9, RawPointer.addressOf(oid));
            
            var author = LibGit2.git_commit_author(commit);
            var committer = LibGit2.git_commit_committer(commit);
            
            var message:String = LibGit2.git_commit_message(commit);
            trace("oid: " + oidstr);
            trace("message: " + StringTools.trim(message));
            trace("author.name: " + author.name);
            trace("author.email: " + author.email);
            var d = Date.fromTime(untyped __cpp__("(int){0}", author.when.time));
            trace("author.when: " + untyped __cpp__("(int){0}", author.when.time));
            trace("author.when: " + d);
            trace("committer.name: " + committer.name);
            trace("committer.email: " + committer.email);
            
            CharStar.free(oidstr);
            
            LibGit2.git_commit_free(commit);
            trace("---------------------------------------------------------------------");
            trace("");
            trace("");
        }
        
        LibGit2.git_repository_free(repo);
        
        LibGit2.git_libgit2_shutdown();
	}
}