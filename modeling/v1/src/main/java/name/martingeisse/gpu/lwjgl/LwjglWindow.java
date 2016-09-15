/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.gpu.lwjgl;

import org.lwjgl.input.Keyboard;
import org.lwjgl.opengl.Display;
import org.lwjgl.opengl.DisplayMode;
import org.lwjgl.opengl.GL11;
import org.lwjgl.opengl.PixelFormat;

/**
 * Uses LWJGL to open an OpenGL window.
 */
public final class LwjglWindow {

	/**
	 * Constructor.
	 * @param width the window width
	 * @param height the window height
	 */
	public LwjglWindow(int width, int height) {
		try {
			LwjglNativeLibraryHelper.prepareNativeLibraries();
			Display.setDisplayMode(new DisplayMode(width, height));
			Display.setTitle("GPU Simulator");
			Display.create(new PixelFormat(0, 24, 0));
			Keyboard.create();
		} catch (Exception e) {
			throw new RuntimeException("could not open LWJGL window", e);
		}
	}

	/**
	 * 
	 */
	public void waitForClose() {
		while (true) {
			Display.processMessages();
			Keyboard.poll();
			if (Display.isCloseRequested() || Keyboard.isKeyDown(Keyboard.KEY_ESCAPE)) {
				break;
			}
			try {
				Thread.sleep(50);
			} catch (InterruptedException e) {
				break;
			}
		}
		close();
		System.exit(0);
	}
	
	/**
	 * Closes the window.
	 */
	public void close() {
		Keyboard.destroy();
		Display.destroy();
	}

}
