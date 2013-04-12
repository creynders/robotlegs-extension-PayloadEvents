package robotlegs.bender.extensions.payloadEvents.support
{
	import robotlegs.bender.extensions.payloadEvents.api.PayloadEvent;

	public class LoosePayloadEvent extends PayloadEvent
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const TYPE:String = 'LoosePayloadEvent/type';

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function LoosePayloadEvent(type:String, ... valueObjects)
		{
			super(type, valueObjects);
		}
	}
}