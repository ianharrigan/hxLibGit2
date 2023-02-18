package libgit2;

import cpp.ConstPointer;
import cpp.RawConstPointer;
import libgit2.externs.LibGit2;

@:unreflective
class StatusEntry extends Common {
    public static var Current                   = LibGit2Status.STATUS_CURRENT;
    public static var IndexNew                  = LibGit2Status.STATUS_INDEX_NEW;
    public static var IndexModified             = LibGit2Status.STATUS_INDEX_MODIFIED;
    public static var IndexDeleted              = LibGit2Status.STATUS_INDEX_DELETED;
    public static var IndexRenamed              = LibGit2Status.STATUS_INDEX_RENAMED;
    public static var IndexTypeChange           = LibGit2Status.STATUS_INDEX_TYPECHANGE;
    public static var WorkingTreeNew            = LibGit2Status.STATUS_WT_NEW;
    public static var WorkingTreeModified       = LibGit2Status.STATUS_WT_MODIFIED;
    public static var WorkingTreeDeleted        = LibGit2Status.STATUS_WT_DELETED;
    public static var WorkingTreeTypeChange     = LibGit2Status.STATUS_WT_TYPECHANGE;
    public static var WorkingTreeRenamed        = LibGit2Status.STATUS_WT_RENAMED;
    public static var WorkingTreeUnreadable     = LibGit2Status.STATUS_WT_UNREADABLE;
    public static var Ignored                   = LibGit2Status.STATUS_IGNORED;
    public static var Conflicted                = LibGit2Status.STATUS_CONFLICTED;

    public static inline var DiffGuess:Int = 0;
    public static inline var DiffHeadToIndex:Int = 1;
    public static inline var DiffIndexToWorkDir:Int = 2;

    private var pointer:RawConstPointer<GitStatusEntry> = null;

    private var _status:Null<Int> = null;
    public var status(get, null):Int;
    private function get_status():Int {
        if (_status != null) {
            return _status;
        }
        var p = ConstPointer.fromRaw(pointer);
        _status = p.ptr.status;
        return _status;
    }

    public var isCurrent(get, null):Bool;
    private function get_isCurrent():Bool {
        return (status & Current == Current);
    }

    public var isNew(get, null):Bool;
    private function get_isNew():Bool {
        return (status & IndexNew == IndexNew) || (status & WorkingTreeNew == WorkingTreeNew);
    }

    public var isModified(get, null):Bool;
    private function get_isModified():Bool {
        return (status & IndexModified == IndexModified) || (status & WorkingTreeModified == WorkingTreeModified);
    }

    public var isDeleted(get, null):Bool;
    private function get_isDeleted():Bool {
        return (status & IndexDeleted == IndexDeleted) || (status & WorkingTreeDeleted == WorkingTreeDeleted);
    }

    public var isRenamed(get, null):Bool;
    private function get_isRenamed():Bool {
        return (status & IndexRenamed == IndexRenamed) || (status & WorkingTreeRenamed == WorkingTreeRenamed);
    }

    public var isTypeChange(get, null):Bool;
    private function get_isTypeChange():Bool {
        return (status & IndexTypeChange == IndexTypeChange) || (status & WorkingTreeTypeChange == WorkingTreeTypeChange);
    }

    public var isUnreadable(get, null):Bool;
    private function get_isUnreadable():Bool {
        return (status & WorkingTreeUnreadable == WorkingTreeUnreadable);
    }

    public var isIgnored(get, null):Bool;
    private function get_isIgnored():Bool {
        return (status & Ignored == Ignored);
    }

    public var isConflicted(get, null):Bool;
    private function get_isConflicted():Bool {
        return (status & Conflicted == Conflicted);
    }

    public function diff(type:Int = DiffGuess):DiffDelta {
        var diff = new DiffDelta();
        var p = ConstPointer.fromRaw(pointer);
        switch (type) {
            case DiffGuess:
                if (p.ptr.head_to_index != null) {
                    @:privateAccess diff.pointer = p.ptr.head_to_index;
                } else if (p.ptr.index_to_workdir != null) {
                    @:privateAccess diff.pointer = p.ptr.index_to_workdir;
                } else {
                    return null;
                }
            case DiffHeadToIndex:
                if (p.ptr.head_to_index != null) {
                    @:privateAccess diff.pointer = p.ptr.head_to_index;
                } else {
                    return null;
                }
            case DiffIndexToWorkDir:    
                if (p.ptr.index_to_workdir != null) {
                    @:privateAccess diff.pointer = p.ptr.index_to_workdir;
                } else {
                    return null;
                }
            case _:
                return null;
        }
        return diff;
    }
}