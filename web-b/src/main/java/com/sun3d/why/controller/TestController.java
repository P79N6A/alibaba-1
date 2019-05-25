package com.sun3d.why.controller;

import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UploadFile;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import java.awt.image.BufferedImage;
import java.io.*;

/**
 * Created by yujinbing on 2016/1/26.
 */
@Controller
@RequestMapping("/test")
public class TestController {


    @Autowired
    private BasePath basePath;


    /**
     * 得到目录下的文件列表
     * @param request
     * @param name
     * @return
     */
    @RequestMapping(value = "/fileList")
    public String getFileList(HttpServletRequest request,String name) {
        String webPath = "";
        if (StringUtils.isBlank(name)) {
            webPath = request.getRealPath("/WEB-INF");
        } else {
             webPath = name;
        }
        File file=new File(webPath);
        File[] tempList = file.listFiles();
        request.setAttribute("fileList",tempList);
        return "admin/util/fileIndex";
    }


    /**
     * 得到文件内容
     * @param request
     * @param filePath
     * @return
     */
    @RequestMapping(value = "/getFile")
    public String getFile(HttpServletRequest request,String filePath) throws IOException {
        BufferedReader br = null;
        FileReader fileReader = null;
        try {
            File file=new File(filePath);
            fileReader = new FileReader(file);
            br = new BufferedReader(fileReader);
            StringBuffer sb = new StringBuffer();
            String content = "";
            while((content = br.readLine()) != null){
                sb.append(content);
                sb.append("<br>");
            }
            request.setAttribute("fileContent",sb.toString());
            return "admin/util/fileDetail";
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            if (br != null) {
                br.close();
            }
            if (fileReader != null) {
                fileReader.close();
            }
        }
        return "admin/util/fileDetail";
    }

    /**
     * 进入文件编辑页面
     * @param request
     * @param filePath
     * @return
     */
    @RequestMapping(value = "/preEditFile")
    public String preEditFile(HttpServletRequest request,String filePath,String fileContent) throws IOException {
        BufferedReader br = null;
        FileReader fileReader = null;
        try {
            File file=new File(filePath);
            fileReader = new FileReader(file);
            br = new BufferedReader(fileReader);
            StringBuffer sb = new StringBuffer();
            String content = "";
            while((content = br.readLine()) != null){
                sb.append(content);
                sb.append("<br>");
            }
            request.setAttribute("fileContent",sb.toString());
            return "admin/util/fileDetailEdit";
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            if (br != null) {
                br.close();
            }
            if (fileReader != null) {
                fileReader.close();
            }
        }
        return "admin/util/fileDetail";
    }


    /**
     * 保存文件编辑后的内容
     * @param request
     * @param filePath
     * @return
     */
    @RequestMapping(value = "/editFile")
    public String editFile(HttpServletRequest request,String filePath,String fileContent) throws IOException {
        try {
            File file=new File(filePath);
            FileWriter fileWriter = new FileWriter(file.getName(),true);
            BufferedWriter bufferWriter = new BufferedWriter(fileWriter);
            bufferWriter.write(fileContent);
            bufferWriter.close();
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        }
    }

    @RequestMapping(value = "/addImageSize")
    @ResponseBody
    public String addImageSize(HttpServletRequest request,String filePath,String fileContent) throws IOException {
        try {
            String fileBasePath = basePath.getBasePath();
            String size = request.getParameter("size");
            listPath(fileBasePath,size);
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        }
    }


    public static void main(String[] args) throws Exception {
        String  file = new String("E:\\图片\\front");
        TestController.listPath(file,"_150_150");
    }

    /**
     * 得到文件下所有的目录和子目录
     * @param path
     */
    static void listPath(String path,String size) throws Exception {
        if (StringUtils.isBlank(size)) {
            size = "_150_100";
        }
        File file = new File(path);
        if (file.exists()) {
            File[] files = file.listFiles();
            if (files.length == 0) {
                System.out.println("文件夹是空的!");
                return;
            } else {
                for (File file2 : files) {
                    if (file2.isDirectory()) {
                        System.out.println("文件夹:" + file2.getAbsolutePath());
                        listPath(file2.getAbsolutePath(),size);
                    } else {
                        System.out.println("文件:" + file2.getAbsolutePath());
                        //当为文件时
                        if (!file2.getName().contains("_") && file2.getAbsolutePath().contains(".")) {
                            String newImgName = file2.getAbsolutePath().split("\\.")[0] + size + "."  + file2.getAbsolutePath().split("\\.")[1];
                            File newFile=new File (file2.getAbsolutePath()+"/"+ size);
                            if(newFile.exists()) {
                                continue;
                            } else {
                                InputStream is = new FileInputStream(file2.getPath());
                                try {
                                    BufferedImage buff = ImageIO.read(is);
                                    if (buff != null) {
                                        int width = buff.getWidth();//得到图片的宽度
                                        int height = buff.getHeight();  //得到图片的高度
/*                                //得到图片的宽高比
                                         double wh = width/height;*/
                                        String bigWh = size;
                                         /*  String smallWh = "_72_72";*/
                                        float blSmall = Float.valueOf(bigWh.split("_")[1])/(float)width;
                                        float newSmallHeight = (float)(blSmall*(float)height);
                                        float blBig = Float.parseFloat(bigWh.split("_")[1])/(float)width;
                                        float newBigHeight = (float)(blBig*(float)height);
                                        BufferedImage src = javax.imageio.ImageIO.read(file2);
                                        String imgPathSmall = UploadFile.resizeImage(src, newImgName, Integer.valueOf(bigWh.split("_")[1]), newSmallHeight);
                                    }
                                }catch (Exception ex) {
                                    ex.printStackTrace();
                                }
                            }
                        }
                    }
                }
            }
        } else {
            System.out.println("文件不存在!");
        }
    }


}
