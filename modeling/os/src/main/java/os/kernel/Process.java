package os.kernel;

import os.kernel.resource.Folder;

/**
 *
 */
public interface Process {

	public void start(Folder containerFolder, Folder workingFolder, String[] args);

}
