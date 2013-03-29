//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.support
{
	import robotlegs.bender.extensions.payloadEvents.api.PayloadEvent;

	public class ConfiguredPayloadEvent extends PayloadEvent
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const TYPE:String = 'type';

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ConfiguredPayloadEvent(type:String, ... valueObjects)
		{
			super(type, valueObjects);
			withValueClasses(String, Object);
		}
	}
}
