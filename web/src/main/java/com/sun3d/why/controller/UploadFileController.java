package com.sun3d.why.controller;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.util.UploadFile;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
/*
 * 后台上传图片
 * @param uploadType:类型  Img：图片  Audio.音频  Video.视频
 * @param file:图片表单
 * @param type 操作类型 区分广告图与其他的类型图 1代表切割广告图 其他值代表切割其它的图 空的话代表切割app中活动类型的图片
 */
@Controller
@RequestMapping("/upload")
public class UploadFileController {
    /**
     * log日志类
     */
    private Logger logger = Logger.getLogger(UploadFileController.class);
    @Autowired
    private BasePath basePath;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    HttpSession session;
    /**
     * 后台网页上传文件
     */
    @RequestMapping(value = "/uploadFile")
    public void uploadFile(HttpServletRequest request, HttpServletResponse response,SysUser sysUser) throws ServletException, IOException {
        logger.info("进入后台上传文件方法");
        String type=request.getParameter("type");
        //处理文件
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        //返回信息
        MultipartFile mulFile = null;
        //文件所存放路径，不包含basePath且不包含文件名称以及后缀
        String dirPath = null;
        //返回前台页面json格式
        String json = null;
        try {
            //SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
            if (sysUser == null || StringUtils.isBlank(sysUser.getUserCounty())) {
                logger.error("当前用户不存在，上传处理终止!");
                return;
            }
            MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
            //上传文件的类型(Img、Video、Audio)
            String uploadType = request.getParameter("uploadType");
            if (Constant.IMG.equals(uploadType)) {
                mulFile = multipartHttpServletRequest.getFile("file");
            } else if (Constant.ATTACH.equals(uploadType)) {
                mulFile = multipartHttpServletRequest.getFile("attachFile");
            }else {
                mulFile = multipartHttpServletRequest.getFile("voiceFile");
            }
            if (mulFile == null) {
                logger.error("不能匹配正在上传的文件，上传处理终止!");
                return;
            } else {
                // 获取文件后缀
                String  imgSuffix = UploadFile.getImgSuffix(mulFile);
                if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.IMG)) {
                    imgSuffix=".jpg";
                }

                String newImgName = "";
                if (StringUtils.isNotBlank("uploadType")) {
                    newImgName = uploadType + UUIDUtils.createUUId();
                }
                sdf.applyPattern("yyyyMM");
                String uploadCode = Constant.type_admin+"/"+sysUser.getUserCounty().split(",")[0] + "/" + sdf.format(new Date());
                StringBuffer fileUrl = new StringBuffer();
                if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.IMG)) {
                    fileUrl.append(uploadCode + "/" + Constant.IMG);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.VIDEO)) {
                    fileUrl.append(uploadCode + "/" + Constant.VIDEO);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.AUDIO)) {
                    fileUrl.append(uploadCode + "/" + Constant.AUDIO);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.ATTACH)) {
                    fileUrl.append(uploadCode + "/" + Constant.ATTACH);
                }
                /***********位置请不要挪动*************/
                dirPath = fileUrl.toString();
                //处理原文件
                UploadFile.uploadFile(mulFile, newImgName, imgSuffix, dirPath,basePath);
                /***********位置请不要挪动*************/
                /***************新添加代码*******************/
                fileUrl.append("/");
                fileUrl.append(newImgName);
                String imagePath = basePath.getBasePath() + fileUrl.toString();
               //type值区分标签图与其他上传的图片
               if(StringUtils.isNotBlank(type) && type!=null) {
                   //处理上传图片进行缩放,其他的格式不进行处理
                   if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG") || imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG") ||
                           imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP") || imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF") ||
                           imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
                           UploadFile.zoomFile(mulFile, imagePath, imgSuffix, type, "");

                   }
               }
                //添加图片格式后缀
                fileUrl.append(imgSuffix);
                String fileLocPath = imagePath+imgSuffix;
                BufferedImage buf = ImageIO.read(new File(fileLocPath));
                JSONObject jsonResult = new JSONObject();
                //可能不是图片 有可能是附件  需要判断非空
                if (buf != null) {
                    String initWidth =String.valueOf(buf.getWidth());
                    String initHeigth =String.valueOf(buf.getHeight());
                    jsonResult.put("initWidth",initWidth);
                    jsonResult.put("initHeigth",initHeigth);
                }
                jsonResult.put("code",0);
                jsonResult.put("data",fileUrl.toString());

                System.out.println("===============》》》》返回数据==========" + jsonResult.toString());
                response.getWriter().write(jsonResult.toString());
                /***************新添加代码 end*******************/
            }
        } catch (Exception e) {
            logger.error("文件上传出错!", e);
        }
    }

    @RequestMapping(value = "/frontUploadFile")
    public void frontUploadFile(HttpServletRequest request, HttpServletResponse response,CmsTerminalUser user) throws ServletException, IOException {


        String type = request.getParameter("type");
       /* CmsTerminalUser users = (CmsTerminalUser)request.getParameter("user");*/
        logger.info("进入前台上传文件方法");
        //处理文件
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        //返回信息
        MultipartFile mulFile = null;
        //文件所存放路径，不包含basePath且不包含文件名称以及后缀
        String dirPath = null;
        //返回前台页面json格式
        String json = null;
        try {
            if (user == null || StringUtils.isBlank(user.getUserMobileNo())) {
                logger.error("前台用户不存在，上传处理终止!");
                return;
            }
            MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
            //上传文件的类型(Img、Video、Audio)
            String uploadType = request.getParameter("uploadType");
            if (Constant.IMG.equals(uploadType)) {
                mulFile = multipartHttpServletRequest.getFile("file");
            } else {
                mulFile = multipartHttpServletRequest.getFile("voiceFile");
            }
            if (mulFile == null) {
                logger.error("不能匹配正在上传的文件，上传处理终止!");
                return;
            } else {
                // 获取文件后缀
                String  imgSuffix = UploadFile.getImgSuffix(mulFile);
                String newImgName = "";
                if (StringUtils.isNotBlank("uploadType")) {
                    newImgName = uploadType + UUIDUtils.createUUId();
                }
                sdf.applyPattern("yyyyMM");
                String uploadCode = Constant.type_front+"/"+user.getUserMobileNo().substring(0,7)+ "/" + sdf.format(new Date());
                StringBuffer fileUrl = new StringBuffer();
                if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.IMG)) {
                    fileUrl.append(uploadCode + "/" + Constant.IMG);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.VIDEO)) {
                    fileUrl.append(uploadCode + "/" + Constant.VIDEO);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.AUDIO)) {
                    fileUrl.append(uploadCode + "/" + Constant.AUDIO);
                }
                /***********位置请不要挪动*************/
                dirPath = fileUrl.toString();
                //处理原文件
                UploadFile.uploadFile(mulFile, newImgName, imgSuffix, dirPath,basePath);
                /***********位置请不要挪动*************/
                /***************新添加代码*******************/
                fileUrl.append("/");
                fileUrl.append(newImgName);
                String imagePath = basePath.getBasePath() + fileUrl.toString();
                //处理上传图片进行缩放,其他的格式不进行处理
                if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG") || imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG") ||
                        imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP") || imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF") ||
                        imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
                       UploadFile.zoomFile(mulFile, imagePath, imgSuffix,"10", "");
                }
                //添加图片格式后缀
                fileUrl.append(imgSuffix);
                String fileLocPath = imagePath+imgSuffix;
                BufferedImage buf = ImageIO.read(new File(fileLocPath));
                String initWidth =String.valueOf(buf.getWidth());
                String initHeigth =String.valueOf(buf.getHeight());
                JSONObject jsonResult = new JSONObject();
                jsonResult.put("code",0);
                jsonResult.put("data",fileUrl.toString());
                jsonResult.put("initWidth",initWidth);
                jsonResult.put("initHeigth", initHeigth);
                System.out.println("===============》》》》返回数据==========" + jsonResult.toString());
                response.getWriter().write(jsonResult.toString());
                /***************新添加代码 end*******************/
                logger.info("上传文件路径" + imagePath.toString());
            }
        } catch (Exception e) {
            logger.error("文件上传出错!", e);
        }
    }

    /**
     * 前台获取图片
     */

    /**
     * 删除文件接口
     */
    @RequestMapping(value = "/deleteFile")
    public void  deleteFile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String json="";
        //当前图片相对路径
        String imagePath=request.getParameter("imagePath");
        if(StringUtils.isNotBlank(imagePath)){
            //删除原图
            String SuffixImagePath =  basePath.getBasePath() + imagePath;
            File file = new File(SuffixImagePath);
            deleteFile(file);
            //删除大图
            // 得到路径数组,将路径进行切割
            String[] fileName = imagePath.trim().split("/");
            //获取文件后缀
            String[] imgSuffix=fileName[fileName.length-1].split("\\.");
            //对图片进行绝对路径封装
            StringBuffer bigBuffer=new StringBuffer();
            bigBuffer.append(basePath.getBasePath());
            bigBuffer.append(fileName[0]+"/");
            bigBuffer.append(fileName[1]+"/");
            bigBuffer.append(fileName[2]+"/"+imgSuffix[0]);
            StringBuffer smallBuffer=new StringBuffer();
            smallBuffer.append(bigBuffer.toString());
            bigBuffer.append("_big");
            bigBuffer.append("."+imgSuffix[1]);
            //String SuffixBigImagePath =  basePath.getBasePath() +fileName[0]+"/"+fileName[1]+"/"+fileName[2]+"/"+imgSuffix[0]+"_big"+"."+imgSuffix[1];
            File bigFile = new File(bigBuffer.toString());
            deleteFile(bigFile);
            //删除小图
            smallBuffer.append("_small");
            smallBuffer.append("."+imgSuffix[1]);
            String SuffixSmallImagePath=smallBuffer.toString();
            // String SuffixSmallImagePath =  basePath.getBasePath() +fileName[0]+"/"+fileName[1]+"/"+fileName[2]+"/"+imgSuffix[0]+"_small"+"."+imgSuffix[1];
            File smallFile = new File(SuffixSmallImagePath);
            deleteFile(smallFile);
            json = "{\"status\":0}";
            response.getWriter().print(json);
            response.getWriter().flush();
            response.getWriter().close();
        }
        else {
            logger.error("图片路径为空，删除停止");
            return ;
        }
    }
    /**
     * 返回数据至请求端
     *
     * @param response
     * @param responseStr
     */
    public void printResponse(HttpServletResponse response, String responseStr) {
        try {
            response.getWriter().println(responseStr);
            logger.info("--------"+responseStr);
            response.getWriter().flush();
            response.getWriter().close();
        } catch (IOException e) {
            logger.error("返回流数据至请求端时出错", e);
        }
    }

    /**
     * 判断上传文件的图片后缀是否在允许范围内
     *
     * @param suffix
     * @return
     */
    public boolean isAllowedImgSuffix(String suffix) {
        boolean allowed = false;
        List<String> suffixList = new ArrayList<String>();
        suffixList.add(".jpg");
        suffixList.add(".JPG");
        suffixList.add(".png");
        suffixList.add(".PNG");
        suffixList.add(".gif");
        suffixList.add(".GIF");
        suffixList.add(".jpeg");
        suffixList.add(".JPEG");
        suffixList.add(".bmp");
        suffixList.add(".BMP");
        if (suffixList.contains(suffix)) {
            allowed = true;
        }
        return allowed;
    }
    /*****************新添加代码************************/

    /**
     * 递归删除文件夹
     */
    private void deleteFile(File file) {
        try {
            if (file.exists()) {
                //判断文件是否存在
                if (file.isFile()) {//判断是否是文件
                    file.delete();//删除文件
                } else if (file.isDirectory()) {
                    //否则如果它是一个目录
                    File[] files = file.listFiles();//声明目录下所有的文件 files[];
                    for (int i = 0; i < files.length; i++) {//遍历目录下所有的文件
                        deleteFile(files[i]);//把每个文件用这个方法进行迭代
                    }
                    file.delete();//删除文件夹
                }
            } else {
                logger.info("删除的文件不存在");
            }
        } catch (Exception e) {
            logger.info("删除文件错误" + e);
        }
    }
    /**
     * 支持ckeditor插件本地上传
     *
     */
    @RequestMapping(value = "/uploadImg")
    public void uploadImg(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        {
            logger.info("进入ckeditor插件本地上传");
            //处理文件
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
            //返回信息
            MultipartFile mulFile = null;
            //文件所存放路径，不包含basePath且不包含文件名称以及后缀
            String dirPath = null;
            //返回前台页面json格式
            String json = null;
            try {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                if (sysUser == null || StringUtils.isBlank(sysUser.getUserCounty())) {
                    logger.error("当前用户不存在，上传处理终止!");
                    return;
                }
                MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
                mulFile = multipartHttpServletRequest.getFile("upload");
                if (mulFile == null) {
                    logger.error("不能匹配正在上传的文件，上传处理终止!");
                    return;
                } else {
                    // 获取文件后缀
                    String  imgSuffix = UploadFile.getImgSuffix(mulFile);
                    //验证ckeditor插件上传文件的格式
                    if (!isAllowedImgSuffix(imgSuffix)) {
                        logger.error("上传文件的格式错误=" + imgSuffix);
                        printResponse(response, "<script type=\"text/javascript\">alert('上传格式错误，仅支持.jpg|.jpeg|.png|.JPEG格式');</script>");
                        return;
                    }
                    if (mulFile.getSize() > 1024 * 1024 * 2) {
                        logger.error("上传文件的大小错误=" + imgSuffix);
                        printResponse(response, "<script type=\"text/javascript\">alert('上传图片大小错误，仅支持2兆以下的图片');</script>");
                        return;
                    }
                    String newImgName  = Constant.IMG + UUIDUtils.createUUId();
                    sdf.applyPattern("yyyyMM");
                    String uploadCode = sysUser.getUserCounty().split(",")[0] + "/" + sdf.format(new Date());
                    StringBuffer fileUrl = new StringBuffer();
                    fileUrl.append(uploadCode + "/" + Constant.IMG);
                    /***********位置请不要挪动*************/
                    dirPath = fileUrl.toString();
                    //处理原文件
                    UploadFile.uploadFile(mulFile, newImgName, imgSuffix, dirPath, basePath);
                    /***********位置请不要挪动*************/
                    /***************新添加代码*******************/
                    fileUrl.append("/");
                    fileUrl.append(newImgName);
                    String  imagePath = basePath.getBasePath() + fileUrl.toString();
                    //fileUrl.append(imgSuffix);
                    //处理上传图片进行缩放,其他的格式不进行处理
                    if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG") || imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG") ||
                            imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP") || imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF") ||
                            imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
                         UploadFile.zoomFile(mulFile, imagePath, imgSuffix,"9", "");
                    }
                    fileUrl.append("_750_500");
                    //添加图片格式后缀
                    fileUrl.append(imgSuffix);
                    /***************新添加代码 end*******************/
                    //图片本地路径
                    String imgUrl =staticServer.getStaticServerUrl()+fileUrl.toString();
                    String callback = request.getParameter("CKEditorFuncNum");
                    String fullContentType = "text/html;charset=UTF-8";
                    response.setContentType(fullContentType);
                    printResponse(response,"<script>window.parent.CKEDITOR.tools.callFunction("
                            + callback + ",'" + imgUrl.replaceAll("\r|\n", "")+ "',''" + ")" + "</script>");
                }
            } catch (Exception e) {
                logger.error("文件上传出错!", e);
            }
        }
    }

    /**
     * 后台网页上传文件 WebUploader 插件专用
     */
    @RequestMapping(value = "/webUploader")
    public void webUploader(HttpServletRequest request, HttpServletResponse response,SysUser sysUser) throws ServletException, IOException {
        logger.info("进入后台上传文件方法");
        String type=request.getParameter("modelType");
        //处理文件
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        //返回信息
        MultipartFile mulFile = null;
        //文件所存放路径，不包含basePath且不包含文件名称以及后缀
        String dirPath = null;
        //返回前台页面json格式
        String json = null;
        try {
            //SysUser sysUser = (SysUser) request.getSession().getAttribute("user");
            if (sysUser == null || StringUtils.isBlank(sysUser.getUserCounty())) {
                logger.error("当前用户不存在，上传处理终止!");
                return;
            }
            MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
            //上传文件的类型(Img、Video、Audio)
            String uploadType = request.getParameter("uploadType");
            if (Constant.IMG.equals(uploadType)) {
                mulFile = multipartHttpServletRequest.getFile("file");
            } else if (Constant.ATTACH.equals(uploadType)) {
                mulFile = multipartHttpServletRequest.getFile("attachFile");
            }else {
                mulFile = multipartHttpServletRequest.getFile("voiceFile");
            }
            if (mulFile == null) {
                logger.error("不能匹配正在上传的文件，上传处理终止!");
                return;
            } else {
                // 获取文件后缀
                String  imgSuffix = UploadFile.getImgSuffix(mulFile);
                if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.IMG)) {
                    imgSuffix=".jpg";
                }

                String newImgName = "";
                if (StringUtils.isNotBlank("uploadType")) {
                    newImgName = uploadType + UUIDUtils.createUUId();
                }
                sdf.applyPattern("yyyyMM");
                String uploadCode = Constant.type_admin+"/"+sysUser.getUserCounty().split(",")[0] + "/" + sdf.format(new Date());
                StringBuffer fileUrl = new StringBuffer();
                if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.IMG)) {
                    fileUrl.append(uploadCode + "/" + Constant.IMG);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.VIDEO)) {
                    fileUrl.append(uploadCode + "/" + Constant.VIDEO);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.AUDIO)) {
                    fileUrl.append(uploadCode + "/" + Constant.AUDIO);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.ATTACH)) {
                    fileUrl.append(uploadCode + "/" + Constant.ATTACH);
                }
                /***********位置请不要挪动*************/
                dirPath = fileUrl.toString();
                //处理原文件
                UploadFile.uploadFile(mulFile, newImgName, imgSuffix, dirPath,basePath);
                /***********位置请不要挪动*************/
                /***************新添加代码*******************/
                fileUrl.append("/");
                fileUrl.append(newImgName);
                String imagePath = basePath.getBasePath() + fileUrl.toString();
               //type值区分标签图与其他上传的图片
               if(StringUtils.isNotBlank(type) && type!=null) {
                   //处理上传图片进行缩放,其他的格式不进行处理
                   if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG") || imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG") ||
                           imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP") || imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF") ||
                           imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
                           UploadFile.zoomFile(mulFile, imagePath, imgSuffix, type, "");

                   }
               }
                //添加图片格式后缀
                fileUrl.append(imgSuffix);
                String fileLocPath = imagePath+imgSuffix;
                BufferedImage buf = ImageIO.read(new File(fileLocPath));
                JSONObject jsonResult = new JSONObject();
                //可能不是图片 有可能是附件  需要判断非空
                if (buf != null) {
                    String initWidth =String.valueOf(buf.getWidth());
                    String initHeigth =String.valueOf(buf.getHeight());
                    jsonResult.put("initWidth",initWidth);
                    jsonResult.put("initHeigth",initHeigth);
                }
                jsonResult.put("code",0);
                jsonResult.put("data",fileUrl.toString());

                System.out.println("===============》》》》返回数据==========" + jsonResult.toString());
                response.getWriter().write(jsonResult.toString());
                /***************新添加代码 end*******************/
            }
        } catch (Exception e) {
            logger.error("文件上传出错!", e);
        }
    }





    /********************临时玩家秀上传  单独建立文件夹 便于以后删除*********************/


    @RequestMapping(value = "/mcUploadFile",method = RequestMethod.POST)
    public void mcUploadFile(HttpServletRequest request, HttpServletResponse response){
        //处理文件
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        //返回信息
        MultipartFile mulFile = null;
        //文件所存放路径，不包含basePath且不包含文件名称以及后缀
        String dirPath = null;
        //返回前台页面json格式
        String json = null;
        try {
            MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
            //上传文件的类型(Img)
            String uploadType = request.getParameter("uploadType");
            if (Constant.IMG.equals(uploadType)) {
                mulFile = multipartHttpServletRequest.getFile("file");
            } else {
                return;
            }
            if (mulFile == null) {
                logger.error("不能匹配正在上传的文件，上传处理终止!");
                return;
            } else {
                // 获取文件后缀
                String  imgSuffix = UploadFile.getImgSuffix(mulFile);
                String newImgName = "";
                if (StringUtils.isNotBlank("uploadType")) {
                    newImgName = uploadType + UUIDUtils.createUUId();
                }
                sdf.applyPattern("yyyyMM");
                String uploadCode = Constant.type_front+"/mcShow/" + sdf.format(new Date());
                StringBuffer fileUrl = new StringBuffer();
                if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.IMG)) {
                    fileUrl.append(uploadCode + "/" + Constant.IMG);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.VIDEO)) {
                    fileUrl.append(uploadCode + "/" + Constant.VIDEO);
                } else if (StringUtils.isNotBlank(uploadType) && uploadType.equals(Constant.AUDIO)) {
                    fileUrl.append(uploadCode + "/" + Constant.AUDIO);
                }
                /***********位置请不要挪动*************/
                dirPath = fileUrl.toString();
                //处理原文件
                UploadFile.uploadFile(mulFile, newImgName, imgSuffix, dirPath,basePath);
                /***********位置请不要挪动*************/
                /***************新添加代码*******************/
                fileUrl.append("/");
                fileUrl.append(newImgName);
                String imagePath = basePath.getBasePath() + fileUrl.toString();
                //处理上传图片进行缩放,其他的格式不进行处理
                if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG") || imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG") ||
                        imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP") || imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF") ||
                        imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
                    UploadFile.zoomFile(mulFile, imagePath, imgSuffix,"10", "");
                }else{
                    return;
                }
                //添加图片格式后缀
                fileUrl.append(imgSuffix);
                String fileLocPath = imagePath+imgSuffix;
                BufferedImage buf = ImageIO.read(new File(fileLocPath));
                String initWidth =String.valueOf(buf.getWidth());
                String initHeigth =String.valueOf(buf.getHeight());
                JSONObject jsonResult = new JSONObject();
                jsonResult.put("code",0);
                jsonResult.put("data",fileUrl.toString());
                jsonResult.put("initWidth",initWidth);
                jsonResult.put("initHeigth", initHeigth);
                System.out.println("===============》》》》返回数据==========" + jsonResult.toString());
                response.getWriter().write(jsonResult.toString());
                /***************新添加代码 end*******************/
                //logger.info("上传文件路径" + imagePath.toString());
            }
        } catch (Exception e) {
            logger.error("文件上传出错!", e);
        }
    }



}