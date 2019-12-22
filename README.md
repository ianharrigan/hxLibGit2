# hxLibGit2

LibGit2 externs (and wrappers) for Haxe


## Usage

Since LibGit2 is pretty low level, there are a set of haxe wrappers that, as well as handling pointers, also allow you to perform some git high level operations that dont exist in the core LibGit2 lib, for example:

```haxe
class Main {
    static function main() {
        // open repo
        var repository = new Repository();
        repository.open("C:\\Work\\Personal\\TestPrivateRepo\\");
        // set user details for repo (only needed for authenticated operations, like push)
        repository.user = new UserDetails("Ian Harrigan", "ianharrigan@hotmail.com", "[password]");
        
        // list first 20 commits
        for (commit in repository.commits("HEAD~20")) {
            trace(". " + commit.oid + " - " + commit.message + " - " + commit.committer.name + ", " + commit.committer.email);
        }
        
        // write some data to a file
        File.saveContent(repository.path + "test_my_file.txt", "" + Date.now());
        
        // add a change and create the commit
        repository.addPath("test_my_file.txt");
        repository.createCommit("test commit " + Date.now());

        // push, upload and clean up
        repository.push();
        repository.stateCleanup();
        repository.reset();
        
        // list first 20 commits again
        for (commit in repository.commits("HEAD~20")) {
            trace(". " + commit.oid + " - " + commit.message + " - " + commit.committer.name + ", " + commit.committer.email);
        }
    }
}
```
