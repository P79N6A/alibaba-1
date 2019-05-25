package com.culturecloud.utils;


import org.w3c.dom.Element;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageTypeSpecifier;
import javax.imageio.ImageWriter;
import javax.imageio.metadata.IIOMetadata;
import javax.imageio.plugins.jpeg.JPEGImageWriteParam;
import javax.imageio.stream.ImageOutputStream;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
public class UpdateImgUtils {

            private static String basePath = "/upload/sun3d/";

//    private static String basePath = "D://sun3d/";

    public static String uploadImage(String strUrl, String source, String type) throws Exception {
        String imageUrl = "";
        try {
            String imgSuffix = getImgSuffix(strUrl);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
            sdf.applyPattern("yyyyMM");
            StringBuffer fileUrl = new StringBuffer();
            fileUrl.append(source + "/Img");
            /*********** 位置请不要挪动 *************/
            String dirPath = fileUrl.toString();
            imageUrl = upload(strUrl, imgSuffix, dirPath, type);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return imageUrl;
    }

    public static String getImgSuffix(String filePath) {
        String fileName = filePath;
        int imgSuffix = fileName.lastIndexOf(".");
        return fileName.substring(imgSuffix);
    }

    public static String upload(String strUrl, String imgSuffix, String dirPath, String type) {
        String newImgName = "Img" + UUIDUtils.createUUId();
        String imagePath = basePath + dirPath;
        StringBuffer filePath = new StringBuffer();
        StringBuffer fullFilePath = new StringBuffer();
        StringBuffer uploadPath = new StringBuffer();
        filePath.append(basePath);
        filePath.append(dirPath);
        filePath.append(File.separator);
        fullFilePath.append(filePath.toString());
        fullFilePath.append(newImgName);
        fullFilePath.append(imgSuffix);
        uploadPath.append(dirPath);
        uploadPath.append("/");
        uploadPath.append(newImgName);
        uploadPath.append(imgSuffix);
        BufferedOutputStream stream = null;
        InputStream in = null;
        try {
            // 判断是否存在0*0文件夹，如果没有就创建
            File file = new File(filePath.toString());
            if (!file.exists()) {
                file.mkdirs();
            }
            stream = new BufferedOutputStream(new FileOutputStream(new File(fullFilePath.toString())));
            byte[] buf = new byte[1024];
            URL url = new URL(strUrl);
            URLConnection conn = url.openConnection();
            in = conn.getInputStream();
            int length = 0;
            while ((length = in.read(buf, 0, buf.length)) > 0) {
                stream.write(buf, 0, length);
            }
            stream.close();
            // 处理上传图片进行缩放,其他的格式不进行处理
            if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG")
                    || imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG")
                    || imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP")
                    || imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF")
                    || imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
                zoomFile(imagePath + "/" + newImgName, imgSuffix, type);
            }
        } catch (Exception e) {
            e.getStackTrace();
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        return uploadPath.toString();
    }

    public static void zoomFile(String imagePath, String imgSuffix, String type) throws IOException {
        // 拼接图片绝对路径
        String imageNewPath = imagePath + imgSuffix;
        InputStream is = new FileInputStream(imageNewPath);
        BufferedImage buff = ImageIO.read(is);
        int width = buff.getWidth();// 得到图片的宽度
        int height = buff.getHeight(); // 得到图片的高度
        switch (type){
            case ("1"):
                /*将图片进行300*300,750*500缩放；*/
                String fileNameSmall = imagePath + "_300_300" + imgSuffix;
                String fileNameBig = imagePath + "_750_500" + imgSuffix;
                // 根据宽度的比例进行修改高度
                float blSmall = (float) 300 / (float) width;
                float newSmallHeight = blSmall * (float) height;
                float blBig = (float) 750 / (float) width;
                float newBigHeight = blBig * (float) height;
                is.close();
                String imgPathSmall = resizeImage(buff, fileNameSmall, 300, newSmallHeight);
                String imgPathBig = resizeImage(buff, fileNameBig, 750, newBigHeight);
                break;
            case ("2"):

               break;

            default:
        }

    }

    public static String resizeImage(BufferedImage src, String toImagePath, int width, float height)
            throws IOException {
        FileOutputStream out = null;
        try {
            // 放大边长
            BufferedImage tag = new BufferedImage(width, (int) height, BufferedImage.TYPE_INT_RGB);
            // 绘制放大后的图片
            tag.getGraphics().drawImage(src, 0, 0, width, (int) height, null);
            out = new FileOutputStream(toImagePath);
            saveAsJPEG(100, tag, 1, out);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
        return toImagePath;
    }


    /**
     * 以JPEG编码保存图片
     * @param dpi  分辨率
     * @param image_to_save  要处理的图像图片
     * @param JPEGcompression  压缩比
     * @param fos 文件输出流
     * @throws IOException
     */
    public static void saveAsJPEG(Integer dpi ,BufferedImage image_to_save, float JPEGcompression, FileOutputStream fos) throws IOException {

        ImageWriter imageWriter  =   ImageIO.getImageWritersBySuffix("jpg").next();
        ImageOutputStream ios  =  ImageIO.createImageOutputStream(fos);
        imageWriter.setOutput(ios);
        IIOMetadata imageMetaData  =  imageWriter.getDefaultImageMetadata(new ImageTypeSpecifier(image_to_save), null);


        if(dpi !=  null && !dpi.equals("")){

            Element tree  =  (Element) imageMetaData.getAsTree("javax_imageio_jpeg_image_1.0");
            Element jfif  =  (Element)tree.getElementsByTagName("app0JFIF").item(0);
            jfif.setAttribute("Xdensity", Integer.toString(dpi) );
            jfif.setAttribute("Ydensity", Integer.toString(dpi));

        }


        if(JPEGcompression >= 0 && JPEGcompression <= 1f){

            JPEGImageWriteParam jpegParams  =  (JPEGImageWriteParam) imageWriter.getDefaultWriteParam();
            jpegParams.setCompressionMode(JPEGImageWriteParam.MODE_EXPLICIT);
            jpegParams.setCompressionQuality(JPEGcompression);

        }
        imageWriter.write(imageMetaData, new IIOImage(image_to_save, null, null), null);
        ios.close();
        imageWriter.dispose();

    }


    public static String checkImage(String strUrl) {
        InputStream in = null;
        try {
            String imgSuffix = getImgSuffix(strUrl);
            if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG")
                    || imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG")
                    || imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP")
                    || imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF")) {
                URL url = new URL(strUrl);
                URLConnection conn = url.openConnection();
                conn.setConnectTimeout(6 * 1000);
                int size = conn.getContentLength();
                System.out.println(size);
                if(size>0){
                    return "success";
                }else{
                    return "上传的图片路径有误，无法上传到系统中!";
                }
            } else {
                return "上传的不是图片，无法上传到系统中!";
            }

        } catch (Exception e) {

        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return "";
    }
}
