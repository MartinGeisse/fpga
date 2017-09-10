package os.shell;

import os.kernel.JavaProcess;

/**
 *
 */
public class EchoProcess extends JavaProcess {

	@Override
	protected void run() {
		boolean first = true;
		for (String arg : getArgs()) {
			if (first) {
				first = false;
			} else {
				System.out.print(' ');
			}
			System.out.print(arg);
		}
		System.out.println();
	}

}
