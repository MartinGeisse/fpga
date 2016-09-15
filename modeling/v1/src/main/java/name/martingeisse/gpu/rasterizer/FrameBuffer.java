/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.gpu.rasterizer;


/**
 *
 */
public interface FrameBuffer {

	/**
	 * @return the frame buffer width
	 */
	public int getWidth();
	
	/**
	 * @return the frame buffer height
	 */
	public int getHeight();

	/**
	 * @param rgba the color, RGBA-encoded. The R component is in the highest-order byte.
	 */
	public void fill(int rgba);
	
	/**
	 * @param x the x position (0 being the left screen boundary)
	 * @param y the y position (0 being the top screen boundary)
	 * @return the color, RGBA-encoded. The R component is in the highest-order byte.
	 */
	public int getPixel(int x, int y);

	/**
	 * @param x the x position (0 being the left screen boundary)
	 * @param y the y position (0 being the top screen boundary)
	 * @param rgba the color, RGBA-encoded. The R component is in the highest-order byte.
	 */
	public void setPixel(int x, int y, int rgba);
	
}
