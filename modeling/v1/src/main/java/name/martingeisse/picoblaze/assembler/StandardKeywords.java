package name.martingeisse.picoblaze.assembler;

import name.martingeisse.picoblaze.instruction.*;

/**
 * Defines the standard assembler keywords.
 */
public abstract class StandardKeywords {

	private final AssemblerState state;

	public StandardKeywords(AssemblerState state) {
		this.state = state;
	}

	public void label(String name) {
		state.defineLabel(name);
	}

	public void address(int address) {
		state.setAddress(address);
	}

	public abstract void instruction(Instruction instruction);

	public void load(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_LOAD));
	}

	public void load(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_LOAD));
	}

	public void add(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_ADD));
	}

	public void add(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_ADD));
	}

	public void addcy(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_ADDCY));
	}

	public void addcy(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_ADDCY));
	}

	public void sub(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_SUB));
	}

	public void sub(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_SUB));
	}

	public void subcy(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_SUBCY));
	}

	public void subcy(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_SUBCY));
	}

	public void and(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_AND));
	}

	public void and(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_AND));
	}

	public void or(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_OR));
	}

	public void or(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_OR));
	}

	public void xor(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_XOR));
	}

	public void xor(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_XOR));
	}

	public void compare(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_COMPARE));
	}

	public void compare(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_COMPARE));
	}

	public void test(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_TEST));
	}

	public void test(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_TEST));
	}

	public void input(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_INPUT));
	}

	public void input(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_INPUT));
	}

	public void output(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_OUTPUT));
	}

	public void output(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_OUTPUT));
	}

	public void store(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_STORE));
	}

	public void store(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_STORE));
	}

	public void fetch(RegisterId x, RegisterId y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_FETCH));
	}

	public void fetch(RegisterId x, int y) {
		instruction(new InstructionRX_(PicoblazeAssemblerOpcodes.OPCODE_FETCH));
	}

	public void rl(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_RL));
	}

	public void rr(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_RR));
	}

	public void sl0(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_SL0));
	}

	public void sl1(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_SL1));
	}

	public void sla(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_SLA));
	}

	public void slx(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_SLX));
	}

	public void sr0(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_SR0));
	}

	public void sr1(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_SR1));
	}

	public void sra(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_SRA));
	}

	public void srx(RegisterId x) {
		instruction(new InstructionR_(PicoblazeAssemblerOpcodes.OPCODE_SRX));
	}

	public void jump(String target) {
		instruction(new InstructionJ_(PicoblazeAssemblerOpcodes.OPCODE_JUMP));
	}

	public void jump(PicoblazeJumpCondition condition, String target) {
		instruction(new InstructionJ_(PicoblazeAssemblerOpcodes.OPCODE_JUMP));
	}

	public void call(String target) {
		instruction(new InstructionJ_(PicoblazeAssemblerOpcodes.OPCODE_CALL));
	}

	public void call(PicoblazeJumpCondition condition, String target) {
		instruction(new InstructionJ_(PicoblazeAssemblerOpcodes.OPCODE_CALL));
	}

	public void getRet() {
		instruction(new InstructionJ_(PicoblazeAssemblerOpcodes.OPCODE_RETURN));
	}

	public void ret(PicoblazeJumpCondition condition) {
		instruction(new InstructionJ_(PicoblazeAssemblerOpcodes.OPCODE_RETURN));
	}

	public void disableInterrupts() {
		instruction(new InstructionN_(PicoblazeAssemblerOpcodes.OPCODE_DISABLE_INTERRUPT));
	}

	public void enableInterrupts(RegisterId x) {
		instruction(new InstructionN_(PicoblazeAssemblerOpcodes.OPCODE_ENABLE_INTERRUPT));
	}

	public void returniDisable() {
		instruction(new InstructionN_(PicoblazeAssemblerOpcodes.OPCODE_RETURNI_DISABLE));
	}

	public void returniEnable() {
		instruction(new InstructionN_(PicoblazeAssemblerOpcodes.OPCODE_RETURNI_ENABLE));
	}

}
