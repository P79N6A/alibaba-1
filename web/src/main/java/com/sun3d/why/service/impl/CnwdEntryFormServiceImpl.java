package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.aliyuncs.exceptions.ClientException;
import com.culturecloud.utils.SmsUtil;
import com.culturecloud.utils.ali.video.AliOssVideo;
import com.sun3d.why.dao.CnwdEntryFormMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.cnwd.CnwdEntryForm;
import com.sun3d.why.service.CnwdEntryFormService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CnwdEntryFormServiceImpl implements CnwdEntryFormService {
	
	@Autowired
	private CnwdEntryFormMapper cnwdEntryFormMapper;

	@Override
	public int addCnwdEntryForm(String userId) {
		int rs = 0;
			CnwdEntryForm cnwdEntryForm1 = new CnwdEntryForm();
			cnwdEntryForm1.setEntryId(UUIDUtils.createUUId());
			cnwdEntryForm1.setCreateUser(userId);
			cnwdEntryForm1.setCreateTime(new Date());
			cnwdEntryForm1.setCheckStatus(0);
			rs = this.cnwdEntryFormMapper.insert(cnwdEntryForm1);
		return rs;
	}

	@Override
	public Map<String, Object> addCnwdEntryFormOne(CnwdEntryForm cnwdEntryForm,
			String entryId) {
		Map<String, Object> map = new HashMap<String, Object>();
		CnwdEntryForm entryForm = this.cnwdEntryFormMapper.selectByPrimaryKey(entryId);

		if(entryForm != null){
			if(StringUtils.isEmpty(entryForm.getCreateUser())){
				map.put("msg", "login");
				return map;
			}
			entryForm.setAgencyName(cnwdEntryForm.getAgencyName());
			entryForm.setAgencyType(cnwdEntryForm.getAgencyType());
			entryForm.setTeamName(cnwdEntryForm.getTeamName());
			entryForm.setLeaderName(cnwdEntryForm.getLeaderName());
			entryForm.setDateOfEstablishment(cnwdEntryForm.getDateOfEstablishment());
			entryForm.setMemberNumber(cnwdEntryForm.getMemberNumber());
			entryForm.setAvgAge(cnwdEntryForm.getAvgAge());
			entryForm.setTelephone(cnwdEntryForm.getTelephone());
			entryForm.setEmail(cnwdEntryForm.getEmail());
			entryForm.setFaxaphone(cnwdEntryForm.getFaxaphone());
			entryForm.setAddress(cnwdEntryForm.getAddress());
			entryForm.setTeamProfile(cnwdEntryForm.getTeamProfile());
			entryForm.setUpdateTime(new Date());
			entryForm.setUpdateUser(entryForm.getCreateUser());
			this.cnwdEntryFormMapper.updateByPrimaryKeySelective(entryForm);
			map.put("msg", "ok");
		}
		return map;
	}

	@Override
	public Map<String, Object> addCnwdEntryFormTwo(CnwdEntryForm cnwdEntryForm,
			String entryId) {
		Map<String, Object> map = new HashMap<String, Object>();
		CnwdEntryForm entryForm = this.cnwdEntryFormMapper.selectByPrimaryKey(entryId);
		if(entryForm != null){
			String videoVideoUrl=cnwdEntryForm.getVideoUrl();
			String videoVideoUrlOld=entryForm.getVideoUrl();
			
			if(!StringUtils.isEmpty(videoVideoUrl)&&!videoVideoUrl.equals(videoVideoUrlOld)){
				
				int index=videoVideoUrl.lastIndexOf("/");
				int index2=videoVideoUrl.lastIndexOf(".");
				
				final String videoUrl=videoVideoUrl.substring(0, index+1);
				
				final String videoName=videoVideoUrl.substring(index+1, videoVideoUrl.length());
				
				int index3=videoName.lastIndexOf(".");
				
				final String videoNewName=videoName.substring(0,index3);
				
				 
				 //删除缓存
	            Runnable runnable = new Runnable() {
	                @Override
	                public void run() {
	                	
	                	try {
	                		AliOssVideo.transvideo("cnwd", videoName, videoNewName+".mp4");
	        			} catch (ClientException e) {
	        				e.printStackTrace();
	        			}
	                }
	            };
	            Thread thread = new Thread(runnable);
	            thread.start();
				
	            cnwdEntryForm.setVideoUrl(videoUrl+videoNewName+".mp4");
			}
			if(StringUtils.isEmpty(entryForm.getCreateUser())){
				map.put("msg", "login");
				return map;
			}
			if(!StringUtils.isEmpty(cnwdEntryForm.getDanceType())){
				entryForm.setMatchType(cnwdEntryForm.getDanceType());
			}else {
				entryForm.setMatchType(cnwdEntryForm.getMatchType());
			}
			entryForm.setProgramName(cnwdEntryForm.getProgramName());
			entryForm.setProgramDuration(cnwdEntryForm.getProgramDuration());
			entryForm.setProducerAndId(cnwdEntryForm.getProducerAndId());
			entryForm.setParticipatingNumber(cnwdEntryForm.getParticipatingNumber());
			entryForm.setVideoUrl(cnwdEntryForm.getVideoUrl());
			entryForm.setVideoCoverImg(cnwdEntryForm.getVideoCoverImg());
			entryForm.setCheckStatus(1);
			entryForm.setUpdateTime(new Date());
			entryForm.setUpdateUser(entryForm.getCreateUser());
			this.cnwdEntryFormMapper.updateByPrimaryKeySelective(entryForm);
			map.put("msg", "ok");
		}
		return map;
	}

	@Override
	public CnwdEntryForm queryCnwdEntryFormById(String entryId) {
		return this.cnwdEntryFormMapper.selectByPrimaryKey(entryId);
	}
	@Override
	public List<CnwdEntryForm> queryCnwdEntryformListByAdminCondition(
			CnwdEntryForm cnwdEntryform, Pagination page, SysUser sysUser) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 节目名称
		if (cnwdEntryform != null && !StringUtils.isEmpty(cnwdEntryform.getProgramName())) {
			map.put("programName", "%" + cnwdEntryform.getProgramName() + "%");
		}
		//团队名称
		if (cnwdEntryform != null && !StringUtils.isEmpty(cnwdEntryform.getTeamName())) {
			map.put("teamName", "%" + cnwdEntryform.getTeamName() + "%");
		}
		//参赛类别
		if (cnwdEntryform != null && !StringUtils.isEmpty(cnwdEntryform.getMatchType())) {
			map.put("matchType",cnwdEntryform.getMatchType());
		}
		//状态
		if (cnwdEntryform != null && cnwdEntryform.getCheckStatus()!=null) {
			map.put("checkStatus",cnwdEntryform.getCheckStatus());
		}
		//编号
		if (cnwdEntryform != null && cnwdEntryform.getEntryIndex()!=null) {
			map.put("entryIndex",cnwdEntryform.getEntryIndex());
		}
		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = cnwdEntryFormMapper.queryCnwdEntryformCountByCondition(map);
			page.setTotal(total);
		}
		return cnwdEntryFormMapper.queryCnwdEntryformListByCondition(map);
	}
	@Override
	public CnwdEntryForm selectByPrimaryKey(String entryId) {
		return cnwdEntryFormMapper.selectByPrimaryKey(entryId);
	}
	@Override
	public int checkCnwdEntryform(CnwdEntryForm cnwdEntryform) {
		return cnwdEntryFormMapper.updateByPrimaryKeySelective(cnwdEntryform);
	}

	@Override
	public CnwdEntryForm queryEntryFormBycreateUser(String createUser) {
		CnwdEntryForm cnwdEntryForm=new CnwdEntryForm();
		cnwdEntryForm.setCreateUser(createUser);
		return cnwdEntryFormMapper.queryEntryFormBycreateUser(cnwdEntryForm);
	}

	@Override
	public String sendMessage(CnwdEntryForm cnwdEntryForm) {
		if(StringUtils.isEmpty(cnwdEntryForm.getTelephone())){
			return "failure";
		}
		Map<String, Object> map =new HashMap<String, Object>();
		map.put("teamName", cnwdEntryForm.getTeamName());
		map.put("programName",cnwdEntryForm.getProgramName());
	    SmsUtil.cnwdSendMessage(cnwdEntryForm.getTelephone(),map);
		return "success";
	}
	
	
}
