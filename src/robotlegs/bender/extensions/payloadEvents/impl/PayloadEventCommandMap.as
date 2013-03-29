//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import org.swiftsuspenders.Injector;

	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandTriggerMap;
	import robotlegs.bender.extensions.payloadEvents.api.IPayloadEventCommandMap;
	import robotlegs.bender.framework.api.IContext;

	public class PayloadEventCommandMap implements IPayloadEventCommandMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _triggerMap:CommandTriggerMap;

		private var _dispatcher:IEventDispatcher;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PayloadEventCommandMap(context:IContext, dispatcher:IEventDispatcher)
		{
			_injector = context.injector;
			_dispatcher = dispatcher;
			_triggerMap = new CommandTriggerMap()
				.withKeyFactory(getKey)
				.withTriggerFactory(createTrigger)
				.withLogger(context.getLogger(this));
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(eventType:String, eventClass:Class = null):ICommandMapper
		{
			return createMapper( eventType, eventClass );
		}

		public function unmap(eventType:String, eventClass:Class = null):ICommandUnmapper
		{
			return createMapper( eventType, eventClass );
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapper( eventType : String, eventClass : Class = null ) : CommandMapper{
			var trigger : ICommandTrigger = _triggerMap.getOrCreateNewTrigger( eventType, eventClass );
			return new CommandMapper(trigger);
		}

		private function createTrigger(eventType:String, eventClass:Class = null):ICommandTrigger
		{
			return new PayloadEventCommandTrigger(_injector, _dispatcher, eventType, eventClass);
		}

		private function getKey(eventType:String, eventClass:Class = null):String
		{
			eventClass = Event;
			return eventType + eventClass;
		}
	}
}
