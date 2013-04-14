//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl.extraction
{
	import mockolate.runner.MockolateRule;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	import robotlegs.bender.extensions.payloadEvents.api.IPayloadExtractionPoint;
	import robotlegs.bender.extensions.payloadEvents.support.ExtractableGetterEvent;
	import robotlegs.bender.extensions.payloadEvents.support.ExtractableMethodEvent;
	import robotlegs.bender.extensions.payloadEvents.support.ExtractablePropertyEvent;
	import robotlegs.bender.extensions.payloadEvents.support.IPayload;
	import robotlegs.bender.extensions.payloadEvents.support.OrderedExtractionPointsEvent;
	import robotlegs.bender.framework.api.ILogger;

	public class PayloadExtractorTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var logger:ILogger;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:PayloadReflector;

		private var extractedPropertyDescription:IPayloadExtractionPoint;

		private var extractedGetterDescription:IPayloadExtractionPoint;

		private var extractedMethodDescription:IPayloadExtractionPoint;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setup():void
		{
			subject = new PayloadReflector(logger);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function parseDescriptionFromInstance_returns_descriptor():void
		{
			assertThat(subject.describeExtractionsForInstance({}), instanceOf(PayloadExtractionDescription));
		}

		[Test]
		public function parses_mapping_id():void
		{
			const description:PayloadExtractionDescription = subject.describeExtractionsForInstance(new OrderedExtractionPointsEvent());
			assertThat(description.mappingId, equalTo('robotlegs.bender.extensions.payloadEvents.support::OrderedExtractionPointsEvent'));
		}

		[Test]
		public function parses_properties():void
		{
			const description:PayloadExtractionDescription = subject.describeExtractionsForInstance(new ExtractablePropertyEvent());
			const point:IPayloadExtractionPoint = description.extractionPoints[0];
			assertThat(point.memberName, equalTo('extractTaggedProperty'));
			assertThat(point.valueType, equalTo(String));
			assertThat(point, instanceOf(FieldPayloadExtractionPoint));
		}

		[Test]
		public function parses_getters():void
		{
			const description:PayloadExtractionDescription = subject.describeExtractionsForInstance(new ExtractableGetterEvent());
			const point:IPayloadExtractionPoint = description.extractionPoints[0];
			assertThat(point.memberName, equalTo('extractTaggedGetter'));
			assertThat(point.valueType, equalTo(Object));
			assertThat(point, instanceOf(FieldPayloadExtractionPoint));
		}

		[Test]
		public function parses_methods():void
		{
			const description:PayloadExtractionDescription = subject.describeExtractionsForInstance(new ExtractableMethodEvent());
			const point:IPayloadExtractionPoint = description.extractionPoints[0];
			assertThat(point.memberName, equalTo('extractTaggedMethod'));
			assertThat(point.valueType, equalTo(IPayload));
			assertThat(point, instanceOf(MethodPayloadExtractionPoint));
		}

		[Test(expects="robotlegs.bender.extensions.payloadEvents.api.PayloadExtractorError")]
		public function setter_throws_error():void
		{
			subject.describeExtractionsForInstance(new ExtractSetterEvent());
			// note: no assertion. we just want to know if an error is thrown
		}

		[Test(expects="robotlegs.bender.extensions.payloadEvents.api.PayloadExtractorError")]
		public function method_with_parameters_throws_error():void
		{
			subject.describeExtractionsForInstance(new ExtractMethodWithParametersEvent());
			// note: no assertion. we just want to know if an error is thrown
		}

		[Test(expects="robotlegs.bender.extensions.payloadEvents.api.PayloadExtractorError")]
		public function method_with_void_return_type_throws_error():void
		{
			subject.describeExtractionsForInstance(new ExtractMethodWithVoidReturnTypeEvent());
			// note: no assertion. we just want to know if an error is thrown
		}

		[Test]
		public function points_are_ordered_when_tagged_with_order() : void{
			const description:PayloadExtractionDescription = subject.describeExtractionsForInstance(new OrderedExtractionPointsEvent());
			const p0:IPayloadExtractionPoint = description.extractionPoints[0];
			const p1:IPayloadExtractionPoint = description.extractionPoints[1];
			const p2:IPayloadExtractionPoint = description.extractionPoints[2];
			assertThat(p0.memberName, equalTo('extractTaggedProperty'));
			assertThat(p1.memberName, equalTo('extractTaggedMethod'));
			assertThat(p2.memberName, equalTo('extractTaggedGetter'));
		}
	}
}

import flash.events.Event;

class ExtractSetterEvent extends Event
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Extract]
	public function set extractSetter(value:String):void
	{

	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function ExtractSetterEvent()
	{
		super('ExtractSetterEvent/TYPE');
	}
}

class ExtractMethodWithParametersEvent extends Event
{

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function ExtractMethodWithParametersEvent()
	{
		super('ExtractMethodWithParametersEvent/TYPE');
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	[Extract]
	public function methodWithParameters(p1:String, p2:Object):int
	{
		return 0;
	}
}

class ExtractMethodWithVoidReturnTypeEvent extends Event
{

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function ExtractMethodWithVoidReturnTypeEvent()
	{
		super('ExtractMethodWithVoidReturnTypeEvent/TYPE');
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	[Extract]
	public function methodWithVoidReturnType():void
	{
	}
}
