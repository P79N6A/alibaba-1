package com.sun3d.why.util;

import com.alibaba.fastjson.JSONObject;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import com.sun3d.why.model.extmodel.BasePath;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import javax.imageio.plugins.bmp.BMPImageWriteParam;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;

/**
 * Created by Administrator on 2015/7/6.
 */
public class UploadFile {

    /**
     * changeFileUrlSmall 小图片路径
     * changeFileUrlBig   大图片路径
     * 处理图片进行缩放
     */
   public static void zoomFile(MultipartFile mulFile, String imagePath,String imgSuffix,String type, String modelType) throws IOException {
        BufferedImage src = javax.imageio.ImageIO.read(mulFile
                .getInputStream());
       //拼接图片绝对路径
       String imageNewPath=imagePath+imgSuffix;
       InputStream is = new FileInputStream(imageNewPath);
       BufferedImage buff = ImageIO.read(is);
       int width = buff.getWidth();//得到图片的宽度
       int height = buff.getHeight();  //得到图片的高度
       //type 1代表切割广告图
       if(type!=null && Integer.valueOf(type)==1){
           String fileNameSmall = imagePath + "_750_520" + imgSuffix;
           String fileNameBig = imagePath + "_1200_530" + imgSuffix;
           //微网站图片尺寸
           String fileNameWeChart = imagePath + "_750_350" + imgSuffix;
           /*
            *
            * 将图片进行750*520,1200*530缩放；
            */
           //根据宽度的比例进行修改高度
           float blSmall = (float)750/(float)width;
           float newSmallHeight = (float)(blSmall*(float)height);
           float blBig = (float)1200/(float)width;
           float newBigHeight = (float)(blBig*(float)height);

           float blWeChart = (float)750/(float)width;
           float newWeChartHeight = (float)(blWeChart*(float)height);

           is.close();
           String imgPathSmall = resizeImage(src, fileNameSmall, 750, newSmallHeight);
           String imgPathBig = resizeImage(src, fileNameBig, 1200, newBigHeight);
           String imgPathWeChart = resizeImage(src, fileNameWeChart, 750, newWeChartHeight);
       }
       //2代表切割活动图
       else if(type!=null && Integer.valueOf(type)==2){
           String fileNameSmall = imagePath + "_300_300" + imgSuffix;

           String fileNameMiddle = imagePath + "_150_100" + imgSuffix;
           String fileNameBig = imagePath + "_750_500" + imgSuffix;

           String fileName150_150 = imagePath + "_150_150" + imgSuffix;

           /*
            *
            * 将图片进行300*300,750*500缩放；
            */
           //根据宽度的比例进行修改高度
           float blSmall = (float)300/(float)width;
           float newSmallHeight = (float)(blSmall*(float)height);

           float blBig = (float)750/(float)width;
           float newBigHeight = (float)(blBig*(float)height);


           float blMiddle = (float)150/(float)width;
           float newMiddleHeight = (float)(blMiddle*(float)height);

           float blMiddle_150_150 = (float)150/(float)width;
           float newMiddleHeight_150_150 = (float)(blMiddle_150_150*(float)height);


           is.close();
           String imgPathSmall = resizeImage(src, fileNameSmall, 300, newSmallHeight);
           String imgPathBig = resizeImage(src, fileNameBig, 750, newBigHeight);
           String imgPathMiddle = resizeImage(src, fileNameMiddle, 150, newMiddleHeight);
           String imgPathMiddle_150_150 = resizeImage(src, fileName150_150, 150, newMiddleHeight_150_150);

       }
       //3代表切割展馆图
       else if(type!=null && Integer.valueOf(type)==3){
           String fileNameSmall = imagePath + "_300_300" + imgSuffix;
           String fileNameBig = imagePath + "_750_500" + imgSuffix;
           String fileNameMiddle = imagePath + "_150_100" + imgSuffix;
           /*
            *
            * 将图片进行300*300,750*500缩放；
            */
           //根据宽度的比例进行修改高度
           float blSmall = (float)300/(float)width;
           float newSmallHeight = (float)(blSmall*(float)height);
           float blBig = (float)750/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           float blMiddle = (float)150/(float)width;
           float newMiddleHeight = (float)(blMiddle*(float)height);
           is.close();
           String imgPathSmall = resizeImage(src, fileNameSmall, 300, newSmallHeight);
           String imgPathBig = resizeImage(src, fileNameBig, 750, newBigHeight);
           String imgPathMiddle = resizeImage(src, fileNameMiddle, 150, newMiddleHeight);
       }
       //4代表切割团体图
       else if(type!=null && Integer.valueOf(type)==4){
           String fileNameSmall = imagePath + "_300_300" + imgSuffix;
           String fileNameBig = imagePath + "_750_500" + imgSuffix;
           /*
            *
            * 将图片进行300*300,750*500缩放；
            */
           //根据宽度的比例进行修改高度
           float blSmall = (float)300/(float)width;
           float newSmallHeight = (float)(blSmall*(float)height);
           float blBig = (float)750/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           is.close();
           String imgPathSmall = resizeImage(src, fileNameSmall, 300, newSmallHeight);
           String imgPathBig = resizeImage(src, fileNameBig, 750, newBigHeight);
       }
       //5代表切割活动室图片
       else if(type!=null && Integer.valueOf(type)==5){
           String fileNameSmall = imagePath + "_300_300" + imgSuffix;
           String fileNameBig = imagePath + "_750_500" + imgSuffix;
           /*
            *
            * 将图片进行300*300,750*500缩放；
            */
           //根据宽度的比例进行修改高度
           float blSmall = (float)300/(float)width;
           float newSmallHeight = (float)(blSmall*(float)height);
           float blBig = (float)750/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           is.close();
           String imgPathSmall = resizeImage(src, fileNameSmall, 300, newSmallHeight);
           String imgPathBig = resizeImage(src, fileNameBig, 750, newBigHeight);
       }
       //6代表切割藏品图片
       else if(type!=null && Integer.valueOf(type)==6){
           String fileNameSmall = imagePath + "_300_300" + imgSuffix;
           String fileNameBig = imagePath + "_750_500" + imgSuffix;
           /*
            *
            * 将图片进行300*300,750*500缩放；
            */
           //根据宽度的比例进行修改高度
           float blSmall = (float)300/(float)width;
           float newSmallHeight = (float)(blSmall*(float)height);
           float blBig = (float)750/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           is.close();
           String imgPathSmall = resizeImage(src, fileNameSmall, 300, newSmallHeight);
           String imgPathBig = resizeImage(src, fileNameBig, 750, newBigHeight);
       }
       //7代表切割app图片
       else if(type!=null && Integer.valueOf(type)==7){
           String smallWh = "";
           String bigWh = "";
            if(Integer.parseInt(modelType) == 2){
               bigWh = "_150_150";
               smallWh = "_72_72";
           }else if(Integer.parseInt(modelType) == 3){
                smallWh = "_150_100";
                bigWh = "_150_150";
           }
           String fileNameSmall = imagePath + smallWh + imgSuffix;
           String fileNameBig = imagePath + bigWh + imgSuffix;
           String fileName300 = imagePath + "_300_300" + imgSuffix;
           //根据宽度的比例进行修改高度
           float blSmall = (float)150/(float)width;
           float newSmallHeight = (float)(blSmall*(float)height);
           float blBig = (float)150/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           float bl300 = (float)300/(float)width;
           float new300Height = (float)(bl300*(float)height);
//           float blSmall = Float.valueOf(smallWh.split("_")[1])/(float)width;
//           float newSmallHeight = (float)(blSmall*(float)height);
//           float blBig = Float.parseFloat(bigWh.split("_")[1])/(float)width;
//           float newBigHeight = (float)(blBig*(float)height);
           is.close();
           String imgPathSmall = resizeImage(src, fileNameSmall, Integer.valueOf(smallWh.split("_")[1]),  newSmallHeight);
           String imgPathBig = resizeImage(src, fileNameBig, Integer.valueOf(bigWh.split("_")[1]),  newBigHeight);
           String imgPath300 = resizeImage(src, fileName300, 300, new300Height);

           /*
            *
            * 将图片进行300*300,750*500缩放；
            */
           //根据宽度的比例进行修改高度
           is.close();
       }
       //8代表切割会员图片
       else if(type!=null && Integer.valueOf(type)==8){
           String fileNameSmall = imagePath + "_300_300" + imgSuffix;
           String fileNameBig = imagePath + "_750_500" + imgSuffix;
           /*
            *
            * 将图片进行300*300,750*500缩放；
            */
           //根据宽度的比例进行修改高度
           float blSmall = (float)300/(float)width;
           float newSmallHeight = (float)(blSmall*(float)height);
           float blBig = (float)750/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           is.close();
           String imgPathSmall = resizeImage(src, fileNameSmall, 300, newSmallHeight);
           String imgPathBig = resizeImage(src, fileNameBig, 750, newBigHeight);
       }
       //9代表ckeditor插件里的上传图片
       else if(type!=null && Integer.valueOf(type)==9){
           String fileNameBig = imagePath + "_750_500" + imgSuffix;
           /*
            *
            * 将图片进行300*300,750*500缩放；
            */
           float blBig = (float)750/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           is.close();
           String imgPathBig = resizeImage(src, fileNameBig, 750, newBigHeight);
       }
       //10代表切割头像
       else if(type!=null && Integer.valueOf(type)==10){
           String smallWh = "";
           String bigWh = "";
           bigWh = "_150_150";
           smallWh = "_72_72";

           String fileNameSmall = imagePath + smallWh + imgSuffix;
           String fileNameBig = imagePath + bigWh + imgSuffix;

           is.close();
           String imgPathSmall = resizeImage(src, fileNameSmall, Integer.valueOf(smallWh.split("_")[1]),  Integer.valueOf(smallWh.split("_")[2]));
           String imgPathBig = resizeImage(src, fileNameBig, Integer.valueOf(bigWh.split("_")[1]),  Integer.valueOf(bigWh.split("_")[2]));

           String fileNameMiddle = imagePath + "_150_100" + imgSuffix;
           float blMiddle = (float)150/(float)width;
           float newMiddleHeight = (float)(blMiddle*(float)height);
           String imgPathMiddle = resizeImage(src, fileNameMiddle, 150, newMiddleHeight);
           /*
            *
            * 将图片进行300*300,750*500缩放；
            */
           //根据宽度的比例进行修改高度
           fileNameSmall = imagePath + "_300_300" + imgSuffix;
           fileNameBig = imagePath + "_750_500" + imgSuffix;
           float blSmall = (float)300/(float)width;
           float newSmallHeight = (float)(blSmall*(float)height);
           float blBig = (float)750/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           is.close();
            imgPathSmall = resizeImage(src, fileNameSmall, 300, newSmallHeight);
            imgPathBig = resizeImage(src, fileNameBig, 750, newBigHeight);
       } //11代表切割广告位小图
       else if(type!=null && Integer.valueOf(type)==11){
           String fileNameBig = imagePath + "_750_250" + imgSuffix;
           //根据宽度的比例进行修改高度
           float blBig = (float)750/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           is.close();
           String imgPathBig = resizeImage(src, fileNameBig, 750, newBigHeight);
       }//12代表切割广告位大图
       else if(type!=null && Integer.valueOf(type)==11){
           String fileNameBig = imagePath + "_374_155" + imgSuffix;
           //根据宽度的比例进行修改高度
           float blBig = (float)374/(float)width;
           float newBigHeight = (float)(blBig*(float)height);
           is.close();
           String imgPathBig = resizeImage(src, fileNameBig, 374, newBigHeight);
       }


   }

