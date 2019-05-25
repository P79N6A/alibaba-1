package com.sun3d.why.util;

import com.sun3d.why.model.extmodel.BasePath;
import org.apache.commons.lang3.StringUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import sun.misc.BASE64Encoder;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;

/**
 * Created by liyang on 2015/5/21.
 */
public class GetImgUrl {


    // 得到图片
    public static String getFile(String purl,String pWidth,String pHeight) throws Exception {

        ApplicationContext appContext = new ClassPathXmlApplicationContext("classpath:spring.xml");
        BasePath basePathWindow = (BasePath) appContext.getBean("basePath");

        String info = "";
        // 当前图片相对路径
        String filenametem = purl;

        // 图片的长 宽
        int width = 0;
        String wid = pWidth;
        if (StringUtils.isNotBlank(wid)) {
            width = Integer.valueOf(wid);
        }
        int height = 0;
        String heigh = pHeight;
        if (StringUtils.isNotBlank(heigh)){
            height = Integer.valueOf(heigh);
        }
        if (filenametem==null || filenametem.equals("")){
            String ss = "";

            return ss;
        } else {
            String filenametemp = filenametem.trim();
            // 得到路径数组,将路径进行切割
            String[] fileName = filenametemp.split("/");
            String imga = null;
            String imgb = null;
            String imgc = null;
            String[] filename2 = null;
            StringBuffer url=new StringBuffer();
            // 处理传过来的路径
            imga = fileName[fileName.length - 2];
            if (!imga.equals("Img") && !imga.equals("Video") && !imga.equals("Audio")) {
                info="文件名称错误!";
                return info;
            }
            imgc = fileName[fileName.length - 1];
            // a = fileName[fileName.length - 1];
            filename2 = imgc.split("\\.");
            if(!filename2[1].equalsIgnoreCase("jpg")&&!filename2[1].equalsIgnoreCase("png")&&!filename2[1].equalsIgnoreCase("BMP")&&!filename2[1].equalsIgnoreCase("TIFF")&&!filename2[1].equalsIgnoreCase("GIF")&&!filename2[1].equalsIgnoreCase("JPEG")
                    && filename2[1].equalsIgnoreCase("mp3") && filename2[1].equalsIgnoreCase("avi")){
                info="文件格式错误!";
                return info;
            }
            if(width != 0 && height != 0){
                if (imga.equals("Img")) {
                    url.append(basePathWindow.getBaseUrl());
                    url.append(purl);
                    // 图片属性
                    String filename = filename2[1];
						/*
						 *
						 * @将file转换成image类型
						 */
                    try{

                        InputStream is = new FileInputStream(url.toString());
                        int size=is.available();
                        if(size!=0){
                            BufferedImage bi = ImageIO.read(is);
                            Image src = bi;
                            String ss = resizeImage(src, width, height, filename);
                            return ss;
                        }
                    }
                    catch(Exception e){
                        String ss = "";



                        return ss;
                    }
                }
            }
            else {
                if (imga.equals("Img")) {
						/*url.append(Constant.BASE_PATH);
						url.append("Img");
						url.append(File.separator);*/
                    url.append(basePathWindow.getBaseUrl());
                    url.append(purl);

                    File file = new File(url.toString());
                    if (!file.exists()) {
                        String ss = "";

                        return ss;
                    }
                    String ss = getImageBinary1(url.toString());
                    //String Temp = toResultFormat(0, ss);
                    return ss;
                }
            }
        }
        return null;
    }

    /**
     * 重置图形的边长大小(操作图片路径)
     *
     * @param src
     * @param width
     * @param height
     * @param filename
     * @throws java.io.IOException
     */
    public static String resizeImage(Image src, int width, int height, String filename)
            throws IOException {
        FileOutputStream out = null;
        try {
            // 放大边长
            BufferedImage tag = new BufferedImage(width, height,
                    BufferedImage.TYPE_INT_RGB);
            // 绘制放大后的图片
            //	tag.getGraphics().drawImage(src, 0, 0, width, height, null);
            tag.getGraphics().drawImage(src.getScaledInstance(width, height, java.awt.Image.SCALE_SMOOTH), 0, 0, null);
            String ss = getImageBinary(tag, filename);
            return ss;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    /*
 *
 * @将图片进行base64输出URL
 */
    public static String getImageBinary(BufferedImage bi, String format) {
        // InputStream in = null;
        // byte[] buf = new byte[1024];
        byte[] data = null;
        // 读取图片字节数组
        try {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            ImageIO.write(bi, format, out);
            data = out.toByteArray();
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 对字节数组Base64编码
        BASE64Encoder encoder = new BASE64Encoder();
        return encoder.encode(data);

    }

    /*
	 *
	 * @将图片进行base64输出URL
	 */
    public static String getImageBinary1(String url) {
        InputStream in = null;
        byte[] data = null;
        // 读取图片字节数组
        try {
            in = new FileInputStream(url);
            data = new byte[in.available()];
            in.read(data);
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 对字节数组Base64编码
        BASE64Encoder encoder = new BASE64Encoder();
        return encoder.encode(data);
    }



    /**
     * 缩放图像（按比例缩放）
     * @param srcImageFile 源图像文件地址
     * @param result 缩放后的图像地址
     * @param scale 缩放比例
     * @param flag 缩放选择:true 放大; false 缩小;
     */
    public static boolean scaleFile(Image src, int width, int height, int scale, boolean flag) {
        FileOutputStream out = null;
        try {
            if (flag) {// 放大
                width = width * scale;
                height = height * scale;
            } else {// 缩小
                width = width / scale;
                height = height / scale;
            }
            // 放大或缩小边长
            BufferedImage tag = new BufferedImage(width, height,
                    BufferedImage.TYPE_INT_RGB);
            // 绘制放大后的图片
            //	tag.getGraphics().drawImage(src, 0, 0, width, height, null);
            tag.getGraphics().drawImage(src.getScaledInstance(width, height, java.awt.Image.SCALE_SMOOTH), 0, 0, null);
           // String ss = getImageBinary(tag, filename);
            // ImageIO.write(tag, "JPEG", new File(result));// 输出到文件流
            return true;
        } catch (Exception e) {
            return  false;
        }
    }
}
