package com.sun3d.why.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Calendar;
import java.util.Date;

public class IOUtil {
	public static final int defaultBufSize = 1024;

	public static int write(InputStream in, OutputStream out) throws IOException {
		return write(in, out, 0);
	}

	public static int write(InputStream in, OutputStream out, int bufSize) throws IOException {
		int _bufSize = (bufSize != 0) ? bufSize : defaultBufSize;
		byte[] buffer = new byte[_bufSize];
		int len;
		while ((len = in.read(buffer)) != -1) {
			out.write(buffer, 0, len);
		}
		int fileSize=in.available();
		out.flush();
		out.close();
		in.close();
		return fileSize;
	}

	public static void close(InputStream input) {
		try {
			if (input != null)
				input.close();
		} catch (IOException ioe) {
		}
	}

	public static void close(OutputStream output) {
		try {
			if (output != null)
				output.close();
		} catch (IOException ioe) {
		}
	}
	
	public static String generatePath(String id, Date createTime) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(createTime);
		return "/" + cal.get(Calendar.YEAR) + "/"
				+ (cal.get(Calendar.MONTH) + 1) + "/" + id;
	}

}
