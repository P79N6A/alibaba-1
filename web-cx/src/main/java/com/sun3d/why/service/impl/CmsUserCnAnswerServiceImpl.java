package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.CmsUserCnAnswerMapper;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.model.CmsUserCnAnswer;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsUserCnAnswerService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Service
@Transactional(rollbackFor = Exception.class)
public class CmsUserCnAnswerServiceImpl implements CmsUserCnAnswerService {

    private Logger logger = LoggerFactory.getLogger(CmsUserCnAnswerServiceImpl.class);

    @Autowired
    private CmsUserCnAnswerMapper userCnAnswerMapper;
    @Autowired
    private StaticServer staticServer;
    
	@Override
	public String saveOrUpdateCnAnswer(CmsUserCnAnswer record) {
		int result = 1;
		try {
			CmsUserCnAnswer cmsUserCnAnswer = userCnAnswerMapper.selectById(record.getUserId());
			if(cmsUserCnAnswer!=null){
				if(record.getUserScore()!=null||record.getUserName()!=null||record.getUserMobile()!=null||record.getUserEmail()!=null){
					result = userCnAnswerMapper.updateById(record);
				}
			}else{
				record.setCreateTime(new Date());
				record.setUserScore(0);
				result = userCnAnswerMapper.insert(record);
			}
			if(result == 1){
				if(record.getUserName()!=null){
					JSONObject json=new JSONObject();
					json.put("userId", record.getUserId());
					json.put("userNickName", record.getUserName());
					json.put("userTelephone", record.getUserMobile());
					HttpClientConnection.post(staticServer.getChinaServerUrl() + "wechatUser/editTerminalUserByJson.do", json);
					
					//添加积分
					UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
					userIntegralDetail.setIntegralChange(100);
					userIntegralDetail.setChangeType(0);
					userIntegralDetail.setIntegralFrom("歌剧小知识问答完善信息");
					userIntegralDetail.setIntegralType(IntegralTypeEnum.OPERA_ANSWER.getIndex());
					userIntegralDetail.setUserId(record.getUserId());
					userIntegralDetail.setUpdateType(1);
					HttpResponseText res = HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
					JSONObject jsonObject = JSON.parseObject(res.getData());
					String status = jsonObject.get("status").toString();
					if(!status.equals("200")){
						return "500";
					}
				}
			    return  "200";
			}else{
			    return  "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "500";
		}
	}
	
	@Override
	public CmsUserCnAnswer statisticsCnAnswer(Integer userScore, String userId) {
		CmsUserCnAnswer result = null;
    	try {
    		CmsUserCnAnswer cmsUserCnAnswer = new CmsUserCnAnswer();
    		cmsUserCnAnswer.setUserId(userId);
    		cmsUserCnAnswer.setUserScore(userScore);
			result = userCnAnswerMapper.statisticsCnAnswer(cmsUserCnAnswer);
			result.setProportion(result.getProportion()!=null?result.getProportion():0);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return result;
	}

	@Override
	public CmsUserCnAnswer queryCnUserInfo(String userId) {
		CmsUserCnAnswer result = null;
    	try {
			result = userCnAnswerMapper.selectById(userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return result;
	}

	@Override
	public String saveCnAnswerData(Integer num) {
		try {
			for(int i=0;i<2*num;i++){
				CmsUserCnAnswer cmsUserCnAnswer = new CmsUserCnAnswer();
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(0);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
				
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(15);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
			}
			for(int i=0;i<3*num;i++){
				CmsUserCnAnswer cmsUserCnAnswer = new CmsUserCnAnswer();
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(1);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
				
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(14);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
			}
			for(int i=0;i<4*num;i++){
				CmsUserCnAnswer cmsUserCnAnswer = new CmsUserCnAnswer();
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(2);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
				
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(13);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
			}
			for(int i=0;i<5*num;i++){
				CmsUserCnAnswer cmsUserCnAnswer = new CmsUserCnAnswer();
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(3);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
				
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(12);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
			}
			for(int i=0;i<6*num;i++){
				CmsUserCnAnswer cmsUserCnAnswer = new CmsUserCnAnswer();
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(4);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
				
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(11);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
			}
			for(int i=0;i<7*num;i++){
				CmsUserCnAnswer cmsUserCnAnswer = new CmsUserCnAnswer();
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(5);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
				
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(10);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
			}
			for(int i=0;i<10*num;i++){
				CmsUserCnAnswer cmsUserCnAnswer = new CmsUserCnAnswer();
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(6);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
				
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(9);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
			}
			for(int i=0;i<13*num;i++){
				CmsUserCnAnswer cmsUserCnAnswer = new CmsUserCnAnswer();
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(7);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
				
				cmsUserCnAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserCnAnswer.setUserScore(8);
				cmsUserCnAnswer.setCreateTime(new Date());
				userCnAnswerMapper.insert(cmsUserCnAnswer);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "500";
		}
		return "200";
	}
}
