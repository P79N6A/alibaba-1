package com.sun3d.why.util;
import com.swetake.util.Qrcode;
import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/**
 * Created by Administrator on 2015/7/23.
 */
public class Code {
    public static int max_data_size_small = 84;
    public static int max_data_size_large = 500;
    /**
     *
     * @param srcValue
     * @param qrcodePicfilePath
     * @return
     */
    public static boolean encode(String srcValue, String qrcodePicfilePath) {
        //return  encode_500(srcValue, qrcodePicfilePath);
        return  encode_84(srcValue, qrcodePicfilePath);
    }

    /**
     * Encoding the information to a QRCode, size of the information must be less than 84 byte.
     * @param srcValue
     * @param qrcodePicfilePath
     * @return
     */
    public static boolean encode_84(String srcValue, String qrcodePicfilePath) {
        int MAX_DATA_LENGTH = max_data_size_small; // 限制生成二维码的数据最大大小
        byte[] d = srcValue.getBytes();
        int dataLength = d.length;
        int imageWidth = 140; /* 113是预先计算出来的. 注意：图像宽度必须比生成的二维码图像宽度大,至少相等,否则,二维码识别不出来 */
        int imageHeight = imageWidth;
        BufferedImage bi = new BufferedImage(imageWidth, imageHeight,
                BufferedImage.TYPE_INT_RGB);
        Graphics2D g = bi.createGraphics();
        g.setBackground(Color.WHITE);
        g.clearRect(0, 0, imageWidth, imageHeight);
        g.setColor(Color.BLACK);
        if (dataLength > 0 && dataLength <= MAX_DATA_LENGTH) {
            /* 生成二维码 */
            Qrcode qrcode=new Qrcode();
            qrcode.setQrcodeErrorCorrect('M'); // L, Q, H, 默认
            qrcode.setQrcodeEncodeMode('B'); // A, N, 默认
            qrcode.setQrcodeVersion(7); // 37字节, (37-1)*3+2+3-1+1 = 113
            boolean[][] b = qrcode.calQrcode(d);
            int qrcodeDataLen = b.length;
            for (int i = 0; i < qrcodeDataLen; i++) {
                for (int j = 0; j < qrcodeDataLen; j++) {
                    if (b[j][i]) {
                        g.fillRect(j * 3 + 2, i * 3 + 2, 3, 3); /*
                                                                 * 画二维码图形,
                                                                 * 画出的图形宽度是
                                                                 * ((qrcodeDataLen-1)*3+2) +
                                                                 * 3 -1 ;
                                                                 * 生成的image的宽度大小必须>=该值,外围的1个像素用来标识此块区域为二维码
                                                                 */
                        /*
                         * fillRect(int x, int y, int width, int height) 函数作用：
                         * 填充指定的矩形。该矩形左边和右边位于 x 和 x + width - 1。顶边和底边位于 y 和 y +
                         * height - 1。 得到的矩形覆盖的区域宽度为 width 像素，高度为 height 像素。
                         * 使用图形上下文的当前颜色填充该矩形。 参数： x - 要填充矩形的 x 坐标。 y - 要填充矩形的 y
                         * 坐标。 width - 要填充矩形的宽度。 height - 要填充矩形的高度。
                         *
                         * 参考：http://bk.chinaar.com/index.php?doc-view-2999
                         */
                    }
                }
            }
        } else {
            return false;
        }
        g.dispose();
        bi.flush();
        /* generate image */
        File file=new File(qrcodePicfilePath);
        if(!file.exists()){
            file.mkdirs();
        }
        String suffix = file.getName().substring(file.getName().indexOf(".")+1, file.getName().length());
        try {
            ImageIO.write(bi, suffix, file); //"png"
        } catch (IOException ioe) {
            return false;
        }

        return true;
    }

    /**
     * Encoding the information to a QRCode, size of the information must be less tah 500 byte.
     * @param srcValue
     * @param qrcodePicfilePath
     * @return
     */
    public static boolean encode_500(String srcValue, String qrcodePicfilePath) {
        int MAX_DATA_LENGTH = max_data_size_large; // 限制生成二维码的数据最大大小. 500字节的原始数据, 生成二维码时, 是89宽度
        byte[] d = srcValue.getBytes();
        int dataLength = d.length;
        int imageWidth = 269; /* 269是预先计算出来的. 注意：图像宽度必须比生成的二维码图像宽度大,至少相等,否则,二维码识别不出来 */
        int imageHeight = imageWidth;
        BufferedImage bi = new BufferedImage(imageWidth, imageHeight,
                BufferedImage.TYPE_INT_RGB);
        Graphics2D g = bi.createGraphics();
        g.setBackground(Color.WHITE);
        g.clearRect(0, 0, imageWidth, imageHeight);
        g.setColor(Color.BLACK);
        if (dataLength > 0 && dataLength <= MAX_DATA_LENGTH) {
            /* 生成二维码 */
            Qrcode qrcode = new Qrcode();
            qrcode.setQrcodeErrorCorrect('M'); // L, Q, H, 默认
            qrcode.setQrcodeEncodeMode('B'); // A, N, 默认
            qrcode.setQrcodeVersion(18); // 0<= version <=40; 89字节,
            // (89-1)*3+2+3-1+1 = 269
            boolean[][] b = qrcode.calQrcode(d);
            int qrcodeDataLen = b.length;
            for (int i = 0; i < qrcodeDataLen; i++) {
                for (int j = 0; j < qrcodeDataLen; j++) {
                    if (b[j][i]) {
                        g.fillRect(j * 3 + 2, i * 3 + 2, 3, 3); /*
                                                                 * 画二维码图形,
                                                                 * 画出的图形宽度是
                                                                 * ((qrcodeDataLen-1)*3+2) +
                                                                 * 3 -1 = 136;
                                                                 * 生成的image的宽度大小必须>=(136+1),外围的1个像素用来标识此块区域为二维码
                                                                 */
                        /*
                         * fillRect(int x, int y, int width, int height) 函数作用：
                         * 填充指定的矩形。该矩形左边和右边位于 x 和 x + width - 1。顶边和底边位于 y 和 y +
                         * height - 1。 得到的矩形覆盖的区域宽度为 width 像素，高度为 height 像素。
                         * 使用图形上下文的当前颜色填充该矩形。 参数： x - 要填充矩形的 x 坐标。 y - 要填充矩形的 y
                         * 坐标。 width - 要填充矩形的宽度。 height - 要填充矩形的高度。
                         *
                         * 参考：http://bk.chinaar.com/index.php?doc-view-2999
                         */
                    }
                }
            }
        } else {
            return false;
        }
        g.dispose();
        bi.flush();
        /* generate image */
        File f = new File(qrcodePicfilePath);
        String suffix = f.getName().substring(f.getName().indexOf(".")+1, f.getName().length());
        try {
            ImageIO.write(bi, suffix, f); //"png"
        } catch (IOException ioe) {
            return false;
        }

        return true;
    }

    public static void main(String[] args) throws Exception {

        String data = "http://i.eqxiu.com/s/mtOQoE46?eqrcode=1&from=singlemessage&isappinstalled=0";
        Code.encode(data, "D:/gg.jpg");

    }

}
