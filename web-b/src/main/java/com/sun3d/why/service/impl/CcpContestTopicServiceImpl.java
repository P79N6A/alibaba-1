package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.contest.CcpContestTemplate;
import com.culturecloud.model.bean.contest.CcpContestTopic;
import com.culturecloud.model.bean.contest.CcpContestTopicPass;
import com.sun3d.why.dao.CcpContestTemplateMapper;
import com.sun3d.why.dao.CcpContestTopicMapper;
import com.sun3d.why.dao.CcpContestTopicPassMapper;
import com.sun3d.why.dao.dto.CcpContestTopicDto;
import com.sun3d.why.enumeration.contest.CcpContestTopicIsLevelEnum;
import com.sun3d.why.enumeration.contest.CcpContestTopicStatusEnum;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpContestTopicService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CcpContestTopicServiceImpl implements CcpContestTopicService {
	
	@Autowired
	private CcpContestTopicMapper contestTopicMappper;
	@Autowired
	private CcpContestTopicPassMapper contestTopicPassMapper;
	
	@Autowired
	private CcpContestTemplateMapper contestTemplateMappper;
 
	@Override 
	public List<CcpContestTopicDto> queryCcpContestTopic(CcpContestTopic contestTopic, Pagination page) {
		 
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(StringUtils.isNotBlank(contestTopic.getTopicName())){
			map.put("topicName", contestTopic.getTopicName());
		}
		
		if(contestTopic.getCreateSysUserId()!=null){
			map.put("createSysUserId", contestTopic.getCreateSysUserId());
		}
		
		if(contestTopic.getTopicStatus()!=null){
			map.put("topicStatus", contestTopic.getTopicStatus());
		}
		
		  //分页
       if (page != null && page.getFirstResult() != null && page.getRows() != null) {
	     map.put("firstResult", page.getFirstResult());
         map.put("rows", page.getRows());
       //  int total = contestTopicMappper.queryCmsActivityCountByCondition(map);
         int total = contestTopicMappper.queryContestTopicCountByCondition(map);
         page.setTotal(total);
       }
       
       List<CcpContestTopicDto>contestTopicList=contestTopicMappper.queryCcpContestTopicByCondition(map);
		
		return contestTopicList;
	}

	@Override
	public int saveContestTopic(CcpContestTopic contestTopic,Integer[] passNumber,String []passName, SysUser user) {

		int result=0;
		
		String topicId=contestTopic.getTopicId();
		
		if(StringUtils.isBlank(topicId))
		{
			contestTopic.setTopicId(UUIDUtils.createUUId());
			contestTopic.setCreateSysUserId(user.getUserId());
			contestTopic.setCreateTime(new Date());
			contestTopic.setTopicStatus(CcpContestTopicStatusEnum.TOPIC_STATUS_DOWN.getValue());
			contestTopic.setUpdateSysUserId(user.getUserId());
			contestTopic.setUpdateTime(new Date());
			
			result=contestTopicMappper.insert(contestTopic);
			if(result>0){
				
				this.saveContestTopicPass(contestTopic, passNumber, passName);
			}
		}
		else
		{
			contestTopic.setUpdateSysUserId(user.getUserId());
			contestTopic.setUpdateTime(new Date());
			
			result=contestTopicMappper.updateByPrimaryKeySelective(contestTopic);
			
			this.saveContestTopicPass(contestTopic, passNumber, passName);
		}
		
		return result;
	}
	
	
	private int saveContestTopicPass(CcpContestTopic contestTopic,Integer[] passNumbers,String []passNames){
		
		int result=0;
		
		// 查询已经有的过关集合
		List<CcpContestTopicPass> passList=contestTopicPassMapper.queryByTopicId(contestTopic.getTopicId());
		
		for (CcpContestTopicPass ccpContestTopicPass : passList) {
			contestTopicPassMapper.deleteByPrimaryKey(ccpContestTopicPass.getTopicPassId());
		}

		if(contestTopic.getIsLevelup().intValue()==CcpContestTopicIsLevelEnum.IS_LEVELUP_YES.getValue()&&ArrayUtils.isNotEmpty(passNumbers)&&ArrayUtils.isNotEmpty(passNames)){
			
			for (int i = 0; i < passNumbers.length; i++) {
				
				Integer passNumber=passNumbers[i];
				String passName=passNames[i];
				
				if(passNumber==null&&StringUtils.isBlank(passName))
					continue;
				
				CcpContestTopicPass pass=new CcpContestTopicPass();
				pass.setTopicId(contestTopic.getTopicId());
				pass.setPassName(passName);
				pass.setPassNumber(passNumber);
				pass.setTopicPassId(UUIDUtils.createUUId());
				
				result=contestTopicPassMapper.insert(pass);
			}
			
		}
		
		return result;
	}

	@Override
	public int topicStatusChange(String topicId, SysUser user) {

		CcpContestTopic topic=contestTopicMappper.selectByPrimaryKey(topicId);
		
		Integer topicStatus=topic.getTopicStatus();
		
		if(CcpContestTopicStatusEnum.TOPIC_STATUS_DOWN.getValue()==topicStatus)
			topic.setTopicStatus(CcpContestTopicStatusEnum.TOPIC_STATUS_UP.getValue());
		else 
			topic.setTopicStatus(CcpContestTopicStatusEnum.TOPIC_STATUS_DOWN.getValue());
		topic.setUpdateSysUserId(user.getUserId());
		topic.setUpdateTime(new Date());
		
		return contestTopicMappper.updateByPrimaryKeySelective(topic);
	} 

	@Override
	public CcpContestTopic queryCcpContestTopicById(String topicId) {
		return contestTopicMappper.selectByPrimaryKey(topicId);
	}

	@Override
	public List<CcpContestTopicPass> queryCcpContestTopicPassByTopicId(String topicId) {
		
		return contestTopicPassMapper.queryByTopicId(topicId);
	}

	@Override
	public int saveContestQuiz(CcpContestTopic contestTopic,CcpContestTemplate template, SysUser user) {
		
		int result=0;
		
		String topicId=contestTopic.getTopicId();
		
				
		if(template!=null){
			
			String templateId=template.getTemplateId();
			
			if(StringUtils.isBlank(templateId)){
				
				templateId=UUIDUtils.createUUId();
				
				template.setTemplateId(templateId);
				
				template.setTemplateIsDel(1);
				template.setTemplateCreateUser(user.getUserId());
				template.setTemplateIsSystem(2);
				template.setTemplateCreateTime(new Date());
				template.setTemplateName("用户自定义");
				
				contestTemplateMappper.insert(template);
			}
			else
			{
				CcpContestTemplate ccpContestTemplate=contestTemplateMappper.selectByPrimaryKey(templateId);
				
				if(ccpContestTemplate.getTemplateIsSystem()!=null){
					
					// 已选择模板为系统模板，需要重新新建
					if(ccpContestTemplate.getTemplateIsSystem()==1){
						
						templateId=UUIDUtils.createUUId();
						
						template.setTemplateId(templateId);
						
						contestTemplateMappper.insert(template);
						
					}
					else if(ccpContestTemplate.getTemplateIsSystem()==2)
					{
						contestTemplateMappper.updateByPrimaryKeySelective(ccpContestTemplate);
					}
				}
			}
			
			contestTopic.setTemplateId(templateId);
		}
		
		if(StringUtils.isBlank(topicId))
		{
			contestTopic.setTopicId(UUIDUtils.createUUId());
			contestTopic.setCreateSysUserId(user.getUserId());
			contestTopic.setCreateTime(new Date());
			contestTopic.setUpdateSysUserId(user.getUserId());
			contestTopic.setUpdateTime(new Date());
			
			result=contestTopicMappper.insert(contestTopic);
		}
		else
		{
			contestTopic.setUpdateSysUserId(user.getUserId());
			contestTopic.setUpdateTime(new Date());
			
			result=contestTopicMappper.updateByPrimaryKeySelective(contestTopic);
			
		}
		
		return result;
	}

}
