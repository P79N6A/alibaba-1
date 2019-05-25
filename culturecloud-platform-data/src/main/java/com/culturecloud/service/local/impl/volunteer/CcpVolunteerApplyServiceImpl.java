package com.culturecloud.service.local.impl.volunteer;

import com.culturecloud.dao.volunteer.CcpVolunteerApplyMapper;
import com.culturecloud.dao.volunteer.CcpVolunteerApplyPicMapper;
import com.culturecloud.dao.volunteer.CcpVolunteerRecruitMapper;
import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;
import com.culturecloud.model.bean.volunteer.CcpVolunteerApplyPic;
import com.culturecloud.model.bean.volunteer.CcpVolunteerRecruit;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.volunteer.CcpVolunteerApplyService;
import com.culturecloud.utils.Constant;
import com.culturecloud.utils.SmsUtil;
import com.culturecloud.utils.UUIDUtils;
import com.taobao.api.ApiException;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
@Transactional
public class CcpVolunteerApplyServiceImpl implements CcpVolunteerApplyService{
	
	@Resource
	private CcpVolunteerApplyMapper ccpVolunteerApplyMapper;
	@Resource
	private CcpVolunteerApplyPicMapper ccpVolunteerApplyPicMapper;
	@Resource
	private CcpVolunteerRecruitMapper ccpVolunteerRecruitMapper;
	@Resource
    private BaseService baseService; 

	@Override
	public void saveVolunteerApply(CcpVolunteerApply ccpVolunteerApply, String[] volunteerApplyPic) {
		
		
		String userId=ccpVolunteerApply.getUserId();
		String recruitId=ccpVolunteerApply.getRecruitId();
		
		CcpVolunteerApply model=new CcpVolunteerApply();
		model.setUserId(userId);
		model.setRecruitId(recruitId);
		
		CcpVolunteerApply newCcpVolunteerApply=new CcpVolunteerApply();
		
		List<CcpVolunteerApply> applyList=baseService.findByModel(model);
		
		if(applyList.size()>0)
		{
			newCcpVolunteerApply=applyList.get(0);
			
			newCcpVolunteerApply.setApplyDateTime(new Date());
			newCcpVolunteerApply.setVolunteerRealName(ccpVolunteerApply.getVolunteerRealName());
			newCcpVolunteerApply.setUserName(ccpVolunteerApply.getUserName());
			newCcpVolunteerApply.setVolunteerAge(ccpVolunteerApply.getVolunteerAge());
			newCcpVolunteerApply.setVolunteerSex(ccpVolunteerApply.getVolunteerSex());
			newCcpVolunteerApply.setVolunteerIntroduction(ccpVolunteerApply.getVolunteerIntroduction());
			newCcpVolunteerApply.setVolunteerDegree(ccpVolunteerApply.getVolunteerDegree());
			newCcpVolunteerApply.setVolunteerMobile(ccpVolunteerApply.getVolunteerMobile());
			
			ccpVolunteerApplyMapper.updateByPrimaryKey(newCcpVolunteerApply);
		}
		else
		{
			newCcpVolunteerApply=ccpVolunteerApply;
			newCcpVolunteerApply.setApplyDateTime(new Date());
			newCcpVolunteerApply.setApplyStatus(0);
			newCcpVolunteerApply.setVolunteerApplyId(UUIDUtils.createUUId());
			
			if(ccpVolunteerApplyMapper.insert(newCcpVolunteerApply)>0)
			{
				CcpVolunteerRecruit recruit=ccpVolunteerRecruitMapper.selectByPrimaryKey(recruitId);
				
				String templateCode="";
				
				if(recruit.getRecruitName().indexOf("体验师")>-1){
					
					templateCode="SMS_29180040";
				}
				else
					templateCode="SMS_29365073";
				
				AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
				req.setExtend(ccpVolunteerApply.getVolunteerMobile());
				req.setSmsType("normal");
				req.setSmsFreeSignName(Constant.PRODUCT);
				req.setSmsTemplateCode(templateCode);
			//	req.setSmsParamString();
				req.setRecNum(ccpVolunteerApply.getVolunteerMobile());
				
				try {
					SmsUtil.getALiClient().execute(req);
				} catch (ApiException e) {
					e.printStackTrace();
				}
			}	
		}
		
		String applyId=newCcpVolunteerApply.getVolunteerApplyId();
		
		ccpVolunteerApplyPicMapper.deleteVolunteerApplyAllPic(applyId);
		
		if(volunteerApplyPic!=null&&volunteerApplyPic.length>0)
		{
			for (String applyPic : volunteerApplyPic) {
				
				CcpVolunteerApplyPic pic=new CcpVolunteerApplyPic();
				
				pic.setVolunteerApplyPicId(UUIDUtils.createUUId());
				pic.setVolunteerApplyId(applyId);
				
				 int index=applyPic.indexOf("front");
  	             String url = applyPic.substring(index,applyPic.length());
  	             
  	             pic.setApplyPicUrl(url);
				
				ccpVolunteerApplyPicMapper.insert(pic);
			}
		}
		
	}

}
