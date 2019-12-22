package libgit2;

typedef UsernamePassword = {
    var username:String;
    var password:String;
}

class Callbacks {

    public var plaintextCredentials:Void->UsernamePassword;
    
    public function new() {
    }
}