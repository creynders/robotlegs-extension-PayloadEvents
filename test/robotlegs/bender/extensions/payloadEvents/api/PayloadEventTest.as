//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.api
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;

	import robotlegs.bender.extensions.payloadEvents.support.IPayload;
	import robotlegs.bender.extensions.payloadEvents.support.LoosePayloadEvent;
	import robotlegs.bender.extensions.payloadEvents.support.NullPayload;
	import robotlegs.bender.extensions.payloadEvents.support.StrictPayloadEvent;
	import robotlegs.bender.extensions.payloadEvents.support.StrictPayloadWithConfigurationBeforeSuperEvent;

	public class PayloadEventTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:PayloadEvent;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setup():void
		{

		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function test_value_classes_can_be_configured_after_super():void
		{

			subject = new StrictPayloadEvent('test', 'foo', new NullPayload());

			assertThat(subject.valueClasses, array(String, IPayload));
		}

		[Test]
		public function test_value_classes_can_be_configured_before_super():void
		{

			subject = new StrictPayloadWithConfigurationBeforeSuperEvent('test', 'foo', new NullPayload());

			assertThat(subject.valueClasses, array(String, IPayload));
		}

		[Test]
		public function test_value_classes_can_be_configured_after_instantiation():void
		{
			subject = new LoosePayloadEvent(LoosePayloadEvent.TYPE, 'foo', new NullPayload());

			subject.withValueClasses(String, IPayload);

			assertThat(subject.valueClasses, array(String, IPayload));
		}

		[Test(expects="ArgumentError")]
		public function test_throws_error_when_numValueObjects_does_not_match_numValueClasses():void
		{
			subject = new LoosePayloadEvent(LoosePayloadEvent.TYPE);

			subject.withValueClasses(String, IPayload);

			// note: no assertion. we just want to know if an error is thrown
		}

		[Test(expects="ArgumentError")]
		public function test_throws_error_when_valueObjects_types_do_not_match_valueClasses():void
		{
			subject = new LoosePayloadEvent(LoosePayloadEvent.TYPE, 5, new NullPayload());

			subject.withValueClasses(String, IPayload);

			// note: no assertion. we just want to know if an error is thrown
		}

		[Test]
		public function test_stores_valueObjects_when_valueClasses_not_configured() : void{
			const foo : String = 'foo';
			const bar : Object = new NullPayload();

			subject = new LoosePayloadEvent( LoosePayloadEvent.TYPE, foo, bar);

			assertThat( subject.valueObjects, array( foo, bar ) );
		}

	}
}
