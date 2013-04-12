[1]: https://github.com/robertpenner/as3-signals

#Payload Events extension for Robotlegs v2

It's a signal! It's an Event! No, it's a scary mutant event-signal hybrid!

***

__NOT READY - depends on experimental Robotlegs 2 version__

***

## Why?

*What does the PayloadsExtension do you couldn't do before?*

**It allows you to keep your commands ignorant of the messaging system in use.**

That's really it. But it's more than you'd think.

If you're like me **you started out using events** with RL. **Until you discovered [Signals][1]**. They're awesome.

So you started using signals throughout your entire system, but **then you got fed up with all those singleton signals** spread everywhere.

Now I only use signals for direct communication between parts, e.g. from view to mediator, parser to service etc.
All system-wide communication is done with Events.

However, there's one thing I really, really hate about Events in system-wide messaging:
your commands get tightly coupled to them. To access the payload they're carrying you need to inject the event into the commands.

This means that if you have one command which should be triggered by two different event classes, but carrying the same payload type, you're in trouble.
Also, if an async sequence changes it could be the event that triggers the command is changed, so you need to go and modify your command too.

In fact when you map a command to an event you wire it to the event twice: once in your config class setting up the mapping and once in your command where the event gets injected. This shouldn't be.

Hence the PayloadEvents extension. It alleviates you from having to couple your command to an event just to access its payload.

**PayloadEvents make your system cleaner and more versatile.** 

You can trigger the same commands from events and signals, this is especially useful when reusing services/parsers/etc. from other projects that maybe used a different messaging system than your current. With PayloadEvents you can mix and match as you see fit/as it is required.


## Example

```ActionScript
//FooVO.as

/**
 * This is our payload class
 */

private var _value : String;
public function get value() : String{
	return _value;
}

public function FooVO( value : String ){
	_value = value;
}

public function toString() : String{
	return _value;
}

```

```ActionScript
//FooEvent.as

/**
 * This is our payload carrying Event class
 */

public class FooEvent extends PayloadEvent{ //you have to Extend PayloadEvent
	static public const FOO : String = 'foo';

	public function FooEvent( type : String, ...valueObjects ){
		super( type, valueObjects );
		withValueClasses( FooVO );
	}

	public function clone():Event{
		return new FooEvent( type, valueObjects );
	}
}
```

```ActionScript
//ConfigureFoo.as

/**
 * Maps the payload event to the command which will be injected with the payload
 */

[Inject]
public var payloadCommandMap : IPayloadEventCommandMap;

public function configure() : void{
	payloadCommandMap.map( FooEvent.FOO, FooEvent ).toCommand( FooCommand );
}
```

```ActionScript
//FooCommand.as

/**
 * Command that receives the payload and uses it 
 */
[Inject]
public var foo : FooVO;

public function execute() : void{
	trace( foo ); //traces "Hello World"
}
```

```ActionScript
dispatcher.dispatchEvent( new FooEvent( FooEvent.FOO, 'Hello World' ) );
```
