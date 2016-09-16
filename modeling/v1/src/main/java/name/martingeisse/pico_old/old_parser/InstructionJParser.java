package name.martingeisse.pico_old.old_parser;

import name.martingeisse.picoblaze.instruction.PicoblazeAssemblerOpcodes;
import name.martingeisse.picoblaze.assembler.Range;

import java.io.IOException;

/**
 * Sub-parser for jump-type instructions.
 */
public class InstructionJParser extends DirectiveParser {

	/**
	 * the opcode
	 */
	private final int opcode;

	private void handle(final Token location, final Parser parser, final ParserClient client, final Token conditionToken, final String conditionString, final Token labelToken, final String labelString) throws LineSyntaxException {

		int condition;
		if (conditionString != null) {
			if (conditionString.equalsIgnoreCase("z")) {
				condition = PicoblazeAssemblerOpcodes.CONDITION_Z;
			} else if (conditionString.equalsIgnoreCase("nz")) {
				condition = PicoblazeAssemblerOpcodes.CONDITION_NZ;
			} else if (conditionString.equalsIgnoreCase("c")) {
				condition = PicoblazeAssemblerOpcodes.CONDITION_C;
			} else if (conditionString.equalsIgnoreCase("nc")) {
				condition = PicoblazeAssemblerOpcodes.CONDITION_NC;
			} else {
				throw new LineSyntaxException(conditionToken, "Invalid condition: " + conditionString, false);
			}
		} else {
			condition = PicoblazeAssemblerOpcodes.CONDITION_NONE;
		}

		final Range fullRange = (labelToken != null) ? new Range(location, labelToken) : (conditionToken != null) ? new Range(location, conditionToken) : location;
		final Range conditionRange = (conditionToken != null) ? conditionToken : location;
		final Range targetRange = (labelToken != null) ? labelToken : location;
		client.instructionJ(fullRange, conditionRange, targetRange, opcode, condition, labelString);
	}

}
