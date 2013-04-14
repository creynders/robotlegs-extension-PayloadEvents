//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl
{
	import flash.events.IEventDispatcher;

	import mockolate.received;
	import mockolate.runner.MockolateRule;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.Injector;

	import robotlegs.bender.extensions.commandCenter.impl.CommandMapper;
	import robotlegs.bender.extensions.payloadEvents.support.OrderedExtractionPointsEvent;
	import robotlegs.bender.framework.api.ILogger;

	public class PayloadEventCommandTriggerTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var injector:Injector;

		[Mock]
		public var dispatcher:IEventDispatcher;

		[Mock]
		public var logger:ILogger;

		[Mock]
		public var extractor:PayloadExtractor;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:PayloadEventCommandTrigger;

		private var type:String = 'PayloadEventCommandTriggerTest';

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setup():void
		{
			var eventClass:Class = OrderedExtractionPointsEvent;
			subject = new PayloadEventCommandTrigger(injector, dispatcher, type, eventClass, extractor, logger);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function test_createMapper_creates_mapper():void
		{
			var actual:Object = subject.createMapper();

			assertThat(actual, instanceOf(CommandMapper));
		}

		[Test]
		public function test_activate_registers_event_listener():void
		{
			subject.activate();
			assertThat(dispatcher, received().method('addEventListener').args(equalTo(type), instanceOf(Function)).once());
		}

		[Test]
		public function test_deactivate_unregisters_event_listener():void
		{
			subject.deactivate();
			assertThat(dispatcher, received().method('removeEventListener').args(equalTo(type), instanceOf(Function)).once());
		}
	}
}
