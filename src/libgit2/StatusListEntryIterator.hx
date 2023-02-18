package libgit2;

@:unreflective
class StatusListEntryIterator extends Common {
    private var _list:StatusList;
    private var _current:Int = 0;
    private var _max:Int = 0;

    public function new(list:StatusList) {
        super();
        _list = list;
        _current = 0;
        _max = _list.entryCount;
    }

    public function hasNext() {
        return _current < _max;
    }

    public function next():StatusEntry {
        var entry = _list.entry(_current);
        _current++;
        return entry;
    }
}