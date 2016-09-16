/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.pico_test;

import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

import name.martingeisse.pico_old.ast.Context;
import name.martingeisse.picoblaze.codegen.PsmVerilogUtil;

/**
 *
 */
public class AssemblerMain {

	/**
	 * @param args ...
	 * @throws Exception ...
	 */
	public static void main(final String[] args) throws Exception {

		final IPicoblazeAssemblerErrorHandler errorHandler = new IPicoblazeAssemblerErrorHandler() {

			@Override
			public void handleWarning(final Range range, final String message) {
				handleError(range, message);
			}

			@Override
			public void handleError(final Range range, final String message) {
				throw new RuntimeException("ERROR at " + range + ": " + message);
			}

		};
		
		final AstBuilder astBuilder = new AstBuilder();
		try (InputStreamReader reader = new InputStreamReader(AssemblerMain.class.getResourceAsStream("code.psm"), StandardCharsets.UTF_8)) {
			astBuilder.parse(reader, errorHandler);
		}
		PsmFile psmFile = astBuilder.getResult();
		Context context = new Context(errorHandler);
		psmFile.collectConstantsAndLabels(context);
		int[] encoded = psmFile.encode(context, errorHandler);
		
		System.out.println(PsmVerilogUtil.generateMemoryVerilog("ProgramMemory"));
		System.out.println();
		System.out.println("----------------------------------------------------------------");
		System.out.println();
		System.out.println(PsmVerilogUtil.generateMif(encoded));

	}

}
