package com.sun3d.why.publicWebservice.controller;

import com.sun3d.why.publicWebservice.service.UploadService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RequestMapping("/public/uploads")
@Controller
public class UploadController {
    private Logger logger = LoggerFactory.getLogger(UploadController.class);

    @Autowired
    private UploadService uploadService;

    /***
     * 文件上传接口
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/uploadFile")
    public void uploadFile(@RequestParam("file") MultipartFile mulFile, String userId, HttpServletResponse response) throws ServletException, IOException {

        logger.info("进入前台上传文件方法");
        //返回前台页面json格式
        String json = "";
        try {
            json=uploadService.uploadFile(userId,mulFile);
        }
        catch (Exception e) {
            logger.error("文件上传出错!", e);
        }
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();

    }
}
