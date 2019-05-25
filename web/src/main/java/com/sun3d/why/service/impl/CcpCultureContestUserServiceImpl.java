package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.culture.CcpCultureContestAnswer;
import com.culturecloud.model.bean.culture.CcpCultureContestUser;
import com.sun3d.why.dao.CcpCultureContestAnswerMapper;
import com.sun3d.why.dao.CcpCultureContestUserMapper;
import com.sun3d.why.service.CcpCultureContestUserService;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CcpCultureContestUserServiceImpl implements CcpCultureContestUserService {

	@Autowired
	private CcpCultureContestUserMapper cultureContestUserMapper;
	
	@Autowired
	private CcpCultureContestAnswerMapper cultureContestAnswerMapper;

	@Override
	public CcpCultureContestUser queryUserInfo(String userId) {

		return cultureContestUserMapper.queryCultureContestUserByUser(userId);
	}

	@Override
	public Map<String, String> saveUserInfo(CcpCultureContestUser user) {


			Map<String, String> result = new HashMap<>();

			String cultureUserId = user.getCultureUserId();

			if (StringUtils.isNotBlank(cultureUserId)) {

			 cultureContestUserMapper.updateByPrimaryKeySelective(user);
			} else {
				
				cultureUserId=UUIDUtils.createUUId();

				user.setCultureUserId(cultureUserId);
				user.setUserCreateTime(new Date());

				int i =cultureContestUserMapper.insert(user);
				
				if(i>0){
					
					for (int j = 1; j <4; j++) {
						
						for (int j2 = 0; j2 < 3; j2++) {
						
							CcpCultureContestAnswer answer=new CcpCultureContestAnswer();
							
							answer.setCultureAnswerId(UUIDUtils.createUUId());
							answer.setCultureUserId(cultureUserId);
							answer.setAnswerCreateTime(new Date());
							answer.setAnswerRightNumber(0);
							answer.setAnswerStatus(0);
							answer.setStageNumber(j);
							answer.setUserGroupType(user.getUserGroupType());
							
							cultureContestAnswerMapper.insert(answer);
						
						}
					}
				}
				else
				{
					result.put("result", "error");
				}
			}

			result.put("result", "success");
			result.put("cultureUserId", user.getCultureUserId());

		

		return result;
	}

	@Override
	public CcpCultureContestUser queryUserInfoById(String cultureUserId) {
		return cultureContestUserMapper.selectByPrimaryKey(cultureUserId);
	}

}
