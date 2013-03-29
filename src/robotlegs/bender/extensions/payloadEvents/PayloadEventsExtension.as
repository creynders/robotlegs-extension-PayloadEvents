//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents
{
	/**
	 * @author creynder
	 */
	import robotlegs.bender.extensions.payloadEvents.api.IPayloadEventCommandMap;
	import robotlegs.bender.extensions.payloadEvents.impl.PayloadEventCommandMap;
	import robotlegs.bender.extensions.utils.ensureContextUninitialized;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	public class PayloadEventsExtension implements IExtension
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			ensureContextUninitialized(context, this);
			context.injector.map(IPayloadEventCommandMap).toSingleton(PayloadEventCommandMap);
		}
	}
}
