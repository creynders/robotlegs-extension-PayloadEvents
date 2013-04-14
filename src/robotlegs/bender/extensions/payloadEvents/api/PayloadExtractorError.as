//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.api
{

	public class PayloadExtractorError extends Error
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PayloadExtractorError(message:* = '', id:* = 0)
		{
			super(message, id);
		}
	}
}
