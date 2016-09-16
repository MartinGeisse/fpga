/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */
package name.martingeisse.picoblaze.instruction;

import name.martingeisse.pico_old.ast.Context;
import name.martingeisse.picoblaze.assembler.IPicoblazeAssemblerErrorHandler;

/**
 * An instruction that uses a single register operand at the
 * position of register 1. This is used for shift and rotate instructions.
 *
 * The opcode in this class contains all bits except the four bits that
 * specify the register operand (which are set to 0 in the constants
 * defined here).
 */
public class InstructionR_ implements Instruction {

	/**
	 * The opcode used for this instruction.
	 */
	private final int opcode;

	/**
	 * Name of the register operand.
	 */
	private final String op;

	/**
	 * Creates a new R instruction instance with the specified opcode and register operand.
	 * @param opcode the instruction opcode
	 * @param op the operand register name
	 */
	public InstructionR_(final int opcode, final String op) {
		this.opcode = opcode;
		this.op = op;
	}

	/**
	 * @return the opcode of this instruction.
	 */
	public int getOpcode() {
		return opcode;
	}

	/**
	 * @return the register name of the operand.
	 */
	public String getFirstOperand() {
		return op;
	}

	/* (non-Javadoc)
	 * @see name.martingeisse.esdk.pico_old.assembler.ast.PsmInstruction#encode(name.martingeisse.esdk.pico_old.assembler.ast.Context, name.martingeisse.esdk.pico_old.assembler.IPicoblazeAssemblerErrorHandler)
	 */
	@Override
	public int encode(final Context context, final IPicoblazeAssemblerErrorHandler errorHandler) {

		final int reg = context.getRegister(op);
		if (reg == -1) {
			noSuchRegister(op, errorHandler);
		}

		return opcode + (reg << 8);
	}
}
