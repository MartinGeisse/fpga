package name.martingeisse.picoblaze.assembler;

import name.martingeisse.picoblaze.instruction.Instruction;

/**
 * Tagging interface that is used for keyword-set implementations for the assembly phase.
 */
public class StandardAssemblyPhaseKeywords extends StandardKeywords implements AssemblyPhaseKeywords {

	public StandardAssemblyPhaseKeywords(name.martingeisse.picoblaze.assembler.AssemblerState state) {
		super(state);
	}

	@Override
	public void instruction(Instruction instruction) {
		// TODO
	}

}
