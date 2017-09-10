package os.kernel;

import os.kernel.resource.Folder;

/**
 *
 */
public abstract class JavaProcess implements Process {

	private final Thread thread;
	private boolean started = false;
	private Folder containerFolder;
	private Folder workingFolder;
	private String[] args;

	public JavaProcess() {
		this.thread = new Thread(this::run);
	}

	@Override
	public final void start(Folder containerFolder, Folder workingFolder, String[] args) {
		if (started) {
			throw new IllegalStateException("process already started");
		}
		if (containerFolder == null) {
			throw new IllegalArgumentException("containerFolder cannot be null");
		}
		if (workingFolder == null) {
			throw new IllegalArgumentException("workingFolder cannot be null");
		}
		if (args == null) {
			throw new IllegalArgumentException("args cannot be null");
		}
		this.containerFolder = containerFolder;
		this.workingFolder = workingFolder;
		this.args = args;
		thread.start();
	}

	/**
	 * Getter method.
	 *
	 * @return the containerFolder
	 */
	public Folder getContainerFolder() {
		return containerFolder;
	}

	/**
	 * Getter method.
	 *
	 * @return the workingFolder
	 */
	protected final Folder getWorkingFolder() {
		return workingFolder;
	}

	/**
	 * Setter method.
	 *
	 * @param workingFolder the workingFolder
	 */
	protected final void setWorkingFolder(Folder workingFolder) {
		if (workingFolder == null) {
			throw new IllegalArgumentException("workingFolder cannot be null");
		}
		this.workingFolder = workingFolder;
	}

	/**
	 * Getter method.
	 *
	 * @return the args
	 */
	protected final String[] getArgs() {
		return args;
	}

	protected abstract void run();

	protected final void spawn(Process process, String... args) {
		process.start(containerFolder, workingFolder, args);
	}

}
