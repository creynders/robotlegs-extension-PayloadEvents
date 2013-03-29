package robotlegs.bender.extensions.payloadEvents.support
{
	import robotlegs.bender.extensions.payloadEvents.api.PayloadEvent;

	public class UnconfiguredPayloadEvent extends PayloadEvent
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const TYPE:String = 'type';

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function UnconfiguredPayloadEvent(type:String, ... valueObjects)
		{
			super(type, valueObjects);
		}
	}
}