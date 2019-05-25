package com.sun3d.why.util;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Created by chenjie on 2016/3/7.
 */
public class CutImageNew {

    /**
     * 压缩图片大小
     *
     * @return boolean
     */
    public boolean compressImage(ZIPImage zipImage) {
        boolean flag = false;
        try {
            if (zipImage.getInPutFilePath().trim().equals("")) {
                throw new NullPointerException("源文件夹路径不存在。");
            }
            if (zipImage.getInPutFileName().trim().equals("")) {
                throw new NullPointerException("图片文件路径不存在。");
            }
           /* if (zipImage.getOutPutFilePath().trim().equals("")) {
                throw new NullPointerException("目标文件夹路径地址为空。");
            } else {
                if (!mddir(zipImage.getOutPutFilePath())) {
                    throw new FileNotFoundException(zipImage.getOutPutFilePath() + " 文件夹创建失败！");
                }
            }*/

            if (zipImage.isAutoBuildFileName()) { // 自动生成文件名
                String tempFile[] = getFileNameAndExtName(zipImage.getInPutFileName());
                zipImage.setOutPutFilePath(zipImage.getInPutFilePath());
                zipImage.setOutPutFileName(tempFile[0] + "_" + zipImage.getOutPutFileWidth() + "_" + zipImage.getOutPutFileHeight() + "_" + "." + tempFile[1]);
                compressPic(zipImage);
            } else {
                if (zipImage.getOutPutFileName().trim().equals("")) {
                    throw new NullPointerException("目标文件名为空。");
                }
                compressPic(zipImage);
            }
        } catch (Exception e) {
            flag = false;
            e.printStackTrace();
            return flag;
        }
        return flag;
    }

    // 图片处理
    private void compressPic(ZIPImage zipImage) throws Exception {
        try {
            // 获得源文件
            File file = new File(zipImage.getInPutFilePath() + zipImage.getInPutFileName());
            if (!file.exists()) {
                throw new FileNotFoundException(zipImage.getInPutFilePath() + zipImage.getInPutFileName() + " 文件不存在！");
            }
            Image img = ImageIO.read(file);
            // 判断图片格式是否正确
            if (img.getWidth(null) == -1) {
                throw new Exception("文件不可读！");
            } else {
                int newWidth;
                int newHeight;

                // 判断是否是等比缩放
                if (zipImage.isScaleZoom()) {
                    // 为等比缩放计算输出的图片宽度及高度
                    double rate1 = ((double) img.getWidth(null))
                            / (double) zipImage.getOutPutFileWidth() + 0.1;
                    double rate2 = ((double) img.getHeight(null))
                            / (double) zipImage.getOutPutFileHeight() + 0.1;

                    // 根据缩放比率大的进行缩放控制
                    double rate = rate1 > rate2 ? rate1 : rate2;

                    newWidth = (int) (((double) img.getWidth(null)) / rate);
                    newHeight = (int) (((double) img.getHeight(null)) / rate);

                } else {
                    newWidth = zipImage.getOutPutFileWidth(); // 输出的图片宽度
                    newHeight = zipImage.getOutPutFileHeight(); // 输出的图片高度
                }

                BufferedImage tag = new BufferedImage((int) newWidth,
                        (int) newHeight, BufferedImage.TYPE_INT_RGB);

                /*
                * Image.SCALE_SMOOTH 的缩略算法 生成缩略图片的平滑度的 优先级比速度高 生成的图片质量比较好 但速度慢
                */
                tag.getGraphics().drawImage(img.getScaledInstance(newWidth, newHeight, Image.SCALE_SMOOTH), 0, 0, null);
                FileOutputStream out = new FileOutputStream(zipImage.getOutPutFilePath() + zipImage.getOutPutFileName());
                JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
//                JPEGEncodeParam param = encoder.getDefaultJPEGEncodeParam(tag);
//                param.setQuality(0.75f, true);
//                encoder.encode(tag,param);
                encoder.encode(tag);
                out.close();
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    /**
     * 创建文件夹目录
     *
     * @param filePath
     * @return
     * @throws Exception
     */
    private boolean mddir(String filePath) throws Exception {
        boolean flag = false;
        File f = new File(filePath);
        if (!f.exists()) {
            flag = f.mkdirs();
        } else {
            flag = true;
        }
        return flag;
    }

    /**
     * 获得文件名和扩展名
     *
     * @param fullFileName
     * @return
     * @throws Exception
     */
    private String[] getFileNameAndExtName(String fullFileName)
            throws Exception {
        String[] fileNames = new String[2];
        if (fullFileName.indexOf(".") == -1) {
            throw new Exception("源文件名不正确！");
        } else {
            fileNames[0] = fullFileName.substring(0, fullFileName
                    .lastIndexOf("."));
            fileNames[1] = fullFileName
                    .substring(fullFileName.lastIndexOf(".") + 1);
        }
        return fileNames;
    }

    public Image getSourceImage(ZIPImage zipImage) throws IOException{
        //获得源文件
        File file = new File(zipImage.getInPutFilePath() + zipImage.getInPutFileName());
        if (!file.exists()) {
            throw new FileNotFoundException(zipImage.getInPutFilePath() + zipImage.getInPutFileName() + " 文件不存在！");
        }
        Image img = ImageIO.read(file);
        return img;
    }

    /*
    * 获得图片大小
    * @path ：图片路径
    */
    public long getPicSize(String path) {
        File file = new File(path);
        return file.length();
    }

    public static void compressPic(int width,int height,String inputFilePath,String inputFileName){
        try {
            int[] newImageSize = {width,height};
//            String outPutFilePath = "C:\\Users\\Public\\Pictures\\Sample Pictures\\";
//            String outPutFileName = "test2.jpg";
            boolean autoBuildFileName = true;


            ZIPImage zipImage = new ZIPImage(inputFilePath,inputFileName,autoBuildFileName);
            zipImage.setOutPutFileWidth(newImageSize[0]);
            zipImage.setOutPutFileHeight(newImageSize[1]);

            CutImageNew cutImageNew = new CutImageNew();
//            Image image= cutImageNew.getSourceImage(zipImage);
//            long size = cutImageNew.getPicSize(inputFilePath + inputFileName);
//            System.out.println("处理前的图片大小 width:"+image.getWidth(null));
//            System.out.println("处理前的图片大小 height:"+image.getHeight(null));
//            System.out.println("处理前的图片容量:"+ size +" bit");
            cutImageNew.compressImage(zipImage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        try {
            String inputFilePath = "C:\\Users\\Public\\Pictures\\Sample Pictures\\";
            String inputFileName = "test.jpg";
            CutImageNew.compressPic(1001,1334,inputFilePath,inputFileName);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
