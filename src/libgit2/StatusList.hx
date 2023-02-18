package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;

@:unreflective
@:access(libgit2.Repository)
class StatusList extends Common {
    private var pointer:RawPointer<GitStatusList> = null;

    public var repository:Repository;

    public function new(repository:Repository) {
        super();
        this.repository = repository;

        var statusOptions = GitStatusOptions.alloc();
        var r = LibGit2.git_status_options_init(RawPointer.addressOf(statusOptions), LibGit2StatusOptions.STATUS_OPTIONS_VERSION);
        checkError(r);

        var r = LibGit2.git_status_list_new(RawPointer.addressOf(pointer), repository.pointer, RawPointer.addressOf(statusOptions));
        checkError(r);
    }

    public var entryCount(get, null):Int;
    private function get_entryCount():Int {
        return LibGit2.git_status_list_entrycount(pointer);
    }

    public function entry(index:Int):StatusEntry {
        var entryPointer = LibGit2.git_status_byindex(pointer, index);
        if (entryPointer == null) {
            return null;
        }
        var entry = new StatusEntry();
        @:privateAccess entry.pointer = entryPointer;
        return entry;
    }

    public function iterator():StatusListEntryIterator {
        return new StatusListEntryIterator(this);
    }

    public override function free() {
        LibGit2.git_status_list_free(pointer);
    }
}