//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.support
{
	import robotlegs.bender.extensions.payloadEvents.api.PayloadEvent;

	/**
	 * @author creynder
	 */
	public class StrictPayloadWithConfigurationBeforeSuperEvent extends PayloadEvent
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const TYPE:String = 'StrictPayloadWithConfigurationBeforeSuperEvent/type';

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StrictPayloadWithConfigurationBeforeSuperEvent(type:String, p1:String, p2:IPayload)
		{
			withValueClasses(String, IPayload);
			super(type, p1, p2);
		}
	}
}
