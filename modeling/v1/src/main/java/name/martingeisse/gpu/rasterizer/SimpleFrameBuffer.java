/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.gpu.rasterizer;

import java.util.Arrays;

/**
 * Simple {@link FrameBuffer} implementation as a separate object.
 */
public final class SimpleFrameBuffer implements FrameBuffer {

	private final int width;
	private final int height;
	private final int[] buffer;

	/**
	 * Constructor.
	 * @param width the width in pixels
	 * @param height the height in pixels
	 */
	public SimpleFrameBuffer(final int width, final int height) {
		this.width = width;
		this.height = height;
		this.buffer = new int[width * height];
	}

	// override
	@Override
	public int getWidth() {
		return width;
	}

	// override
	@Override
	public int getHeight() {
		return height;
	}

	// override
	@Override
	public void fill(final int rgba) {
		Arrays.fill(buffer, rgba);
	}

	// override
	@Override
	public int getPixel(final int x, final int y) {
		return buffer[getIndex(x, y)];
	}

	// override
	@Override
	public void setPixel(final int x, final int y, final int rgba) {
		buffer[getIndex(x, y)] = rgba;
	}

	private int getIndex(final int x, final int y) {
		if (x < 0 || x >= width || y < 0 || y >= height) {
			throw new IndexOutOfBoundsException("invalid position: " + x + ", " + y);
		}
		return y * width + x;
	}

}
