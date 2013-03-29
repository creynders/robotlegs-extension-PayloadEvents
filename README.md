#Payload Events extension for Robotlegs v2

It's a signal! It's an Event! No, it's a scary mutant event-signal hybrid!

***
__NOT READY - depends on experimental Robotlegs 2 version__
***

```ActionScript
//FooEvent.as
static public const FOO : String = 'foo';

public function FooEvent( type : String, ...valueObjects ){
	super( type, valueObjects );
	withValueClasses( String, int );
}

public function clone():Event{
	return new FooEvent( type, valueObjects );
}
```

```ActionScript
//ConfigureFoo.as
[Inject]
public var payloadCommandMap : IPayloadEventCommandMap;

public function configure() : void{
	payloadCommandMap.map( FooEvent.FOO, FooEvent )
		.toCommand( FooCommand );
}
```

```ActionScript
//FooCommand.as
[Inject]
public var name :  String;

[Inject]
public var nr : int;

public function execute() : void{
	trace( name, nr ); //traces "foo, 5"
}
```

```ActionScript
dispatcher.dispatchEvent( new FooEvent( FooEvent.FOO, 'foo', 5 ) );
```
