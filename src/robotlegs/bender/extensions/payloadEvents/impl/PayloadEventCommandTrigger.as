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
	import robotlegs.bender.extensions.commandCenter.impl.CommandMapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
	import robotlegs.bender.extensions.commandCenter.impl.CommandPayload;
	import robotlegs.bender.extensions.payloadEvents.api.PayloadEvent;
	import robotlegs.bender.framework.api.ILogger;

	public class PayloadEventCommandTrigger implements ICommandTrigger
	{

		private var _dispatcher : IEventDispatcher;

		private var _type:String;

		private var _eventClass:Class;

		private var _injector:Injector;

		private var _mappings:ICommandMappingList;

		private var _executor: ICommandExecutor;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PayloadEventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			eventType:String,
			eventClass:Class,
			logger : ILogger= null)
		{
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
			_type = eventType;
			_eventClass = eventClass;
			_mappings = new CommandMappingList(this, logger);
			_executor = new CommandExecutor(_injector,_mappings.removeMapping);
		}

		public function createMapper():CommandMapper
		{
			return new CommandMapper(_mappings);
		}

		public function activate():void
		{
			_dispatcher.addEventListener(_type, eventHandler);
		}

		public function deactivate():void
		{
			_dispatcher.removeEventListener(_type, eventHandler);
		}

		public function toString():String
		{
			return _eventClass + " with selector '" + _type + "'";
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		public function eventHandler(event:Event):void
		{
			const eventConstructor:Class = event["constructor"] as Class;
			if (_eventClass && eventConstructor != _eventClass)
			{
				return;
			}
			var payload : CommandPayload;
			const payloadEvent : PayloadEvent = event as PayloadEvent;
			if( payloadEvent && payloadEvent.valueObjects && payloadEvent.valueObjects.length > 0){
				var valueClasses : Array = payloadEvent.valueClasses;
				if( ! valueClasses || valueClasses.length == 0 ){
					for (var i:int = 0; i <payloadEvent.valueObjects.length; i++)
					{
						const ctor:Class = payloadEvent.valueObjects[i]['constructor'] as Class;
						_injector.map(ctor).toValue(payloadEvent.valueObjects[i]);
					}
				}
				payload = new CommandPayload( payloadEvent.valueObjects, valueClasses );
			}else{
				payload = new CommandPayload([event], [Event]);
				if (eventConstructor != Event)
					payload.addPayload(event, _eventClass || eventConstructor);
			}
			_executor.executeCommands(_mappings.getList(), payload);
		}
	}
}
