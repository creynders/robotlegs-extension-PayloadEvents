package robotlegs.bender.extensions.payloadEvents.support
{
	import robotlegs.bender.extensions.payloadEvents.api.PayloadEvent;

	/**
	 * @author creynder
	 */
	public class StrictPayloadWithConfigurationBeforeSuperEvent extends PayloadEvent{
		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const TYPE:String = 'StrictPayloadWithConfigurationBeforeSuperEvent/type';
		public function StrictPayloadWithConfigurationBeforeSuperEvent(type : String, p1:String, p2:IPayload)
		{
			withValueClasses(String, IPayload);
			super(type, [p1,p2]);
		}
	}
}