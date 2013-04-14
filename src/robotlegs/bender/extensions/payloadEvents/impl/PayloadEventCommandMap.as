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
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.extensions.payloadEvents.impl.extraction.PayloadReflector;

	public class PayloadEventCommandMap implements IPayloadEventCommandMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _triggerMap:CommandTriggerMap;

		private var _dispatcher:IEventDispatcher;

		private var _payloadExtractor : PayloadReflector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		private var _logger:ILogger;

		public function PayloadEventCommandMap(context:IContext, dispatcher:IEventDispatcher)
		{
			_injector = context.injector;
			_dispatcher = dispatcher;
			_logger = context.getLogger(this);
			_triggerMap = new CommandTriggerMap(getKey,createTrigger);
			_payloadExtractor = new PayloadReflector();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(eventType:String, eventClass:Class = null):ICommandMapper
		{
			return getTrigger(eventType, eventClass).createMapper();
		}

		public function unmap(eventType:String, eventClass:Class = null):ICommandUnmapper
		{
			return getTrigger(eventType, eventClass).createMapper();
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function getKey(eventType:String, eventClass:Class = null):String
		{
			eventClass = Event;
			return eventType + eventClass;
		}

		private function getTrigger(type:String, eventClass:Class):PayloadEventCommandTrigger
		{
			return _triggerMap.getTrigger(type, eventClass) as PayloadEventCommandTrigger;
		}

		private function createTrigger(eventType:String, eventClass:Class = null):ICommandTrigger
		{
			return new PayloadEventCommandTrigger(_injector, _dispatcher, eventType, eventClass, _payloadExtractor, _logger);
		}

	}
}
