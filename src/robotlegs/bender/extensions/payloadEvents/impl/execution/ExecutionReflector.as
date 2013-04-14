//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.impl.execution
{
	import flash.utils.describeType;

	import robotlegs.bender.extensions.payloadEvents.api.ExecutionReflectorError;

	public class ExecutionReflector
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function describeExecutionMethodForClass(type:Class):String
		{
			var factoryDescription:XML = describeType(type).factory[0];
			var list:XMLList = factoryDescription.method.metadata.(@name == 'Execute');
			switch (list.length())
			{
				case 1:
					var memberDescription:XML = list[0].parent();
					return memberDescription.attribute('name');
				case 0:
					return null;
				default:
					throw new ExecutionReflectorError('Only one Execute-tagged method allowed');
			}
		}
	}
}