
module.exports =
class Indent {

    static parse( str ) {
        let nameExp = /([0-9]+)([st])/
        let match = str.match( nameExp )

        console.log(str)

        if( match == null || match.length < 3 )
            return null

        if( isNaN( match[1] ) || match[1] <= 0 )
            return null

        if( !match[2] )
            return null

        return new Indent( match[1], match[2] == "s" )
    }

    constructor( sz, soft ) {
        this.size = sz
        this.soft = soft
    }

    shortAlias() {
        return this.size + ( this.soft ? "s" : "t" )
    }

    alias() {
        return this.size + " " + ( this.soft ? "Spaces" : "Tab" )
    }

    equals( rhs ) {
        return this.size === rhs.size && this.soft === rhs.soft
    }

}