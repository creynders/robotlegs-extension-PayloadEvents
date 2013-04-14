//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl
{
	import robotlegs.bender.extensions.payloadEvents.api.IPayloadExtractionPoint;

	public class FieldPayloadExtractionPoint implements IPayloadExtractionPoint
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _memberName:String;

		public function get memberName():String
		{
			return _memberName;
		}

		private var _valueType:Class;

		public function get valueType():Class
		{
			return _valueType;
		}

		private var _ordinal:int;

		public function get ordinal():int
		{
			return _ordinal;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function FieldPayloadExtractionPoint(memberName:String, valueType:Class, ordinal:int = 0)
		{
			_memberName = memberName;
			_valueType = valueType;
			_ordinal = ordinal;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extract(instance:Object):*
		{
			return instance[_memberName];
		}
	}
}
