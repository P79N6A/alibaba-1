package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;
import com.sun3d.why.controller.wechat.WechatController;
import com.sun3d.why.dao.WeiXinMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.weixin.Access_token;
import com.sun3d.why.model.weixin.WeiXin;
import com.sun3d.why.service.WeiXinService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.Pagination;
@Service
@Transactional
public class WeiXinServiceImpl  implements WeiXinService {
	
    @Autowired
    private WeiXinMapper weiXinMapper;
    
    private Logger logger = LoggerFactory.getLogger(WeiXinServiceImpl.class);
    
    private static Gson gson = new Gson();
   
    /**
	 * 后端微信自动回复管理列表
	 * @param WeiXin
	 * @param page
	 * @return 场馆对象集合
	 */
	@Override
	public List<WeiXin> queryWeiXinByCondition(WeiXin weiXin, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();

		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
		    map.put("firstResult", page.getFirstResult());
		    map.put("rows", page.getRows());
		    int total = weiXinMapper.queryWeiXinCountByCondition(map);
		    page.setTotal(total);	
		}
		return weiXinMapper.queryWeiXinByCondition(map);
	}

	/**
	 * 根据id查询自助回复信息
	 * @return
	 */
	@Override
	public WeiXin queryWeixinById(String weiXinId){ 
		return weiXinMapper.queryWeixinById(weiXinId);
	}

	/**
	 * 根据id更新自助回复信息
	 * @return
	 */
	@Override
	public int editWeiXinById(WeiXin weiXin) {
		return weiXinMapper.editWeiXinById(weiXin);
	}

	/**
	 * 获取自动回复信息
	 * @return
	 */
	@Override
	public WeiXin queryWeiXin() {
		return weiXinMapper.queryWeiXin();
	}

	/**
	 * 获取微信用户信息
	 * @param code
	 * @return
	 */
	@Override
	public CmsTerminalUser queryWechatUserInfo(String code) {
		String access_token = null;
		CmsTerminalUser cmsTerminalUser = new CmsTerminalUser();
		try {
			// 通过code获取access_token
			access_token = BindWS.bindQuery(code);
			logger.info("登录 code 值：" + code);
			
			// 构建Access_token对象
			Access_token at = gson.fromJson(access_token, Access_token.class);
			
			String userinfo = BindWS.bind2Query(at.getAccess_token(),at.getOpen_id());
			userinfo = userinfo.substring(1, userinfo.length() - 1);
			userinfo = userinfo.replaceAll("\"", "");
			String[] strbox = userinfo.split(",");

			cmsTerminalUser.setUserId(strbox[0].split(":")[1]);
			cmsTerminalUser.setUserNickName(strbox[1].split(":")[1]);
			cmsTerminalUser.setUserSex(Integer.valueOf(strbox[2].split(":")[1]));
			cmsTerminalUser.setUserProvince(strbox[3].split(":")[1]);
			cmsTerminalUser.setUserCity(strbox[4].split(":")[1]);
			cmsTerminalUser.setUserHeadImgUrl(strbox[6].split(":")[1]);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return cmsTerminalUser;
	}


}
