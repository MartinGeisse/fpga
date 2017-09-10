package os.kernel.resource;

/**
 *
 */
public final class FolderEntry {

	private final String name;
	private final Resource resource;

	public FolderEntry(String name, Resource resource) {
		this.name = name;
		this.resource = resource;
	}

	/**
	 * Getter method.
	 *
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * Getter method.
	 *
	 * @return the resource
	 */
	public Resource getResource() {
		return resource;
	}

}
