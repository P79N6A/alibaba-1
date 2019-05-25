package com.sun3d.why.publicWebservice.service;


import org.springframework.web.multipart.MultipartFile;

public interface UploadService {
    /**
     * app上传文件根据用户id获取用户信息
     * @param userId 用户id
     * @param mulFile 文件流对象
     * @return
     */
    public  String uploadFile(String userId, MultipartFile mulFile)throws Exception;
}
