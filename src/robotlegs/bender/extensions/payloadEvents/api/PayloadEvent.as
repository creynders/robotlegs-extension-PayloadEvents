//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.payloadEvents.api
{
	import flash.events.Event;

	/**
	 * Parts of code lifted ad verbatim from Robert Penner's Signal library
	 * Copyright (c) 2009 Robert Penner
	 *
	 * @see https://github.com/robertpenner/as3-signals
	 */
	public class PayloadEvent extends Event
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _valueObjects:Array;

		public function get valueObjects():Array
		{
			return _valueObjects;
		}

		private var _valueClasses:Array;

		public function get valueClasses():Array
		{
			return _valueClasses;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PayloadEvent(type:String, ...valueObjects)
		{
			super(type)
			// Cannot use super.apply(null, valueObjects), so allow the subclass to call super(type, valueObjects).
			_valueObjects = (valueObjects.length == 1 && valueObjects[0] is Array)
				? valueObjects[0]
				: valueObjects;
			_valueClasses && validateConfiguration();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function withValueClasses(... valueClasses):void
		{
			_valueClasses = valueClasses;
			_valueObjects && validateConfiguration();
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function validateConfiguration():void
		{
			if (_valueClasses && _valueClasses.length > 0)
			{
				if (_valueObjects.length != _valueClasses.length)
				{
					throw new ArgumentError('Incorrect number of arguments. ' +
						'Expected at least ' + _valueClasses.length + ' but received ' +
						_valueObjects.length + '.');
				}

				validating: for (var i:int = 0; i < _valueClasses.length; i++)
				{
					// Optimized for the optimistic case that values are correct.
					if (_valueObjects[i] is _valueClasses[i] || _valueObjects[i] === null)
						continue validating;

					throw new ArgumentError('Value object <' + _valueObjects[i]
						+ '> is not an instance of <' + _valueClasses[i] + '>.');
				}
			}
		}
	}
}
