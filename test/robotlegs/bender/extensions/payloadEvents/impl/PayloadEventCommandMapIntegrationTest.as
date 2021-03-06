//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.Injector;

	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandTriggerMap;
	import robotlegs.bender.extensions.payloadEvents.api.IPayloadEventCommandMap;
	import robotlegs.bender.extensions.payloadEvents.support.ClassReportingCommand;
	import robotlegs.bender.extensions.payloadEvents.support.EventReportingCommand;
	import robotlegs.bender.extensions.payloadEvents.support.LoosePayloadEvent;
	import robotlegs.bender.extensions.payloadEvents.support.NullCommand;
	import robotlegs.bender.extensions.payloadEvents.support.NullPayload;
	import robotlegs.bender.extensions.payloadEvents.support.StrictPayloadEvent;
	import robotlegs.bender.extensions.payloadEvents.support.SupportEvent;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;

	public class PayloadEventCommandMapIntegrationTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:IPayloadEventCommandMap;

		private var injector:Injector;

		private var dispatcher:IEventDispatcher;

		private var reported:Array;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setup():void
		{
			reported = [];
			const context:IContext = new Context();
			injector = context.injector;
			injector.map(Function, "reportingFunction").toValue(reportingFunction);
			dispatcher = new EventDispatcher();
			subject = new PayloadEventCommandMap(context, dispatcher);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function test_map_returns_mapper() : void{
			assertThat(subject.map(SupportEvent.TYPE),instanceOf(ICommandMapper));
		}

		[Test]
		public function test_unmap_returns_unmapper() : void{
			assertThat(subject.unmap(SupportEvent.TYPE),instanceOf(ICommandUnmapper));
		}

		[Test]
		public function test_map_returns_new_mapper_for_same_event() : void{
			var oldMapper : ICommandMapper = subject.map(SupportEvent.TYPE);
			assertThat(subject.map(SupportEvent.TYPE), not(equalTo(oldMapper)));
		}

		[Test]
		public function test_commands_are_executed() : void{
			subject.map(SupportEvent.TYPE).toCommand(ClassReportingCommand);

			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE));

			assertThat(reported,array(ClassReportingCommand));
		}

		[Test]
		public function test_strict_payload_is_injected_into_commands():void
		{
			const foo:String = 'payload';
			const bar:NullPayload = new NullPayload();
			subject.map(StrictPayloadEvent.TYPE).toCommand(CommandWithInjectionPoints);

			dispatcher.dispatchEvent(new StrictPayloadEvent(StrictPayloadEvent.TYPE, foo, bar));

			assertThat(reported, array(foo, bar));
		}

		[Test]
		public function test_loose_payload_values_are_mapped_to_concrete_classes():void
		{
			const concretePayload:NullPayload = new NullPayload();
			subject.map(LoosePayloadEvent.TYPE).toCommand(CommandWithConcreteInjectionPoints);

			dispatcher.dispatchEvent(new LoosePayloadEvent(LoosePayloadEvent.TYPE,concretePayload));

			assertThat(reported,array(concretePayload));
		}

		[Test]
		public function test_falls_back_to_normal_eventCommandMap_behaviour_when_not_payloadEvent():void
		{
			subject.map(SupportEvent.TYPE).toCommand(EventReportingCommand);
			var event:Event = new SupportEvent(SupportEvent.TYPE);

			dispatcher.dispatchEvent(event);

			assertThat(reported, array(event));
		}

		[Test]
		public function test_event_is_injected_when_no_payload_dispatched() : void{
			subject.map(LoosePayloadEvent.TYPE).toCommand(EventReportingCommand);
			var event:Event = new LoosePayloadEvent(LoosePayloadEvent.TYPE);

			dispatcher.dispatchEvent(event);

			assertThat(reported, array(event));
		}

		[Test]
		public function test_command_does_not_execute_when_incorrect_eventClass_dispatched() : void{
			subject.map(SupportEvent.TYPE,LoosePayloadEvent).toCommand(ClassReportingCommand);

			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE));

			assertThat(reported,array());
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function reportingFunction(item:Object):void
		{
			reported.push(item);
		}
	}
}

import robotlegs.bender.extensions.payloadEvents.support.IPayload;
import robotlegs.bender.extensions.payloadEvents.support.NullPayload;

class CommandWithInjectionPoints
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	[Inject]
	public var foo:String;

	[Inject]
	public var bar:IPayload;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc(foo);
		reportingFunc(bar);
	}
}

class CommandWithConcreteInjectionPoints
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	[Inject]
	public var payload:NullPayload;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc(payload);
	}
}
