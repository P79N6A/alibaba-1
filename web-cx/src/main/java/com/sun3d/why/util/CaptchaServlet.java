package com.sun3d.why.util;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;


/**
 * Created by Administrator on 2015/7/1.
 */
public class CaptchaServlet extends HttpServlet {

    /**
     *
     */
    private static final long serialVersionUID = 1L;
    private String sRand = "";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {
        iniPage(request, response);
        // 在内存中创建图象
        int width = 60, height = 18;
        BufferedImage image = new BufferedImage(width, height,
                BufferedImage.TYPE_INT_RGB);
        Graphics g = image.getGraphics();

        g.setColor(getRandColor(200, 250));
        g.fillRect(0, 0, width, height);
        g.setFont(new Font("Times New Roman", Font.PLAIN, 18));



        getInterferentialLines(g, 155, width, height);

        getRandomNum(g, 4);
        request.getSession().setAttribute(Constant.CAPTCHA, sRand);
        g.dispose();
        ImageIO.write(image, "JPEG", response.getOutputStream());
    }

    private void iniPage(HttpServletRequest request,
                         HttpServletResponse response) {
        // 初始化页面
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        response.setContentType("image/jpeg");
    }

    private Graphics getInterferentialLines(Graphics g, int iCount, int iWidth,
                                            int iHeight) {
        // 随机产生iCount条干扰线，使图象中的认证码不易被其它程序探测到
        Random random = new Random();
        g.setColor(getRandColor(160, 200));
        for (int i = 0; i < iCount; i++) {
            int x = random.nextInt(iWidth);
            int y = random.nextInt(iHeight);
            int xl = random.nextInt(12);
            int yl = random.nextInt(12);
            g.drawLine(x, y, x + xl, y + yl);
        }
        return g;
    }

    private Graphics getRandomNum(Graphics g, int iCount) {
        // 取随机产生的认证码(iCount位数字)
        Random random = new Random();
        sRand = "";
        for (int i = 0; i < iCount; i++) {
            String rand = String.valueOf(random.nextInt(10));
            sRand += rand;
            // 将认证码显示到图象中
            g.setColor(new Color(20 + random.nextInt(110), 20 + random
                    .nextInt(110), 20 + random.nextInt(110)));
            // 调用函数出来的颜色相同，可能是因为种子太接近，所以只能直接生成
            g.drawString(rand, 13 * i + 6, 16);
        }
        return g;
    }

    private Color getRandColor(int fc, int bc) {
        // 给定范围获得随机颜色
        Random random = new Random();
        if (fc > 255) {
            fc = 255;
        }
        if (bc > 255) {
            bc = 255;
        }
        int r = fc + random.nextInt(bc - fc);
        int g = fc + random.nextInt(bc - fc);
        int b = fc + random.nextInt(bc - fc);
        return new Color(r, g, b);
    }

}
