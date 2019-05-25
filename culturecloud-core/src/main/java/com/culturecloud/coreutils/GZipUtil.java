package com.culturecloud.coreutils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

// 将一个字符串按照gzip方式压缩和解压缩   
public class GZipUtil {

	/**
	 * gZip压缩方法
	 * */
	public static byte[] gZip(byte[] data) {
		byte[] b = null;
		try {
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			GZIPOutputStream gzip = new GZIPOutputStream(bos);
			gzip.write(data);
			gzip.finish();
			gzip.close();
			b = bos.toByteArray();
			bos.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return b;
	}

	/**
	 * gZip解压方法
	 * */
	public static byte[] unGZip(byte[] data) {
		byte[] b = null;
		try {
			ByteArrayInputStream bis = new ByteArrayInputStream(data);
			GZIPInputStream gzip = new GZIPInputStream(bis);
			byte[] buf = new byte[1024];
			int num = -1;
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			while ((num = gzip.read(buf, 0, buf.length)) != -1) {
				baos.write(buf, 0, num);
			}
			b = baos.toByteArray();
			baos.flush();
			baos.close();
			gzip.close();
			bis.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return b;
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {

		String parame = "com.culturecloud.service.rs.demo."
				+ "DemoResource.getDemo.{\"source\" : \"ios\"}";
		System.out.println("压缩前：" + parame);
		byte[] parames = gZip(parame.getBytes());

		System.out.println("压缩后:" + parames);
		System.out.println(parames.length);

		parames = unGZip(parames);

		System.out.println("解压后：" + new String(parames));

	}
}