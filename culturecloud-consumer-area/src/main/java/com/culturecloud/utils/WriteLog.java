/**
 * 
 */
package com.culturecloud.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

/**************************************
 * @Description：文本日志
 * @author Zhangchenxi
 * @since 2016年3月7日
 * @version 1.0
 **************************************/

public class WriteLog {

	
	@SuppressWarnings("unused")
	public static void writeLog(String year,
			String month, String date, String content) throws IOException {
		String s = new String();
		StringBuilder sb = new StringBuilder();
		StringBuilder path = new StringBuilder(PpsConfig.getString("logBasePath").toString());
		path.append(year).append("/").append(month);
		BufferedWriter output = null;
		BufferedReader input = null;
		File file = new File(path.toString());
		try {
			

			// 检测目录是否存在，若不存在，就创建。
			if (!file.exists() && !file.isDirectory()) {
				if (file.mkdirs())
					System.out.println("businessLog---  文件夹已创建完成！");
			}
			path.append("/").append(month).append("-").append(date).append(".log");
			file = new File(path.toString());
			int i=0;
			//20971520
			while(file.length()>=20971520)
			{
				String path1=path.substring(0,path.length()-4);
				file = new File(path1+"-"+i+".log");
				i++;
			}
			
			
			
			if (file.exists() && file.isFile()) {
				System.out.println("businessLog---  文件存在");
			} else {
				System.out.println("businessLog---  文件不存在，正在创建...");
				if (file.createNewFile()) {
					System.out.println("businessLog---  文件创建成功！");
				} else {
					System.out.println("businessLog---  文件创建失败！");
				}
			}

			input = new BufferedReader(new FileReader(file));

			while ((s = input.readLine()) != null) {
				sb.append(s).append("\n");
			}

			sb.append(content);
			output = new BufferedWriter(new FileWriter(file));
			output.write(sb.toString());

		} catch (Exception e) {
			System.out.println("businessLog---  " + e.getMessage());
		} finally {
			input.close();
			output.close();
		}
	}
}
