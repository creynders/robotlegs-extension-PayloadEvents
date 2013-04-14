//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.api
{

	public interface IPayloadExtractionPoint
	{
		function get memberName():String;
		function get valueType():Class;
		function get ordinal():int;

		function extract(instance:Object):*;
	}
}
