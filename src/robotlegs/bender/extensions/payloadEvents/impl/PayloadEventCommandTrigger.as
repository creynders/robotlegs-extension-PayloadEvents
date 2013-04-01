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
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.impl.CommandExecutor;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger;
	import robotlegs.bender.extensions.payloadEvents.api.PayloadEvent;
	import robotlegs.bender.framework.api.ILogger;

	public class PayloadEventCommandTrigger implements ICommandTrigger
	{

		private var _injector : Injector;

		private var _base : EventCommandTrigger;

		private var _dispatcher : IEventDispatcher;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PayloadEventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			eventType:String,
			eventClass:Class,
			decorator : ICommandTrigger = null)
		{
			_base = new EventCommandTrigger(injector, dispatcher, eventType, eventClass, decorator || this);
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
		}

		public function activate():void
		{
			_dispatcher.addEventListener( _base.eventType, handleEvent );
			//do NOT call _base.activate, all is handled here
		}

		public function createMapping(commandClass:Class):ICommandMapping
		{
			return _base.createMapping(commandClass);
		}

		public function deactivate():void
		{
			_dispatcher.removeEventListener( _base.eventType, handleEvent );
			//do NOT call _base.deactivate, all is handled here
		}

		public function getList():ICommandMappingList
		{
			return _base.getList();
		}

		public function getMappings():Vector.<ICommandMapping>
		{
			return _base.getMappings();
		}

		public function map(commandClass:Class):ICommandMapping
		{
			return _base.map(commandClass);
		}

		public function unmap(commandClass:Class):void
		{
			_base.unmap(commandClass);
		}

		public function unmapAll():void
		{
			_base.unmapAll();
		}

		public function withLogger(logger:ILogger):void
		{
			_base.withLogger(logger);
		}


		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		public function handleEvent(event:Event):void
		{
			if (event is PayloadEvent)
			{
				const eventConstructor:Class = event["constructor"] as Class;
				if (_base.eventClass && _base.eventClass != eventConstructor)
				{
					return;
				}
				const payloadEvent:PayloadEvent = event as PayloadEvent;
				const executor:ICommandExecutor = _base.createExecutor( _injector );
				executor.withCommandClassUnmapper( unmap )
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
					});
				executor.executeCommands(getMappings().concat());
			}
			else
			{
				_base.handleEvent(event);
			}
		}
	}
}
