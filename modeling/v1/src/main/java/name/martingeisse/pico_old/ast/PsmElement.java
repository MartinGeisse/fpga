/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */
package name.martingeisse.pico_old.ast;

/**
 * This class represents a single element from a PSM file. It is
 * used for directives, labels, and instructions.
 */
public abstract class PsmElement {

	/**
	 * This method can be used to check values at construction.
	 * It throws an <code>IllegalArgumentException</code> if
	 * the <code>value</code> is not in the range (0..255).
	 */
	protected final void checkByte(final int value, final String meaning) {
		checkValue(value, 0, 255, meaning);
	}

	/**
	 * This method can be used to check values at construction.
	 * It throws an <code>IllegalArgumentException</code> if
	 * the <code>value</code> is not in the range (min..max).
	 */
	protected final void checkValue(final int value, final int min, final int max, final String meaning) {
		if (value < min || value > max) {
			throw new IllegalArgumentException("invalid " + meaning + ": " + value + " is not in the range (" + min + "..." + max + ")");
		}
	}

	/**
	 * Throws an error about an undefined register name.
	 * @param name the unknown name
	 * @param errorHandler the error handler
	 */
	protected void noSuchRegister(final String name) {
		errorHandler.handleError("No such register: " + name);
	}

	/**
	 * Throws an error about an undefined register name.
	 * @param name the unknown name
	 * @param errorHandler the error handler
	 */
	protected void noSuchRegisterOrConstant(final String name) {
		errorHandler.handleError("No such register or constant: " + name);
	}

	/**
	 * Throws an error about an undefined label name.
	 * @param name the unknown name
	 * @param errorHandler the error handler
	 */
	protected void noSuchLabel(final String name) {
		errorHandler.handleError("No such label: " + name);
	}

}
