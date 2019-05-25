package com.culturecloud.utils.ali;

import java.io.InputStream;
import java.net.URL;

import com.aliyun.oss.OSSClient;

/** 
 * 阿里图片上传
 * */
public class AliImageUtils {

	//private static String endpoint="http://oss-cn-hangzhou.aliyuncs.com";
	private static String endpoint="http://oss-cn-hangzhou.aliyuncs.com";
	private static String accessKeyId="g71YwJtSB2zq8EgJ";
	private static String accessKeySecret="9PJFP214P7vt5SjFWnxBNwPxkoqYJr";
	private static String bucket="culturecloud";
	
	
	/** 流图片上传
	 * @param imageUrl www.wenhuayun.cn/ssss/sss/s/ss.jpg
	 * @param imageName ss.jpg
	 * */
	public static String uploadByInputStream(String imageUrl,String imageName)
	{
		OSSClient ossClient = new OSSClient(endpoint, accessKeyId, accessKeySecret);
		try {
			InputStream inputStream = new URL(imageUrl).openStream();
			ossClient.putObject(bucket, "image/"+imageName, inputStream);
			ossClient.shutdown();
			return "http://culturecloud.img-cn-hangzhou.aliyuncs.com/image/"+imageName;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		    return null;
	}
	
	public static void main(String[] args)
	{
		//http://img1.wenhuayun.cn/front/1367177/201609/Img/Imgde3d651439594914bbda6918a8f81a49.JPG
		String url=uploadByInputStream("http://img1.wenhuayun.cn/front/1367177/201609/Img/Imgde3d651439594914bbda6918a8f81a49.JPG","Imgde3d651439594914bbda6918a8f81a49.JPG");
		System.out.println("url======"+url);
	}
	
}
