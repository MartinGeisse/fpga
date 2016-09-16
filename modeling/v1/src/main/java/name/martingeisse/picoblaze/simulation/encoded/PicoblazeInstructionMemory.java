/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.picoblaze.simulation.encoded;

import name.martingeisse.picoblaze.codegen.PsmBinUtil;
import name.martingeisse.picoblaze.simulation.PicoblazeSimulatorException;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;

/**
 * Default implementation of {@link IPicoblazeInstructionMemory} that
 * uses a 1024-element int array.
 */
public class PicoblazeInstructionMemory implements IPicoblazeInstructionMemory {

	/**
	 * the instructions
	 */
	private int[] instructions;

	/**
	 * Constructor.
	 */
	public PicoblazeInstructionMemory() {
	}

	/**
	 * Constructor.
	 * @param instructions the instructions
	 */
	public PicoblazeInstructionMemory(final int[] instructions) {
		this.instructions = instructions;
	}

	/**
	 * Getter method for the instructions.
	 * @return the instructions
	 */
	public int[] getInstructions() {
		return instructions;
	}

	/**
	 * Setter method for the instructions.
	 * @param instructions the instructions to set
	 */
	public void setInstructions(final int[] instructions) {
		if (instructions.length != 1024) {
			throw new IllegalArgumentException("invalid instruction array length (1024 expected): " + instructions);
		}
		this.instructions = instructions;
	}

	/* (non-Javadoc)
	 * @see name.martingeisse.esdk.pico_old.old_simulator.instruction.IPicoblazeInstructionMemory#getInstruction(int)
	 */
	@Override
	public int getInstruction(final int address) throws PicoblazeSimulatorException {
		if (address < 0 || address >= 1024) {
			throw new PicoblazeSimulatorException("invalid instruction address: " + address);
		}
		if (instructions == null) {
			throw new PicoblazeSimulatorException("instructions array is null");
		}
		return instructions[address];
	}

	/**
	 * Creates a {@link PicoblazeInstructionMemory} instance from a .psmbin file.
	 * @param file the file to load
	 * @return the memory instance
	 * @throws IOException on I/O errors
	 */
	public static PicoblazeInstructionMemory createFromPsmBinFile(final File file) throws IOException {
		final byte[] encodedInstructions = FileUtils.readFileToByteArray(file);
		final int[] instructions = PsmBinUtil.decodePsmBin(encodedInstructions);
		return new PicoblazeInstructionMemory(instructions);
	}

}
