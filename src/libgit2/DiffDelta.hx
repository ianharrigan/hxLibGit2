package libgit2;

import cpp.RawPointer;
import cpp.Pointer;
import libgit2.externs.LibGit2;

@:unreflective
class DiffDelta extends Common {
    private var pointer:RawPointer<GitDiffDelta> = null;

    public var fileCount(get, null):Int;
    private function get_fileCount():Int {
        var p = Pointer.fromRaw(pointer);
        return p.ptr.nfiles;
    }

    public var fileOld(get, null):DiffFile;
    private function get_fileOld():DiffFile {
        var p = Pointer.fromRaw(pointer);
        var file = new DiffFile();
        file.path = p.ptr.old_file.path;
        file.size = p.ptr.old_file.size;
        return file;
    }

    public var fileNew(get, null):DiffFile;
    private function get_fileNew():DiffFile {
        var p = Pointer.fromRaw(pointer);
        var file = new DiffFile();
        file.path = p.ptr.new_file.path;
        file.size = p.ptr.new_file.size;
        return file;
    }
}