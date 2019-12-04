package libgit2;

import libgit2.externs.LibGit2;

@:unreflective
class Lib {
    private static var _init:Bool = false;
    
    public static var lastError(get, null):Error;
    private static function get_lastError():Error {
        var git_error = LibGit2.giterr_last();
        var error = new Error();
        error.klass = git_error.klass;
        error.message = new String(git_error.message);
        return error;
    }
    
    public static function init() {
        if (_init == true) {
            return;
        }
        
        LibGit2.git_libgit2_init();
        _init = true;
    }
    
    public static function shutdown() {
        if (_init == false) {
            return;
        }
        
        LibGit2.git_libgit2_shutdown();
        _init = false;
    }
}