    /**
     * 上传文件
     *
     * @param multipartFile
     * @param newImgName
     * @param imgSuffix
     * @param basePath
     * @throws java.io.IOException
     */
    public static void  uploadFile(MultipartFile multipartFile, String newImgName, String imgSuffix, String dirPath, BasePath basePath)
            throws IOException {
        StringBuffer filePath = new StringBuffer();
        StringBuffer fullFilePath = new StringBuffer();
        filePath.append(basePath.getBasePath());
        filePath.append(dirPath);
        filePath.append(File.separator);
        fullFilePath.append(filePath.toString());
        fullFilePath.append(newImgName);
        fullFilePath.append(imgSuffix);
        BufferedOutputStream stream = null;
        byte[] b;
        try {
            //判断是否存在0*0文件夹，如果没有就创建
            File file = new File(filePath.toString());
            if (!file.exists()) {
                file.mkdirs();
            }
            b = multipartFile.getBytes();
            stream = new BufferedOutputStream(new FileOutputStream(new File(fullFilePath.toString())));
            stream.write(b);
            stream.close();
        } catch (Exception e) {
            e.getStackTrace();
        }
    }

    /**
     * 重置图形的边长大小
     *
     * @param src
     * @param toImagePath 目标路径
     * @param width
     * @param height
     * @throws IOException
     */
    public static  String resizeImage(BufferedImage src, String toImagePath, int width,
                              float height) throws IOException {
        FileOutputStream out = null;
        try {
            //使用默认的图像缩放算法
            Image image = src.getScaledInstance(width, (int)height,
                    Image.SCALE_DEFAULT);
            // 放大边长
            BufferedImage tag = new BufferedImage(width, (int) height,
                    BufferedImage.TYPE_INT_RGB);
            // 绘制放大后的图片
            tag.getGraphics().drawImage(image, 0, 0, null);
            out = new FileOutputStream(toImagePath);
            JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
            JPEGEncodeParam param = encoder.getDefaultJPEGEncodeParam(tag);
            param.setQuality(0.5f, true);
            encoder.encode(tag,param);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
        return toImagePath;
    }
    /*
   * 处理文件的命名和后缀
   */
    public static String getImgSuffix(MultipartFile mulPhoto) {
        String fileName = mulPhoto.getOriginalFilename();
        int imgSuffix = fileName.lastIndexOf(".");
        return fileName.substring(imgSuffix);
    }
    /*
    *  @封装json数据
    */
    public static String toResultFormat(int code, String data) {
        JSONObject json = new JSONObject();
        json.put("status", code);
        json.put("data", data);
        return json.toString();
    }
}
