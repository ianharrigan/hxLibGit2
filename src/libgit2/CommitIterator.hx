package libgit2;

class CommitIterator {
    private var _repoistory:Repository;
    private var _it:RevWalkIterator;
    
    public function new(repoistory:Repository, it:RevWalkIterator) {
        _repoistory = repoistory;
        _it = it;
    }
    
    public function hasNext() {
        return _it.hasNext();
    }

    private var _currentCommit:Commit = null;
    public function next():Commit {
        if (_currentCommit == null) {
            _currentCommit = new Commit(_repoistory);
        }
        var oid = _it.next();
        _currentCommit.lookup(oid);
        return _currentCommit;
    }
}