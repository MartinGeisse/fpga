package os.kernel.resource;

/**
 *
 */
public interface Folder extends Resource {

	public FolderEntry[] list();

	public FolderEntry getEntry(String name);

}
