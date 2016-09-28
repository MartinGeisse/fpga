package os.init;

import os.kernel.resource.FixedVirtualFolder;
import os.kernel.resource.Folder;
import os.kernel.resource.FolderEntry;

/**
 *
 */
public class DevicesFolder extends FixedVirtualFolder {

	public DevicesFolder(Folder parent) {
		super(parent);
		addEntry(new FolderEntry("null", new FixedVirtualFolder(this)));
		addEntry(new FolderEntry("random", new FixedVirtualFolder(this)));
	}

}
