package os.init;

import os.kernel.JavaProcess;
import os.shell.ShellProcess;

/**
 *
 */
public class InitProcess extends JavaProcess {

	@Override
	protected void run() {
		System.out.println("--- starting OS ---");
		spawn(new ShellProcess());
		System.out.println("--- OS shutdown finished---");
	}

}
