package com.sun3d.why.publicWebservice.service.impl;

import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.HandWritingImgMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;

import com.sun3d.why.publicWebservice.model.HandWritingImg;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.MD5Util;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.util.UploadFile;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户接口实现类
 * Created by yujinbing on 2015/12/21.
 */
@Service
@Transactional
class UserPublicServiceImpl implements com.sun3d.why.publicWebservice.service.UserPublicService{

    public JSONObject jsonObject = new JSONObject();

    @Autowired
    private CmsTerminalUserMapper cmsTerminalUserMapper;

    @Autowired
    private HandWritingImgMapper handWritingImgMapper;

    @Autowired
    private CmsTerminalUserMapper userMapper;

    @Autowired
    private BasePath basePath;

    @Autowired
    private StaticServer staticServer;

    /**
     * 保存注册的用户信息
     * @param user
     * @return
     */
    @Override
    public JSONObject saveUser(CmsTerminalUser user) {
        if (user != null) {
            if (StringUtils.isBlank(user.getUserMobileNo())) {
                jsonObject.put("status",0);
                jsonObject.put("msg","用户手机号不能为空");
                return jsonObject;
            }
            if (StringUtils.isBlank(user.getUserName())) {
                jsonObject.put("status",0);
                jsonObject.put("msg","用户名不能为空");
                return jsonObject;
            }
            if (StringUtils.isBlank(user.getUserPwd())) {
                jsonObject.put("status",0);
                jsonObject.put("msg","用户密码不能为空");
                return jsonObject;
            }
            //判断手机号是否已经被注册
            user.setUserId(UUIDUtils.createUUId());
            user.setUserNickName(user.getUserName());
            user.setCreateTime(new Date());
            user.setUserPwd(MD5Util.toMd5(user.getUserPwd()));
            user.setUserIsDisable(Constant.USER_IS_ACTIVATE);
            user.setCommentStatus(Constant.NO_DISABLE_TERMINAL_USER_COMMENT);
            user.setUserType(Constant.USER_TYPE1);
            if (cmsTerminalUserMapper.addTerminalUser(user) > 0) {
                jsonObject.put("status",1);
                jsonObject.put("msg","success");
            } else {
                jsonObject.put("status",0);
                jsonObject.put("msg","数据插入失败");
            }
        } else {
            jsonObject.put("status",0);
            jsonObject.put("msg","用户不能为空");
        }
        return jsonObject;
    }


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
                    newImgName = Constant.IMG + UUIDUtils.createUUId();
                }
                sdf.applyPattern("yyyyMM");
                StringBuffer uploadCode=new StringBuffer();//拼接图片路径
                uploadCode.append(Constant.type_front + "/HandWriting");
                if(terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
                    uploadCode.append(terminalUser.getUserMobileNo().substring(0, 7)+"/");
                }else {
                    uploadCode.append("0000000"+"/");
                }
                uploadCode.append(sdf.format(new Date()));
                //   String uploadCode = Constant.type_front + "/" + terminalUser.getUserMobileNo().substring(0, 7) + "/" + sdf.format(new Date());
                StringBuffer fileUrl = new StringBuffer();
                fileUrl.append(uploadCode.toString() + "/" + Constant.IMG);
                /***********位置请不要挪动*************/
                dirPath = fileUrl.toString();
                //处理原文件
                UploadFile.uploadFile(mulFile, newImgName, imgSuffix, dirPath, basePath);
                /***********位置请不要挪动*************/
                /***************新添加代码*******************/
                fileUrl.append("/");
                fileUrl.append(newImgName);
                String imagePath = basePath.getBasePath() + fileUrl.toString();
                //处理上传图片进行处理 "300_300 750_500"
                if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG") || imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG") ||
                        imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP") || imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF") ||
                        imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
                    UploadFile.zoomFile(mulFile, imagePath, imgSuffix, "8","2");
                }
                //添加图片格式后缀
                fileUrl.append(imgSuffix);
                //绝对路径
                String appFileUrl = staticServer.getStaticServerUrl() + fileUrl.toString();
                HandWritingImg handWritingImg = new HandWritingImg();
                handWritingImg.setUserId(userId);
                handWritingImg.setCreateTime(new Date());
                handWritingImg.setId(UUIDUtils.createUUId());
                handWritingImg.setImgUrl(fileUrl.toString());
                handWritingImg.setUpdateType(1);
                status= handWritingImgMapper.insert(handWritingImg);
                if(status>0){
                    json = UploadFile.toResultFormat(200, appFileUrl);
                }
                /***************新添加代码 end*******************/
            }
        }catch (Exception e) {
            e.printStackTrace();
            json = UploadFile.toResultFormat(404,"传输失败！");
        }
        return json;
    }
    /**
     * 用户图片列表
     * @param userId
     * @return
     */
    @Override
    public JSONObject imgList(String userId) {
        if (userId != null ) {
            Map<String, Object> map = new HashMap<String, Object>();
            List<HandWritingImg> list = new ArrayList<HandWritingImg>();
            map.put("userId", userId);
            list= handWritingImgMapper.selectByUserId(map);
            List<String> imgList = new ArrayList<String>();
            List<String> timeList = new ArrayList<>();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            for (HandWritingImg img : list) {
                String appFileUrl = staticServer.getStaticServerUrl() + img.getImgUrl().toString();
                Date time=img.getCreateTime();
                imgList.add(appFileUrl);
                timeList.add(dateFormat.format(time));
            }
            jsonObject.put("status",1);
            jsonObject.put("imgList",imgList);
            jsonObject.put("timeList",timeList);
            jsonObject.put("msg","传输正常");
        } else {
            jsonObject.put("status",0);
            jsonObject.put("msg","用户缺失");
        }
        return jsonObject;
    }

    /**
     * 用户登录
     * @param user
     * @return
     */
    @Override
    public JSONObject checkUserLogin(CmsTerminalUser user) {
        if (StringUtils.isBlank(user.getUserMobileNo())) {
            jsonObject.put("status",0);
            jsonObject.put("msg","用户手机号不能为空");
            return jsonObject;
        }
/*        if (StringUtils.isBlank(user.getUserName())) {
            jsonObject.put("status",0);
            jsonObject.put("msg","用户名不能为空");
            return jsonObject;
        }*/
        if (StringUtils.isBlank(user.getUserPwd())) {
            jsonObject.put("status",0);
            jsonObject.put("msg","用户密码不能为空");
            return jsonObject;
        }
        user.setUserPwd(MD5Util.toMd5(user.getUserPwd()));
        CmsTerminalUser cmsTerminalUser = cmsTerminalUserMapper.checkUserLogin(user);
        if (cmsTerminalUser != null ) {
            jsonObject.put("status",1);
            jsonObject.put("msg",cmsTerminalUser);
        } else {
            jsonObject.put("status",0);
            jsonObject.put("msg","用户名或密码错误");
        }
        return jsonObject;
    }

    /**
     * 保存图片信息
     */
	@Override
	public String insert(HandWritingImg handWritingImg) {
		try {
			int status = handWritingImgMapper.insert(handWritingImg);
			if(status>0){
			    return "200";
			}else{
				return "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "500";
		}
	}

	/**
	 * 系列活动列表（用户的图片放第一个）
	 */
	@Override
	public List<HandWritingImg> querySeriesImgList(PaginationApp pageApp,String userId) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<HandWritingImg> list = new ArrayList<HandWritingImg>();
		try {
			if(StringUtils.isNotBlank(userId)){
				map.put("userId", userId);
			}
			if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
			    map.put("firstResult", pageApp.getFirstResult());
			    map.put("rows", pageApp.getRows());
			}
			list = handWritingImgMapper.querySeriesImgList(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/**
     * 根据userId删除系列活动
     * @return
     */
	@Override
	public String seriesImgDel(String userId) {
		try {
			int result = handWritingImgMapper.seriesImgDelByUserId(userId);
			if(result == 1){
			    return  "success";
			}else{
			    return  "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "false";
		}
	}
}
