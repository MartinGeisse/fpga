package os.shell;

import org.apache.commons.lang3.StringUtils;
import os.kernel.JavaProcess;
import os.kernel.Process;
import os.kernel.resource.Folder;
import os.kernel.resource.FolderEntry;

import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Consumer;
import java.util.function.Supplier;

/**
 *
 */
public class ShellProcess extends JavaProcess {

	private final Map<String, Consumer<String[]>> commandHandlers = new HashMap<>();

	public ShellProcess() {
		commandHandlers.put("version", segments -> {
			System.out.println("OS version 0.0");
		});
		addCommand("echo", EchoProcess::new);
		commandHandlers.put("ls", segments -> {
			FolderEntry[] entries = getWorkingFolder().list();
			Arrays.sort(entries, (x, y) -> x.getName().compareTo(y.getName()));
			for (FolderEntry entry : entries) {
				System.out.println("- " + entry.getName());
			}
		});
		commandHandlers.put("cd", segments -> {
			Folder originalFolder = getWorkingFolder();
			String path = segments.length < 2 ? "/" : segments[1];
			String originalPath = path;
			if (path.startsWith("/")) {
				path = path.substring(1);
				setWorkingFolder(getContainerFolder());
			}
			for (String pathSegment : StringUtils.split(path, '/')) {
				FolderEntry entry = getWorkingFolder().getEntry(pathSegment);
				if (entry == null || !(entry.getResource() instanceof Folder)) {
					System.out.println("no such folder: " + originalPath);
					setWorkingFolder(originalFolder);
					return;
				}
				setWorkingFolder((Folder)entry.getResource());
			}
		});
		commandHandlers.put("pwd", segments -> {
			System.out.println(getPath(getWorkingFolder()));
		});
	}

	private String getPath(Folder folder) {
		Folder parent = (Folder) folder.getEntry("..").getResource();
		if (parent == folder) {
			return "/";
		}
		String parentPath = getPath(parent);
		if (!parentPath.equals("/")) {
			parentPath += '/';
		}
		for (FolderEntry parentEntry : parent.list()) {
			if (parentEntry.getResource() == folder) {
				return parentPath + parentEntry.getName();
			}
		}
		return parentPath + "(INCONSISTENT)";
	}

	private void addCommand(String name, Supplier<Process> processFactory) {
		commandHandlers.put(name, args -> {
			spawn(processFactory.get(), args);
		});
	}

	@Override
	protected void run() {
		try {
			LineNumberReader reader = new LineNumberReader(new InputStreamReader(System.in));
			while (true) {
				System.out.print("> ");
				String line = reader.readLine();
				if (line == null) {
					break;
				}
				line = line.trim();
				String[] segments = StringUtils.split(line, ' ');
				if (segments.length > 0) {
					String command = segments[0];
					Consumer<String[]> commandHandler = commandHandlers.get(command);
					if (commandHandler == null) {
						System.out.println("unknown command: " + command);
					} else {
						String[] args = new String[segments.length - 1];
						System.arraycopy(segments, 1, args, 0, args.length);
						commandHandler.accept(args);
					}
				}
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

}
