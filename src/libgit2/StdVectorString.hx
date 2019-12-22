package libgit2;

import cpp.Char;
import cpp.ConstCharStar;
import cpp.RawPointer;

@:keep
@:unreflective
@:structAccess
@:include('vector')
@:native('std::vector<char*>')
extern class StdVectorString
{
    @:native('std::vector<char*>')
    static function create() : StdVectorString;

    function push_back(_string : RawPointer<Char>) : Void;

    function data() : RawPointer<RawPointer<Char>>;

    function size() : Int;
}