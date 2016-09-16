package name.martingeisse.picoblaze.assembler;

import groovy.lang.Binding;
import groovy.lang.Closure;
import groovy.lang.Script;

/**
 *
 */
public class PicoblazeAssembler {

	public static void assemble(Script script, AnalysisPhaseKeywords analysisPhaseKeywords, AssemblyPhaseKeywords assemblyPhaseKeywords) {
		Binding binding = new Binding();
		binding.setProperty("picoblaze", new Object() {
			public void call(Closure closure) {
				closure.setResolveStrategy(Closure.DELEGATE_FIRST);
				closure.setDelegate(analysisPhaseKeywords);
				closure.call();
				closure.setDelegate(assemblyPhaseKeywords);
				closure.call();
			}
		});
		script.setBinding(binding);
		script.run();
	}

}
