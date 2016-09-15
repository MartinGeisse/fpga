/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.gpu.ramdac;

import org.lwjgl.opengl.Display;
import org.lwjgl.opengl.GL11;
import name.martingeisse.gpu.lwjgl.LwjglWindow;
import name.martingeisse.gpu.rasterizer.FrameBuffer;

/**
 * A RAMDAC implementation that uses LWJGL to display the frame buffer.
 */
public final class LwjglRamdac implements Ramdac {

	@SuppressWarnings("unused")
	private final LwjglWindow window;
	private final boolean showGrid;

	/**
	 * Constructor.
	 * @param window the LWJGL window
	 */
	public LwjglRamdac(final LwjglWindow window) {
		this(window, false);
	}

	/**
	 * Constructor.
	 * @param window the LWJGL window
	 * @param showGrid whether to draw a pixel grid
	 */
	public LwjglRamdac(final LwjglWindow window, final boolean showGrid) {
		this.window = window;
		this.showGrid = showGrid;
	}

	// override
	@Override
	public void display(final FrameBuffer frameBuffer) {
		GL11.glMatrixMode(GL11.GL_PROJECTION);
		GL11.glLoadIdentity();
		GL11.glOrtho(0, frameBuffer.getWidth(), frameBuffer.getHeight(), 0, -1, 1);
		GL11.glMatrixMode(GL11.GL_MODELVIEW);
		GL11.glLoadIdentity();
		for (int x = 0; x < frameBuffer.getWidth(); x++) {
			for (int y = 0; y < frameBuffer.getHeight(); y++) {
				final int rgba = frameBuffer.getPixel(x, y);
				GL11.glColor3ub((byte)(rgba >> 24), (byte)(rgba >> 16), (byte)(rgba >> 8));
				GL11.glBegin(GL11.GL_QUADS);
				GL11.glVertex2i(x, y);
				GL11.glVertex2i(x, y + 1);
				GL11.glVertex2i(x + 1, y + 1);
				GL11.glVertex2i(x + 1, y);
				GL11.glEnd();
			}
		}
		if (showGrid) {
			GL11.glColor3ub((byte)64, (byte)64, (byte)64);
			GL11.glBegin(GL11.GL_LINES);
			for (int x = 1; x < frameBuffer.getWidth(); x++) {
				GL11.glVertex2i(x, 0);
				GL11.glVertex2i(x, frameBuffer.getHeight());
			}
			for (int y = 1; y < frameBuffer.getHeight(); y++) {
				GL11.glVertex2i(0, y);
				GL11.glVertex2i(frameBuffer.getWidth(), y);
			}
			GL11.glEnd();
		}
		try {
			Display.swapBuffers();
		} catch (final Exception e) {
			throw new RuntimeException("could not swap LWJGL buffers", e);
		}
	}

}
