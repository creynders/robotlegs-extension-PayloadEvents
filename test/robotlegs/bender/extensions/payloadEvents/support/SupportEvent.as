//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.support
{
	import flash.events.Event;

	public class SupportEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const TYPE:String = 'SupportEvent/TYPE';

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function SupportEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
