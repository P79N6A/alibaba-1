package com.sun3d.why.service.impl;

import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.CmsUserAnswerMapper;
import com.sun3d.why.model.CmsUserAnswer;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsUserAnswerService;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;

@Service
@Transactional(rollbackFor = Exception.class)
public class CmsUserAnswerServiceImpl implements CmsUserAnswerService {

    private Logger logger = LoggerFactory.getLogger(CmsUserAnswerServiceImpl.class);

    @Autowired
    private CmsUserAnswerMapper userAnswerMapper;
    
    @Autowired
    private CmsTerminalUserMapper cmsTerminalUserMapper;
    
    @Autowired
    private StaticServer staticServer;
    
	@Override
	public String saveOrUpdateAnswer(CmsUserAnswer record) {
		int result = 1;
		try {
			CmsUserAnswer cmsUserAnswer = userAnswerMapper.selectByCondition(record);
			if(cmsUserAnswer!=null){
				if(record.getUserScore()!=null||record.getUserName()!=null||record.getUserMobile()!=null||record.getUserEmail()!=null){
					record.setUserAnswerId(cmsUserAnswer.getUserAnswerId());
					result = userAnswerMapper.update(record);
					
					// 加积分
					if(StringUtils.isNotBlank(record.getUserName())&&StringUtils.isNotBlank(record.getUserMobile())){
						
						UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
		        		userIntegralDetail.setIntegralChange(500);
		        		userIntegralDetail.setChangeType(0);
		        		userIntegralDetail.setIntegralFrom("文化竞赛，topicId="+cmsUserAnswer.getAnswerType());
		        		userIntegralDetail.setIntegralType(IntegralTypeEnum.CONTEST_QUIZ_TOPIC_COMPLETE.getIndex());
		        		userIntegralDetail.setUserId(cmsUserAnswer.getUserId());
		        		userIntegralDetail.setUpdateType(1);
						
						HttpClientConnection.post(staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
					}
					
					JSONObject json=new JSONObject();
					json.put("userId", record.getUserId());
					json.put("userNickName", record.getUserName());
					json.put("userTelephone", record.getUserMobile());
					HttpClientConnection.post(staticServer.getChinaServerUrl() + "wechatUser/editTerminalUserByJson.do", json);
				}
			}else{
				record.setUserAnswerId(UUIDUtils.createUUId());
				record.setCreateTime(new Date());
				record.setUserScore(0);
				result = userAnswerMapper.insert(record);
			}
			if(result == 1){
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
	public CmsUserAnswer statisticsAnswer(CmsUserAnswer record) {
		CmsUserAnswer result = null;
    	try {
			result = userAnswerMapper.statisticsAnswer(record);
			result.setProportion(result.getProportion()!=null?result.getProportion():0);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return result;
	}

	@Override
	public CmsUserAnswer queryUserInfo(CmsUserAnswer record) {
		CmsUserAnswer result = null;
    	try {
			result = userAnswerMapper.selectByCondition(record);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return result;
	}

	@Override
	public String saveAnswerData(Integer num,String type) {
		try {
			for(int i=0;i<2*num;i++){
				CmsUserAnswer cmsUserAnswer = new CmsUserAnswer();
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(0);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
				
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(15);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
			}
			for(int i=0;i<3*num;i++){
				CmsUserAnswer cmsUserAnswer = new CmsUserAnswer();
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserScore(1);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
				
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(14);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
			}
			for(int i=0;i<4*num;i++){
				CmsUserAnswer cmsUserAnswer = new CmsUserAnswer();
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(2);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
				
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(13);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
			}
			for(int i=0;i<5*num;i++){
				CmsUserAnswer cmsUserAnswer = new CmsUserAnswer();
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(3);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
				
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(12);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
			}
			for(int i=0;i<6*num;i++){
				CmsUserAnswer cmsUserAnswer = new CmsUserAnswer();
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(4);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
				
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(11);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
			}
			for(int i=0;i<7*num;i++){
				CmsUserAnswer cmsUserAnswer = new CmsUserAnswer();
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(5);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
				
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(10);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
			}
			for(int i=0;i<10*num;i++){
				CmsUserAnswer cmsUserAnswer = new CmsUserAnswer();
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(6);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
				
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(9);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
			}
			for(int i=0;i<13*num;i++){
				CmsUserAnswer cmsUserAnswer = new CmsUserAnswer();
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(7);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
				
				cmsUserAnswer.setUserAnswerId(UUIDUtils.createUUId());
				cmsUserAnswer.setAnswerType(type);
				cmsUserAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserAnswer.setUserScore(8);
				cmsUserAnswer.setCreateTime(new Date());
				userAnswerMapper.insert(cmsUserAnswer);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "500";
		}
		return "200";
	}
}
