/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */
package name.martingeisse.picoblaze.instruction;

import name.martingeisse.pico_old.ast.Context;
import name.martingeisse.picoblaze.assembler.IPicoblazeAssemblerErrorHandler;

/**
 * An instruction that uses no operands, i.e. the opcode itself is also the
 * encoded instruction. Note that RETURN* instructions use InstructionJ_
 * instead of this class, even though they do not use an operand.
 */
public class InstructionN_ implements Instruction {

	/**
	 * The opcode used for this instruction.
	 */
	private final int opcode;

	/**
	 * Creates a new N instruction instance with the specified opcode
	 * @param opcode the instruction opcode
	 */
	public InstructionN_(final int opcode) {
		this.opcode = opcode;
	}

	/**
	 * @return the opcode of this instruction.
	 */
	public int getOpcode() {
		return opcode;
	}

	/* (non-Javadoc)
	 * @see name.martingeisse.esdk.pico_old.assembler.ast.PsmInstruction#encode(name.martingeisse.esdk.pico_old.assembler.ast.Context, name.martingeisse.esdk.pico_old.assembler.IPicoblazeAssemblerErrorHandler)
	 */
	@Override
	public int encode(final Context context, final IPicoblazeAssemblerErrorHandler errorHandler) {
		return opcode;
	}

}
