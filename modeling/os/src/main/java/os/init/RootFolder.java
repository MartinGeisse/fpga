package os.init;

import os.kernel.resource.FixedVirtualFolder;
import os.kernel.resource.Folder;
import os.kernel.resource.FolderEntry;

/**
 *
 */
public class RootFolder extends FixedVirtualFolder {

	public RootFolder() {
		super(null);
		addEntry(new FolderEntry("devices", new DevicesFolder(this)));
		addEntry(new FolderEntry("storage", new FixedVirtualFolder(this)));
		addEntry(new FolderEntry("volumes", new FixedVirtualFolder(this)));
		addEntry(new FolderEntry("services", new FixedVirtualFolder(this)));
	}

}
