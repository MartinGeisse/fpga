/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.gpu;

import name.martingeisse.gpu.lwjgl.LwjglWindow;
import name.martingeisse.gpu.ramdac.LwjglRamdac;
import name.martingeisse.gpu.rasterizer.FrameBufferRasterizer;
import name.martingeisse.gpu.rasterizer.Rasterizer;
import name.martingeisse.gpu.rasterizer.SimpleFrameBuffer;

/**
 *
 */
public class Main {

	/**
	 * The main method.
	 * @param args command-line arguments
	 * @throws Exception ...
	 */
	public static void main(String[] args) throws Exception {
		LwjglWindow window = new LwjglWindow(640, 640);
		LwjglRamdac ramdac = new LwjglRamdac(window, true);
		SimpleFrameBuffer frameBuffer = new SimpleFrameBuffer(64, 64);
		Rasterizer rasterizer = new FrameBufferRasterizer(frameBuffer);
		
		double a = 0;
		while (true) {
			window.maintenance();
			frameBuffer.fill(0);
			double dx1 = Math.cos(a);
			double dy1 = Math.sin(a);
			int dx2 = (int)(dx1 * 20);
			int dy2 = (int)(dy1 * 20);
			rasterizer.drawLine(30, 30, 30 + dx2, 30 + dy2);
			ramdac.display(frameBuffer);
			a += 0.05;
			Thread.sleep(10);
		}
		
		// frameBuffer.setPixel(2, 1, 0xff000000);
		// window.waitForClose();
	}

}
