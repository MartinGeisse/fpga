/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */
package name.martingeisse.pico_old.ast;

import name.martingeisse.picoblaze.assembler.IPicoblazeAssemblerErrorHandler;

import java.util.HashMap;
import java.util.Map;

/**
 * This class collects information during compilation.
 */
public class Context {

	/**
	 * The mapping of labels to addresses.
	 */
	private final Map<String, Integer> labels;

	/**
	 * the errorHandler
	 */
	private final IPicoblazeAssemblerErrorHandler errorHandler;

	/**
	 * Creates a new default context. No constants or labels are defined,
	 * and all registers use their default names.
	 * @param errorHandler the error handler
	 */
	public Context(final IPicoblazeAssemblerErrorHandler errorHandler) {
		this.labels = new HashMap<String, Integer>();
		this.errorHandler = errorHandler;

		for (int i = 0; i < 10; i++) {
			final char c = (char)(i + '0');
			final String name = "s" + c;
			registers.put(name, i);
		}
		for (int i = 0; i < 6; i++) {
			final char c = (char)(i + 'A');
			final String name = "s" + c;
			registers.put(name, 10 + i);
		}
	}

	/**
	 * Resolves a label name to its address. Returns -1 if no such
	 * label is known.
	 * @param name the name to look for
	 * @return the label position
	 */
	public int getLabel(final String name) {
		final Integer result = labels.get(name);
		if (result == null) {
			return -1;
		} else {
			return result;
		}
	}

	/**
	 * Defines a label in this context.
	 * @param label the label to add
	 * @param address the address of the label
	 */
	public void addLabel(final PsmLabel label, final int address) {
		final Integer old = labels.put(label.getName(), address);
		if (old != null) {
			errorHandler.handleError("Duplicate label: " + label.getName());
		}
	}

	/**
	 * Defines a constant in this context.
	 * @param constant the constant to add
	 */
	public void addConstant(final PsmConstant constant) {
		final Integer previous = constants.put(constant.getName(), constant.getValue());
		if (previous != null) {
			errorHandler.handleError(constant.getName() + " has already been defined as a constant");
		}
		if (registers.get(constant.getName()) != null) {
			errorHandler.handleError(constant.getName() + " has already been defined as a register");
		}
	}

	/**
	 * Renames a register.
	 * @param renaming the register renaming
	 */
	public void renameRegister(final PsmNamereg renaming) {

		final String oldName = renaming.getOldName();
		final String newName = renaming.getNewName();

		final Integer index = registers.remove(oldName);
		if (index == null) {
			errorHandler.handleError("No such register: " + oldName);
		}

		final Integer previous = registers.put(newName, index);
		if (previous != null) {
			errorHandler.handleError(newName + " has already been defined as a register");
		}
		if (constants.get(newName) != null) {
			errorHandler.handleError(newName + " has already been defined as a constant");
		}

	}

}
