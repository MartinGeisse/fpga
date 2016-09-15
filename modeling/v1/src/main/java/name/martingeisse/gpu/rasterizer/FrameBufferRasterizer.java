/**
 * Copyright (c) 2015 Martin Geisse
 *
 * This file is distributed under the terms of the MIT license.
 */

package name.martingeisse.gpu.rasterizer;

/**
 * Draws primitives to a {@link FrameBuffer}.
 */
public class FrameBufferRasterizer implements Rasterizer {

	private final FrameBuffer frameBuffer;

	/**
	 * Constructor.
	 * @param frameBuffer the frame buffer to draw to
	 */
	public FrameBufferRasterizer(final FrameBuffer frameBuffer) {
		this.frameBuffer = frameBuffer;
	}

	// override
	@Override
	public void drawLine(int x1, int y1, int x2, int y2) {
		int dx = x2 - x1;
		int dy = y2 - y1;
		if (dx < 0) {
			drawLineNonnegativeDx(x2, y2, -dx, -dy);
		} else {
			drawLineNonnegativeDx(x1, y1, dx, dy);
		}
	}
	
	private void drawLineNonnegativeDx(int x1, int y1, int dx, int dy) {
		if (dy > dx || dy < -dx) {
			drawLineInternal(y1, x1, dy, dx, false);
		} else {
			drawLineInternal(x1, y1, dx, dy, true);
		}
	}
	
	/**
	 * Draws a line that is "more S than T", with (s1, t1) being the starting point
	 * of the line. The sx flag tells if "S" means "X" (true) or "Y" (false). The
	 * steps parameter gives the number of pixels along the S axis, which is abs(ds).
	 * The stepS is equal to the sign of ds.
	 */
	private void drawLineInternal(final int s1, final int t1, final int ds, final int dt, boolean sx) {

		// draw the starting pixel
		if (sx) {
			frameBuffer.setPixel(s1, t1, 0xff000000);
		} else {
			frameBuffer.setPixel(t1, s1, 0xff000000);
		}
		
		// the numerator for the fractional part of the T coordinate
		final int stepTNumerator = dt;
		final int stepTDenominator = Math.abs(ds);
		final int stepTThreshold = (stepTDenominator >> 1);
		int s = s1, t = t1, stepsRemaining = Math.abs(ds), dsSign = (ds < 0 ? -1 : 1);
		int accumulatedTNumerator = 0;
		while (stepsRemaining > 0) {
			s += dsSign;
			accumulatedTNumerator += stepTNumerator;
			if (accumulatedTNumerator > stepTThreshold) {
				accumulatedTNumerator -= stepTDenominator;
				t++;
			} else if (accumulatedTNumerator < -stepTThreshold) {
				accumulatedTNumerator += stepTDenominator;
				t--;
			}
			if (sx) {
				frameBuffer.setPixel(s, t, 0xff000000);
			} else {
				frameBuffer.setPixel(t, s, 0xff000000);
			}
			stepsRemaining--;
		}
		
	}
	
}
