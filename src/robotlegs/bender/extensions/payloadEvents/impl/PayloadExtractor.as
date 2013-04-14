//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flex.lang.reflect.Method;
	import robotlegs.bender.extensions.payloadEvents.api.IPayloadExtractionPoint;
	import robotlegs.bender.extensions.payloadEvents.api.PayloadExtractorError;
	import robotlegs.bender.extensions.payloadEvents.support.OrderedExtractionPointsEvent;
	import robotlegs.bender.framework.api.ILogger;

	public class PayloadExtractor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PayloadExtractor(logger:ILogger = null)
		{
			_logger = logger;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function parseDescriptionFromInstance(instance:Object):PayloadExtractionDescription
		{
			return parseExtractionPoints(describeType(instance));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function parseExtractionPoints(rawDescription:XML):PayloadExtractionDescription
		{
			const fqn:String = rawDescription.attribute('name');
			const payloadDescription:PayloadExtractionDescription = new PayloadExtractionDescription(fqn);
			parsePropertyExtractionPoints(rawDescription, payloadDescription);
			parseAccessorExtractionPoints(rawDescription, payloadDescription);
			parseMethodExtractionPoints(rawDescription, payloadDescription);
			payloadDescription.sortPoints();
			return payloadDescription;
		}

		private function parseMethodExtractionPoints(rawDescription:XML, payloadDescription:PayloadExtractionDescription):void
		{
			for each (var extractTag:XML in rawDescription.method.metadata.(@name == 'Extract'))
			{
				const memberDescription:XML = extractTag.parent();
				const memberName:String = memberDescription.attribute('name');

				if (memberDescription.parameter.length() > 0)
					throw new PayloadExtractorError('Methods with parameters are not extractable ' + rawDescription.attribute('name') + '#' + memberName);

				const valueType:String = memberDescription.attribute('returnType');
				if (valueType == 'void')
					throw new PayloadExtractorError('Methods without return type are not extractable ' + rawDescription.attribute('name') + '#' + memberName);

				payloadDescription.addExtractionPoint(new MethodPayloadExtractionPoint(
					memberName,
					getDefinitionByName(valueType) as Class,
					getOrdinal(extractTag)));
			}
		}

		private function parseAccessorExtractionPoints(rawDescription:XML, payloadDescription:PayloadExtractionDescription):void
		{
			for each (var extractTag:XML in rawDescription.accessor.metadata.(@name == 'Extract'))
			{
				const memberDescription:XML = extractTag.parent();
				const memberName:String = memberDescription.attribute('name');

				if (memberDescription.hasOwnProperty('@access') && memberDescription.attribute('access') == 'writeonly')
					throw new PayloadExtractorError('Setters are not extractable ' + rawDescription.attribute('name') + '#' + memberName);

				payloadDescription.addExtractionPoint(new FieldPayloadExtractionPoint(
					memberName,
					getDefinitionByName(memberDescription.attribute('type')) as Class,
					getOrdinal(extractTag)));
			}
		}

		private function parsePropertyExtractionPoints(rawDescription:XML, payloadDescription:PayloadExtractionDescription):void
		{
			for each (var extractTag:XML in rawDescription.variable.metadata.(@name == 'Extract'))
			{
				const memberDescription:XML = extractTag.parent();
				payloadDescription.addExtractionPoint(new FieldPayloadExtractionPoint(
					memberDescription.attribute('name'),
					getDefinitionByName(memberDescription.attribute('type')) as Class,
					getOrdinal(extractTag)));
			}
		}

		private function getOrdinal(extractTag:XML):Number
		{
			const ordinal:Number = parseInt(extractTag.arg.(@key == 'order').@value);
			return isNaN(ordinal) ? 0 : ordinal;
		}
	}
}
