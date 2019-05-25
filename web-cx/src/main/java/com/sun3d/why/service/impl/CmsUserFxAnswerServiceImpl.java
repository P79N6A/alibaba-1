package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.CmsUserFxAnswerMapper;
import com.sun3d.why.model.CmsUserFxAnswer;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsUserFxAnswerService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Service
public class CmsUserFxAnswerServiceImpl implements CmsUserFxAnswerService {

    private Logger logger = LoggerFactory.getLogger(CmsUserFxAnswerServiceImpl.class);

    @Autowired
    private CmsUserFxAnswerMapper userFxAnswerMapper;
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    @Autowired
    private UserIntegralService userIntegralService;
    @Autowired
    private StaticServer staticServer;
    
	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public String saveOrUpdateFxAnswer(CmsUserFxAnswer record) {
		int result = 1;
		CmsUserFxAnswer cmsUserFxAnswer = userFxAnswerMapper.selectById(record.getUserId());
		if(cmsUserFxAnswer!=null){
			CmsUserFxAnswer oldBean = userFxAnswerMapper.selectById(record.getUserId());
			if(record.getUserScore()!=null||record.getUserName()!=null||
					record.getUserMobile()!=null||record.getUserEmail()!=null){
				if(record.getUserName()!=null){
					record.setUserName(EmojiFilter.filterEmoji(record.getUserName()));
				}
				result = userFxAnswerMapper.updateById(record);
				if(record.getUserName()!=null){
					if(StringUtils.isBlank(oldBean.getUserName())){
						//添加积分
						UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
						userIntegralDetail.setIntegralChange(100);
						userIntegralDetail.setChangeType(0);
						userIntegralDetail.setIntegralFrom("奉贤问答完善个人信息");
						userIntegralDetail.setIntegralType(IntegralTypeEnum.FX_ANSWER.getIndex());
						userIntegralDetail.setUserId(record.getUserId());
						userIntegralDetail.setUpdateType(0);
						HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
						JSONObject jsonObject = JSON.parseObject(res.getData());
						String status = jsonObject.get("status").toString();
						if(!status.equals("200")){
							return "500";
						}
					}
				}
			}
		}else{
			record.setCreateTime(new Date());
			record.setUserScore(0);
			result = userFxAnswerMapper.insert(record);
		}
		if(result == 1){
		    return  "200";
		}else{
		    return  "500";
		}
	}

	@Override
	public CmsUserFxAnswer queryFxUserInfo(String userId) {
		CmsUserFxAnswer result = null;
    	try {
			result = userFxAnswerMapper.selectById(userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return result;
	}

}
