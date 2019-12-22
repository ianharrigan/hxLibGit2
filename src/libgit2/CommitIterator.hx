package libgit2;

class CommitIterator {
    private var _repoistory:Repository2;
    private var _it:RevWalkIterator;
    
    public function new(repoistory:Repository2, it:RevWalkIterator) {
        _repoistory = repoistory;
        _it = it;
    }
    
    public function hasNext() {
        return _it.hasNext();
    }

    private var _currentCommit:Commit2 = null;
    public function next():Commit2 {
        if (_currentCommit == null) {
            _currentCommit = new Commit2(_repoistory);
        }
        var oid = _it.next();
        _currentCommit.lookup(oid);
        return _currentCommit;
    }
}