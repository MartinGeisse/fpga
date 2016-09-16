package name.martingeisse.picoblaze.instruction;

import name.martingeisse.pico_old.ast.Context;
import name.martingeisse.pico_old.ast.PsmElement;

/**
 *
 */
public final class Program {

	private final Instruction[] instructions = new Instruction[1024];

	/**
	 * Getter method.
	 *
	 * @return the instructions
	 */
	public Instruction[] getInstructions() {
		return instructions;
	}

	/**
	 * Encodes the program relative to the specified context. The result is
	 * an array of 1024 encoded instructions, each using a code word in the
	 * range 0..2^18-1.
	 *
	 * @return the encoded instructions. This array has always a length of 1024.
	 * The remainder of the array not used for instructions contains 0-values.
	 */
	public int[] encode() {
		final int[] result = new int[1024];
		for (int i=0; i<1024; i++) {
			result[i] = instructions[i].encode();
		}
		return result;
	}

}
