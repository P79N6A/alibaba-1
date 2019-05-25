package com.sun3d.why.publicWebservice.service.impl;


import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.HandWritingImgMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.publicWebservice.model.HandWritingImg;
import com.sun3d.why.publicWebservice.service.UploadService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.util.UploadFile;
import net.sf.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.text.SimpleDateFormat;
import java.util.Date;
@Service
@Transactional
class UploadServiceImpl implements com.sun3d.why.publicWebservice.service.UploadService {
    public JSONObject jsonObject = new JSONObject();

    @Autowired
    private HandWritingImgMapper handWritingImgMapper;

    @Autowired
    private CmsTerminalUserMapper userMapper;

    @Autowired
    private BasePath basePath;

    @Autowired
    private StaticServer staticServer;
    /**
     * 书法机上传图片根据用户id获取用户信息
     * @param userId 用户id
     * @parma mulFile 文件流对象
     * @return
     */
    @Override
    public String uploadFile(String userId, MultipartFile mulFile) throws Exception{
        //处理文件
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        //返回信息
        String dirPath = null;
        //返回前台页面json格式
        String json = "";
        //状态
        int status=0;
        try {
            CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
            if (terminalUser == null) {
                json = UploadFile.toResultFormat(401, "用户不存在!");
                return  json;
            }
            if (mulFile == null) {
                json = UploadFile.toResultFormat(403, "不能匹配正在上传的文件,上传处理终止!");
            } else {
                // 获取文件后缀
                String imgSuffix = UploadFile.getImgSuffix(mulFile);
                String newImgName = "";
                if (StringUtils.isNotBlank("uploadType")) {
                    newImgName = Constant.FILE + UUIDUtils.createUUId();
                }
                sdf.applyPattern("yyyyMM");
                StringBuffer uploadCode=new StringBuffer();//拼接路径
                uploadCode.append(Constant.type_front + "/Video");
                if(terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
                    uploadCode.append(terminalUser.getUserMobileNo().substring(0, 7)+"/");
                }else {
                    uploadCode.append("0000000"+"/");
                }
                uploadCode.append(sdf.format(new Date()));
                StringBuffer fileUrl = new StringBuffer();
                fileUrl.append(uploadCode.toString() + "/" + Constant.VIDEO);
                /***********位置请不要挪动*************/
                dirPath = fileUrl.toString();
                //处理原文件
                UploadFile.uploadFile(mulFile, newImgName, imgSuffix, dirPath, basePath);
                /***********位置请不要挪动*************/
                fileUrl.append("/");
                fileUrl.append(newImgName);
                //添加图片格式后缀
                fileUrl.append(imgSuffix);
                //绝对路径
                String appFileUrl = staticServer.getStaticServerUrl() + fileUrl.toString();
                HandWritingImg handWritingImg = new HandWritingImg();
                handWritingImg.setUserId(userId);
                handWritingImg.setCreateTime(new Date());
                handWritingImg.setId(UUIDUtils.createUUId());
                handWritingImg.setImgUrl(fileUrl.toString());
                handWritingImg.setUpdateType(2);
                status= handWritingImgMapper.insert(handWritingImg);
                if(status>0){
                    json = UploadFile.toResultFormat(200, appFileUrl);
                }
            }
        }catch (Exception e) {
            e.printStackTrace();
            json = UploadFile.toResultFormat(404,"传输失败！");
        }
        return json;
    }
}
