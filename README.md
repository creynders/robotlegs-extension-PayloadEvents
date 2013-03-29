#Payload Events extension for Robotlegs v2

***
__NOT READY__ - depends on experimental Robotlegs 2 version
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
