//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl
{
	/**
	 * @author creynder
	 */
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
	import robotlegs.bender.extensions.commandCenter.impl.CommandExecutor;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger;
	import robotlegs.bender.extensions.payloadEvents.api.PayloadEvent;

	public class PayloadEventCommandTrigger extends EventCommandTrigger
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PayloadEventCommandTrigger(injector:Injector, dispatcher:IEventDispatcher, eventType:String, eventClass:Class)
		{
			super(injector, dispatcher, eventType, eventClass);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		override protected function handleEvent(event:Event):void
		{
			if (event is PayloadEvent)
			{
				const eventConstructor:Class = event["constructor"] as Class;
				if (eventClass && eventClass != eventConstructor)
				{
					return;
				}
				const payloadEvent:PayloadEvent = event as PayloadEvent;
				const executor:ICommandExecutor = new CommandExecutor(_injector)
					.withPayloadMapper(function():void {
						var i:uint;
						var valueObjects:Array = payloadEvent.valueObjects;
						if (payloadEvent.valueClasses)
						{
							for (i = 0; i < payloadEvent.valueClasses.length; i++)
							{
								_injector.map(payloadEvent.valueClasses[i]).toValue(valueObjects[i]);
							}
						}
						else
						{
							for (i = 0; i < payloadEvent.valueObjects.length; i++)
							{
								const ctor:Class = valueObjects[i]['constructor'] as Class;
								_injector.map(ctor).toValue(valueObjects[i]);
							}
						}
					})
					.withPayloadUnmapper(function():void {
						var i:uint;
						if (payloadEvent.valueClasses)
						{
							for (i = 0; i < payloadEvent.valueClasses.length; i++)
							{
								_injector.unmap(payloadEvent.valueClasses[i]);
							}
						}
						else
						{
							var valueObjects:Array = payloadEvent.valueObjects;
							for (i = 0; i < valueObjects.length; i++)
							{
								const ctor:Class = valueObjects[i]['constructor'] as Class;
								_injector.unmap(ctor);
							}
						}
					})
					.withCommandClassUnmapper(unmap);
				executor.executeCommands(getMappings().concat());
			}
			else
			{
				super.handleEvent(event);
			}
		}
	}
}
