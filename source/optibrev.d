// Written in the D programming language.

/**
Optibrev is a minimalistic and powerful D library for managing optional values. 
 
It gives you a flexible way to handle `null` or missing values without writing excessive code. It supports the fundamental monadic operations such as `map`, enabling you to transform your data in a functional manner. 
Alongside, it provides methods like `unwrap`, `isNone`, `isSome`, and `orElse` for easy extraction and error handling. The main data structure in Optibrev is `Option`, which encapsulates an optional value. 

Copyright: LightHouse Software, 2024
Authors:   Oleg Bakharev,
		   Emily Tiernan
*/
module optibrev;

// Option type
struct Option(T) 
{
	private 
	{	
		// type of stored value
		enum OptionType : byte 
	    {
	        NONE,
	        SOME
	    }
	    	
		OptionType type;
		T value;
		
		this(OptionType type, T value = T.init)
		{
			this.type  = type;
			this.value = value;
		}
	}
	
	// is None ?
	bool isNone() {
		return type == OptionType.NONE;
	}
	
	// is Some ?
	bool isSome() {
		return type == OptionType.SOME;
	}
	
	// return Option if Some or return defaultValue otherwise
	T orElse(T defaultValue)
	{
		return (type == OptionType.NONE) ? defaultValue : value;
	}
	
	// None type
	Option!T None()
	{
		return Option!T(OptionType.NONE);
	}
	
	// Some value
	Option!T Some(T value)
	{
		return Option!T(OptionType.SOME, value);
	}
	
	// string representation
    string toString() const 
	{
		import std.conv : to;
		import std.format : format;
		
		return (type == OptionType.NONE) ? "None" : format("Some(%s)", to!string(value));
	}
    
    // unwrap value
    T unwrap() const 
    {
        if (type == OptionType.SOME)
        {
            return value;
        }
        
        throw new Exception("Can't unwrap None"); 
    }
    
    Option!U map(U)(U delegate(T) func) 
	{ 
		Option!U tmp;
		
	    if (type == OptionType.NONE) 
	    {
	        tmp = tmp.None(); 
	    } 
	    else 
	    {
	        tmp = tmp.Some(func(value)); 
	    } 
	    return tmp; 
	}    
}
