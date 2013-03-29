//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.swiftsuspenders.Injector;

	import robotlegs.bender.extensions.payloadEvents.api.IPayloadEventCommandMap;
	import robotlegs.bender.extensions.payloadEvents.support.ConfiguredPayloadEvent;
	import robotlegs.bender.extensions.payloadEvents.support.UnconfiguredPayloadEvent;
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
		public function test_maps_payload():void
		{
			const foo : String = 'payload';
			const bar : Object = {};
			subject.map( ConfiguredPayloadEvent.TYPE )
				.toCommand( CommandA );

			dispatcher.dispatchEvent( new ConfiguredPayloadEvent( ConfiguredPayloadEvent.TYPE, foo, bar ) );

			assertThat( reported, array( foo, bar ) );
		}

		[Test(expects="ArgumentError")]
		public function test_throws_error_when_dispatched_values_length_does_not_match_configured() : void{
			const foo : String = 'payload';
			subject.map( ConfiguredPayloadEvent.TYPE )
				.toCommand( CommandA );

			dispatcher.dispatchEvent( new ConfiguredPayloadEvent( ConfiguredPayloadEvent.TYPE, foo ) );
		}

		[Test(expects="ArgumentError")]
		public function test_throws_error_when_dispatched_values_do_not_match_configured_classes() : void{
			const foo : int = 5;
			const bar : Object = {};
			subject.map( ConfiguredPayloadEvent.TYPE )
				.toCommand( CommandA );

			dispatcher.dispatchEvent( new ConfiguredPayloadEvent( ConfiguredPayloadEvent.TYPE, foo, bar ) );
		}

		[Test]
		public function test_maps_valueObjects_when_valueClasses_not_configured() : void{
			const foo : String = 'foo';
			const bar : Object = {};
			subject.map( UnconfiguredPayloadEvent.TYPE )
				.toCommand( CommandA );

			dispatcher.dispatchEvent( new UnconfiguredPayloadEvent( UnconfiguredPayloadEvent.TYPE, foo, bar ) );

			assertThat( reported, array( foo, bar ) );
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
class CommandA
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	[Inject]
	public var foo : String;

	[Inject]
	public var bar : Object;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc(foo);
		reportingFunc(bar);
	}
}