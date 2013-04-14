//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.support
{
	import flash.events.Event;

	public class OrderedExtractionPointsEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const TYPE:String = 'ExtractionPointsEvent/TYPE';

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Extract(order=1)]
		public var extractTaggedProperty:String = 'extractTaggedProperty';

		[Extract(order=3)]
		public function get extractTaggedGetter():Object
		{
			return extractTaggedGetterValue;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var extractTaggedGetterValue:Object = {};

		private var extractTaggedMethodValue:IPayload = new NullPayload();

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function OrderedExtractionPointsEvent()
		{
			super(TYPE);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[Extract(order=2)]
		public function extractTaggedMethod():IPayload
		{
			return extractTaggedMethodValue;
		}
	}
}
