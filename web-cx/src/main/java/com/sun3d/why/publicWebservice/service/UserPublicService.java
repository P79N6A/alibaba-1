package com.sun3d.why.publicWebservice.service;

import java.util.List;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.publicWebservice.model.HandWritingImg;
import com.sun3d.why.util.PaginationApp;

import net.sf.json.JSONObject;

import org.springframework.web.multipart.MultipartFile;

/**
 * 用户接口
 * Created by yujinbing on 2015/12/21.
 */
public interface UserPublicService {

    /**
     * 保存注册的用户信息
     * @param user
     * @return
     */
    public JSONObject saveUser(CmsTerminalUser user);

    /**
     * 用户登录
     * @param user
     * @return
     */
    public JSONObject checkUserLogin(CmsTerminalUser user);
    
    /**
     * app上传文件根据用户id获取用户信息
     * @param userId 用户id
     * @param mulFile 文件流对象
     * @return
     */
    public  String uploadFile(String userId, MultipartFile mulFile)throws Exception;
    /**
     * app上传文件根据用户id获取用户信息
     * @param userId 用户id
     * @return
     */
    public  JSONObject imgList(String userId)throws Exception;

    /**
     * 保存图片信息
     * @param handWritingImg
     * @return
     */
    public String insert(HandWritingImg handWritingImg);
    
    /**
     * 删除系列活动图片
     * @param userId
     * @return
     */
    public String seriesImgDel(String userId);
    
    /**
     * 系列活动列表（用户的图片放第一个）
     * @param pageApp
     * @param userId
     * @return
     */
    public List<HandWritingImg> querySeriesImgList(PaginationApp pageApp,String userId);

}
