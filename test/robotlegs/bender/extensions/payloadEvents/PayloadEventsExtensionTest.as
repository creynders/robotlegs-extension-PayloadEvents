//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;

	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
	import robotlegs.bender.extensions.payloadEvents.api.IPayloadEventCommandMap;
	import robotlegs.bender.framework.impl.Context;

	public class PayloadEventsExtensionTest
	{

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		private var context:Context;
		[Before]
		public function setup():void
		{
			context = new Context();
			context.install(EventDispatcherExtension);

		}
		[Test]
		public function payloadEventCommandMap_is_mapped_into_injector():void
		{
			var actual:Object = null;
			context.install(PayloadEventsExtension);
			context.whenInitializing( function():void {
				actual = context.injector.getInstance(IPayloadEventCommandMap);
			});
			context.initialize();
			assertThat(actual, instanceOf(IPayloadEventCommandMap));
		}
	}
}
