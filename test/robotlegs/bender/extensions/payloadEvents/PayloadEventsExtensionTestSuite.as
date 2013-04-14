//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents
{
	import robotlegs.bender.extensions.payloadEvents.impl.extraction.FieldPayloadExtractionPointTest;
	import robotlegs.bender.extensions.payloadEvents.impl.extraction.MethodPayloadExtractionPointTest;
	import robotlegs.bender.extensions.payloadEvents.impl.PayloadEventCommandMapIntegrationTest;
	import robotlegs.bender.extensions.payloadEvents.impl.PayloadEventCommandTriggerTest;
	import robotlegs.bender.extensions.payloadEvents.impl.extraction.PayloadExtractorTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class PayloadEventsExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var payloadEventsExtension:PayloadEventsExtensionTest;

		public var payloadEventCommandTrigger:PayloadEventCommandTriggerTest;

		public var payloadEventsExtensionIntegration:PayloadEventCommandMapIntegrationTest;

		public var payloadExtractor:PayloadExtractorTest;

		public var fieldPayloadExtractionPoint : FieldPayloadExtractionPointTest;

		public var methodPayloadExtractionPoint : MethodPayloadExtractionPointTest;
	}
}
