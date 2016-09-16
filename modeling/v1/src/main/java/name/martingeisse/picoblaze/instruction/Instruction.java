package name.martingeisse.picoblaze.instruction;

import name.martingeisse.picoblaze.simulation.PicoblazeState;

/**
 *
 */
public interface Instruction {

	/**
	 * Simulates the effect of this instruction on the specified simulator state.
	 *
	 * This method is called after the simulator's program counter has been moved to the next instruction.
	 *
	 * @param state the simulator state
	 */
	public void simulate(PicoblazeState state);

	/**
	 * Encodes this instruction.
	 *
	 * @return the encoded instruction
	 */
	public int encode();

}
