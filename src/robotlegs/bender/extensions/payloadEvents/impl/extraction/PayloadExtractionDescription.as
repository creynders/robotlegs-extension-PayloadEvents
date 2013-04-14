//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl.extraction
{
	import robotlegs.bender.extensions.payloadEvents.api.IPayloadExtractionPoint;

	public class PayloadExtractionDescription
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _mappingId:String;

		public function get mappingId():String
		{
			return _mappingId;
		}

		private var _extractionPoints:Vector.<IPayloadExtractionPoint>;

		public function get extractionPoints():Vector.<IPayloadExtractionPoint>
		{
			return _extractionPoints ||= new Vector.<IPayloadExtractionPoint>();
		}

		public function get numPoints():int
		{
			return _extractionPoints
				? _extractionPoints.length
				: 0;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PayloadExtractionDescription(mappingId:String)
		{
			_mappingId = mappingId;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addExtractionPoint(point:IPayloadExtractionPoint):void
		{
			extractionPoints.push(point);
		}

		public function sortPoints():void
		{
			_extractionPoints && _extractionPoints.sort(sorter);
		}

		private function sorter(a:IPayloadExtractionPoint,b:IPayloadExtractionPoint):Number
		{
			return a.ordinal - b.ordinal;
		}
	}
}
