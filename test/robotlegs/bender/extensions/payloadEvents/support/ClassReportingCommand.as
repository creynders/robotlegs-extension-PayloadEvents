//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.support
{
	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	public class ClassReportingCommand implements ICommand
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject(name='reportingFunction')]
		public var reportingFunc:Function;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function execute():void
		{
			reportingFunc(ClassReportingCommand);
		}
	}
}
