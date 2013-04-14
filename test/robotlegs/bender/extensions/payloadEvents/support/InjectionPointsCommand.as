//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.support
{

	public class InjectionPointsCommand
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject(name='reportingFunction')]
		public var reportingFunc:Function;

		[Inject]
		public var injectedStringValue:String;

		[Inject]
		public var injectedObjectValue:Object;

		[Inject]
		public var injectedPayloadValue:IPayload;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function execute():void
		{
			reportingFunc(injectedStringValue);
			reportingFunc(injectedObjectValue);
			reportingFunc(injectedPayloadValue);
		}
	}
}
