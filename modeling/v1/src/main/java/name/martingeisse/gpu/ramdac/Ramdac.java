/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.gpu.ramdac;

import name.martingeisse.gpu.rasterizer.FrameBuffer;

/**
 * Reads the contents of a {@link FrameBuffer} and displays it in some way.
 */
public interface Ramdac {

	/**
	 * Displays the current contents of the specified frame buffer.
	 * 
	 * This method does not establish a persistent connection to the
	 * frame buffer. After this method returns, the RAMDAC should not
	 * ask the frame buffer for contents until asked to display it
	 * again.
	 * 
	 * @param frameBuffer the frame buffer to read from
	 */
	public void display(FrameBuffer frameBuffer);
	
}
