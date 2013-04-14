package robotlegs.bender.extensions.payloadEvents.impl.execution
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.nullValue;

	import robotlegs.bender.extensions.payloadEvents.support.ExecuteTaggedCommand;
	import robotlegs.bender.extensions.payloadEvents.support.MultipleExecuteTaggedMethodsCommand;

	public class ExecutionReflectorTest{
		private var subject : ExecutionReflector;

		[Before]
		public function setup() : void{
			subject = new ExecutionReflector();
		}

		[Test]
		public function describes_execution_method_as_null_when_tag_not_found() : void{
			assertThat(subject.describeExecutionMethodForClass(Class),nullValue());
		}

		[Test]
		public function desscribes_execution_method_when_tag_found() : void{
			assertThat(subject.describeExecutionMethodForClass(ExecuteTaggedCommand),equalTo('executeTaggedMethod'));
		}
		[Test(expects="robotlegs.bender.extensions.payloadEvents.api.ExecutionReflectorError")]
		public function error_is_thrown_when_multiple_execute_tags_found() : void{
			subject.describeExecutionMethodForClass(MultipleExecuteTaggedMethodsCommand);
		}
	}
}