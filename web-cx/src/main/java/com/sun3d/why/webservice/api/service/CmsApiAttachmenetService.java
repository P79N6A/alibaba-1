package com.sun3d.why.webservice.api.service;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.webservice.api.model.CmsApiFile;

public interface CmsApiAttachmenetService {
	//根据图片路径，上传图片
	public String uploadImage(String strUrl,SysUser sysUser,String type) throws Exception;
	
	//根据url地址获取文件流，并判断文件流数据是否合理
	public CmsApiFile checkImage(String strUrl);
}
