package com.culturecloud.util;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;

import com.swetake.util.Qrcode;

public class QRCode {

	static int width = 92;
    static int height = 92;
    public static void create_image(String sms_info,String qrcodePicfilePath) throws Exception {
        try {
            Qrcode testQrcode = new Qrcode();
            testQrcode.setQrcodeErrorCorrect('M');
            testQrcode.setQrcodeEncodeMode('B');
            testQrcode.setQrcodeVersion(7);
            String testString = sms_info;
            byte[] d = testString.getBytes("gbk");
            BufferedImage bi = new BufferedImage(width, height, BufferedImage.TYPE_BYTE_BINARY);
            Graphics2D g = bi.createGraphics();
            g.setBackground(Color.WHITE);
            g.clearRect(0, 0, width, height);
            g.setColor(Color.BLACK);
            // 限制最大字节数为119
            if (d.length > 0 && d.length < 120) {
                boolean[][] s = testQrcode.calQrcode(d);
                for (int i = 0; i < s.length; i++) {
                    for (int j = 0; j < s.length; j++) {
                        if (s[j][i]) {
                            g.fillRect(j * 2, i * 2, 2, 2);
                        }
                    }
                }
            }
            g.dispose();
            bi.flush();
            File file = new File(qrcodePicfilePath);
            if(!file.exists()){
                file.mkdirs();
            }
            String suffix = file.getName().substring(file.getName().indexOf(".")+1, file.getName().length());
            ImageIO.write(bi, suffix,file); //"png"
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 自定义宽高
     * @param sms_info
     * @param qrcodePicfilePath
     * @param width
     * @param height
     * @throws Exception
     */
    public static void create_image(String sms_info,String qrcodePicfilePath,int size) throws Exception {
        try {
            Qrcode testQrcode = new Qrcode();
            testQrcode.setQrcodeErrorCorrect('M');
            testQrcode.setQrcodeEncodeMode('B');
            testQrcode.setQrcodeVersion(7);
            String testString = sms_info;
            byte[] d = testString.getBytes("utf-8");
            boolean[][] s = testQrcode.calQrcode(d);
            int unitSize = size / s.length;  
            BufferedImage bi = new BufferedImage(size, size, BufferedImage.TYPE_BYTE_BINARY);
            Graphics2D g = bi.createGraphics();
            g.setBackground(Color.WHITE);
            g.clearRect(0, 0, size, size);
            g.setColor(Color.BLACK);
            // 限制最大字节数为119
            if (d.length > 0 && d.length < 150) {
                for (int i = 0; i < s.length; i++) {
                    for (int j = 0; j < s.length; j++) {
                        if (s[j][i]) {
                        	g.fillRect(j*unitSize, i*unitSize, unitSize, unitSize);
                        }
                    }
                }
            }
            g.dispose();
            bi.flush();
            File file = new File(qrcodePicfilePath);
            if(!file.exists()){
                file.mkdirs();
            }
            String suffix = file.getName().substring(file.getName().indexOf(".")+1, file.getName().length());
            //二维码输出到文件 
            ImageIO.write(bi, suffix,file);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
