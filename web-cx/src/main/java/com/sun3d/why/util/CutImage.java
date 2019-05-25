package com.sun3d.why.util;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by chenjie on 2016/3/3.
 */
public class CutImage {

    /**
     * 切割图片
     *
     * @param sourceFile
     *            源文件
     * @param targetDir
     *            存储目录
     * @param width
     *            切片宽度
     * @param height
     *            切片高度
     * @return
     * @throws Exception
     */
    public void cut(File sourceFile, String targetDir, int width, int height)
            throws Exception {
//        List<File> list = new ArrayList<File>();
        BufferedImage source = ImageIO.read(sourceFile);
        int sWidth = source.getWidth(); // 图片宽度
        int sHeight = source.getHeight(); // 图片高度

        float rate = (float)(height*1.0)/width;

        if(sWidth < sHeight){
            width = sWidth-1;
            height = (int)((sWidth-1)*rate);
        }else if(sWidth > sHeight){
            width = sHeight-1;
            height = sHeight-1;
        }

        int cols = 0; // 横向切片总数
        int rows = 0; // 纵向切片总数
        int eWidth = 0; // 末端切片宽度
        int eHeight = 0; // 末端切片高度
        if (sWidth % width == 0) {
            cols = sWidth / width;
        } else {
            eWidth = sWidth % width;
            cols = sWidth / width + 1;
        }
        if (sHeight % height == 0) {
            rows = sHeight / height;
        } else {
            eHeight = sHeight % height;
            rows = sHeight / height + 1;
        }
        String fileName = null;
        File file = new File(targetDir);
        if (!file.exists()) { // 存储目录不存在，则创建目录
            file.mkdirs();
        }
        BufferedImage image = null;
        int cWidth = 0; // 当前切片宽度
        int cHeight = 0; // 当前切片高度
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                cWidth = getWidth(j, cols, eWidth, width);
                cHeight = getHeight(i, rows, eHeight, height);
                // x坐标,y坐标,宽度,高度
                image = source.getSubimage(j * width, i * height, cWidth,
                        cHeight);
                fileName = targetDir + "/map_" + i + "_" + j + ".jpg";
                file = new File(fileName);
                if(i==0 && j==0){
                    ImageIO.write(image, "JPEG", file);
                }
            }
        }
    }

    /**
     * 获取当前切片的宽度
     *
     * @param index
     *            横向索引
     * @param cols
     *            横向切片总数
     * @param endWidth
     *            末端切片宽度
     * @param width
     *            切片宽度
     * @return
     */
    private int getWidth(int index, int cols, int endWidth, int width) {
        if (index == cols - 1) {
            if (endWidth != 0) {
                return endWidth;
            }
        }
        return width;
    }
    /**
     * 获取当前切片的高度
     *
     * @param index
     *            纵向索引
     * @param rows
     *            纵向切片总数
     * @param endHeight
     *            末端切片高度
     * @param height
     *            切片高度
     * @return
     */
    private int getHeight(int index, int rows, int endHeight, int height) {
        if (index == rows - 1) {
            if (endHeight != 0) {
                return endHeight;
            }
        }
        return height;
    }

    public static void main(String[] args) {
        CutImage cutImage = new CutImage();
        try {
            File file = new File("D:\\sun3d\\front\\1560191\\201603\\Img\\Img7e22fe7a189d4229934aedfadc7a0d31.jpg");
            cutImage.cut(file,"D:\\sun3d\\front\\1560191\\201603\\Img\\",150,100);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
