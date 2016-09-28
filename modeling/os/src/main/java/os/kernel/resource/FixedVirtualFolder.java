package os.kernel.resource;

import com.google.common.collect.ImmutableMap;

import java.util.HashMap;
import java.util.Map;

/**
 *
 */
public class FixedVirtualFolder implements Folder {

	private final Map<String, FolderEntry> entries = new HashMap<>();

	public FixedVirtualFolder(Folder parent) {
		addEntry(new FolderEntry(".", this));
		addEntry(new FolderEntry("..", parent == null ? this : parent));
	}

	protected final void addEntry(FolderEntry entry) {
		entries.put(entry.getName(), entry);
	}

	/**
	 * Getter method.
	 *
	 * @return the entries
	 */
	public final ImmutableMap<String, FolderEntry> getEntries() {
		return ImmutableMap.copyOf(entries);
	}

	@Override
	public final FolderEntry[] list() {
		return entries.values().toArray(new FolderEntry[0]);
	}

	@Override
	public final FolderEntry getEntry(String name) {
		return entries.get(name);
	}

}
