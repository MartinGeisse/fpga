/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.gpu.rasterizer;


/**
 * This object is responsible for drawing graphics primitives.
 */
public interface Rasterizer {

	/**
	 * Draws a line using the current drawing parameters.
	 * 
	 * @param x1 the x coordinate of the first line endpoint
	 * @param y1 the y coordinate of the first line endpoint
	 * @param x2 the x coordinate of the second line endpoint
	 * @param y2 the y coordinate of the second line endpoint
	 */
	public void drawLine(int x1, int y1, int x2, int y2);
	
}
