package name.martingeisse.picoblaze.assembler;

import name.martingeisse.picoblaze.instruction.Instruction;

/**
 * Tagging interface that is used for keyword-set implementations for the analysis phase.
 */
public class StandardAnalysisPhaseKeywords extends StandardKeywords implements AnalysisPhaseKeywords {

	public StandardAnalysisPhaseKeywords(AssemblerState state) {
		super(state);
	}

	@Override
	public void instruction(Instruction instruction) {
		// TODO
	}

}
