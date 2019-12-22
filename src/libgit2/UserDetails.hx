package libgit2;

class UserDetails {
    public var name:String;
    public var email:String;
    public var username:String;
    public var password:String;
    
    public function new(name:String, email:String, password:String) {
        this.name = name;
        this.email = email;
        this.username = email;
        this.password = password;
    }
    
    public var signature(get, null):Signature2;
    private function get_signature():Signature2 {
        return new Signature2(name, email);
    }
}