package libgit2;

@:unreflective
class Common {
    public function new() {
        Lib.init();
    }
    
    public function free() {
        
    }
    
    private function checkError(e) {
        if (e < 0) {
            var error = Lib.lastError;
            error.code = e;
            throw error;
        }
    }
}
