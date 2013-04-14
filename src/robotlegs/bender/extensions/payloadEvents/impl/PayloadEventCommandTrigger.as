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
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.impl.CommandExecutor;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
	import robotlegs.bender.extensions.commandCenter.impl.CommandPayload;
	import robotlegs.bender.extensions.payloadEvents.api.IPayloadExtractionPoint;
	import robotlegs.bender.extensions.payloadEvents.impl.extraction.PayloadExtractionDescription;
	import robotlegs.bender.extensions.payloadEvents.impl.extraction.PayloadReflector;
	import robotlegs.bender.framework.api.ILogger;

	public class PayloadEventCommandTrigger implements ICommandTrigger
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _dispatcher:IEventDispatcher;

		private var _type:String;

		private var _eventClass:Class;

		private var _injector:Injector;

		private var _mappings:ICommandMappingList;

		private var _executor:ICommandExecutor;

		private var _extractionDescription:PayloadExtractionDescription;

		private var _payloadReflector:PayloadReflector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PayloadEventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			eventType:String,
			eventClass:Class,
			payloadExtractor:PayloadReflector,
			logger:ILogger = null)
		{
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
			_type = eventType;
			_eventClass = eventClass;
			_payloadReflector = payloadExtractor;
			_mappings = new CommandMappingList(this, logger);
			_executor = new CommandExecutor(_injector, _mappings.removeMapping);
			eventClass && (_extractionDescription = _payloadReflector.describeExtractionsForClass(_eventClass));
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function createMapper():PayloadEventCommandMapper
		{
			return new PayloadEventCommandMapper(_mappings);
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

		public function eventHandler(event:Event):void
		{
			const eventConstructor:Class = event["constructor"] as Class;
			if (_eventClass && eventConstructor != _eventClass)
			{
				return;
			}
			var payload:CommandPayload;

			_extractionDescription ||= _payloadReflector.describeExtractionsForInstance(event);

			if (_extractionDescription.numPoints > 0)
			{
				payload = new CommandPayload();
				var i:int;
				var n:int = _extractionDescription.numPoints
				for (i = 0; i < n; i++)
				{
					var extractionPoint:IPayloadExtractionPoint = _extractionDescription.extractionPoints[i];
					payload.addPayload(extractionPoint.extractFrom(event), extractionPoint.valueType);
				}

			}
			else
			{
				payload = new CommandPayload([event], [Event]);
				if (eventConstructor != Event)
					payload.addPayload(event, _eventClass || eventConstructor);
			}
			_executor.executeCommands(_mappings.getList(), payload);
		}
	}
}
