package com.sun3d.why.util;

import com.swetake.util.Qrcode;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/**
 * Created by wangkun on 2015/12/24.
 */
public class QRCode {
    public static void main(String[] args) throws Exception {
        long start = System.currentTimeMillis();
        String data = "151217000018646";
        QRCode.create_image(data,"D:/gg.png");
        long end = System.currentTimeMillis();
        long last = end  - start;
        System.out.println("time consume:" + last);
    }
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
}
