package name.martingeisse.picoblaze.assembler;

import java.util.HashMap;
import java.util.Map;

/**
 * Temporary object used while the assembler is running. This contains things like the addresses for labels.
 */
public class AssemblerState {

	private final Map<String, Integer> labels = new HashMap<>();
	private int address = 0;

	public void setAddress(int address) {
		if (address < 0 || address >= 1024) {
			throw new IllegalArgumentException("invalid address: " + address);
		}
		this.address = address;
	}

	public void defineLabel(String name) {
		labels.put(name, address);
	}

	public void skippedInstruction() {
		if (address == 1023) {
			throw new RuntimeException("program size too large");
		}
		address++;
	}

	public int resolveLabel(String name) {
		Integer target = labels.get(name);
		if (target == null) {
			throw new IllegalArgumentException("unknown label: " + name);
		}
		return target;
	}

}
