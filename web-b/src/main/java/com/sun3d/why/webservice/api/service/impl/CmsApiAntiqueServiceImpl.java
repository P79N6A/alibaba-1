/*
@author lijing
@version 1.0 2015年8月4日 下午3:51:11
馆藏添加，删除，修改，校验服务
*/
package com.sun3d.why.webservice.api.service.impl;

import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsAntiqueService;
import com.sun3d.why.service.CmsAntiqueTypeService;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiFile;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.service.CmsApiAntiqueService;
import com.sun3d.why.webservice.api.service.CmsApiAttachmenetService;
import com.sun3d.why.webservice.api.service.CmsApiService;
import com.sun3d.why.webservice.api.service.CmsApiTagsService;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.CmsApiUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
@Service
@Transactional
public class CmsApiAntiqueServiceImpl implements CmsApiAntiqueService{
	@Autowired
	private CmsApiService cmsApiService;
	@Autowired
	private CmsAntiqueService cmsAntiqueService;
	@Autowired
	private CmsUserService cmsUserService;
	/*@Autowired
	private CmsVenueService cmsVenueService;
	*/@Autowired
	private CmsApiTagsService cmsApiTagsService;
	@Autowired
	private CmsApiAttachmenetService cmsApiAttachmenetService;

	@Autowired
	private CmsAntiqueTypeService cmsAntiqueTypeService;

	@Override
	public CmsApiMessage save(CmsApiData<CmsAntique> apiData) throws Exception {
		CmsApiMessage msg=this.check(apiData);
		boolean bool=msg.getStatus();
		if (bool) {			
			String token=apiData.getToken();
			String userName=TokenHelper.getUserName(token);
			String sysNo=apiData.getSysno();
			CmsAntique model = apiData.getData();
			//获取朝代dict_id
			String dictId = this.cmsApiService.checkSysDictByChildName("DYNASTY", model.getAntiqueYears());
			model.setAntiqueYears(dictId);
			
			//判断馆藏是否存在
			String queryId=this.cmsApiService.queryAntiqueBySysId(model.getSysId(),sysNo);
			if(queryId!=null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText(model.getSysId()+" 该藏品在系统已经存在!");
				return msg;
			}
			//判断场所数据是否存在
			String venueId=this.cmsApiService.queryVenueBySysId(model.getVenueId(),sysNo);
			if(venueId==null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.VENUE_ERROR);
				msg.setText(model.getVenueId()+" 该场所在系统中不存在!");
				return msg;
			}
			model.setVenueId(venueId);
			SysUser queryUser = new SysUser();
			queryUser.setUserAccount(userName);
		    List<SysUser> userList=this.cmsUserService.querySysUserByCondition(queryUser);
		    if(userList.size()>0){
		    	SysUser sysUser=userList.get(0);
		    	
		    	//上传图片，到文化云系统
		    	String strUrl=model.getAntiqueImgUrl();
		    	CmsApiFile apiFile=this.cmsApiAttachmenetService.checkImage(strUrl);
		    	if(apiFile.getSuccess()==0){
		    		msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.DATA_ERROR);
					msg.setText("上传图片时发生错误："+apiFile.getMsg());
					return msg;
		    	}
		    	String imageUrl=this.cmsApiAttachmenetService.uploadImage(strUrl, sysUser,"2");
		    	if(StringUtils.isNotNull(imageUrl)){
		    		model.setAntiqueImgUrl(imageUrl);
		    	}
		    	model.setAntiqueState(Constant.PUBLISH);
		    	model.setSysNo(apiData.getSysno());
		    	
		    	int success=cmsAntiqueService.addCmsAntique(model, sysUser);
				if(success>0){
					msg.setStatus(true);
					msg.setCode(-1);
					msg.setText(model.getAntiqueName()+" 添加成功!");
				}
				else{
					msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.ERROR);
					msg.setText("添加失败!,未知错误");
				
				}
				
			}
		    else{
		    	msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.USER_ERROR);
				msg.setText(userName+" 用户不存在");
				return msg;
		    }
		}
		return msg;
	}

	private CmsApiMessage check(CmsApiData<CmsAntique> apiData) throws Exception {
		CmsApiMessage msg=new CmsApiMessage();
		String sysNo=apiData.getSysno();
		String token=apiData.getToken();
		
		msg=CmsApiUtil.checkToken(sysNo, token);
		if(msg.getStatus()){
			CmsAntique model=apiData.getData();
			if(model==null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("数据不能为空");
				return msg;
			}
			if(StringUtils.isNull(model.getSysId())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场所id不能为空");
				return msg;
			}
			if(StringUtils.isNull(model.getVenueId())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场所id不能为空");
				return msg;
			}
			//判断场所数据是否存在
			/*CmsVenue venue=this.cmsVenueService.queryVenueById(model.getVenueId());
			if(venue==null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText(model.getVenueId()+" 该场所在系统中不存在!");
				return msg;
			}
			*/
			if(StringUtils.isNull(model.getAntiqueName())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("藏品名称不能为空");
				return msg;
			}
			
			if(StringUtils.isNull(model.getAntiqueImgUrl())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("藏品图片不能为空");
				return msg;
			}
			
			if(StringUtils.isNull(model.getAntiqueImgUrl())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("藏品图片不能为空");
				return msg;
			}
			
//			if(StringUtils.isNull(model.getAntiqueVenueId())){
//				msg.setStatus(false);
//				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//				msg.setText("藏品类别不能为空");
//				return msg;
//			}
			boolean tbool=this.cmsApiTagsService.checkDictMood(model.getAntiqueTypeId(), "ANTIQUE");
//			if(tbool==false){
//				msg.setStatus(false);
//				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//				msg.setText("藏品类别不存在");
//				return msg;
//			}
			
			if(StringUtils.isNull(model.getAntiqueYears())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("藏品朝代不能为空");
				return msg;
			}
			
			tbool=this.cmsApiTagsService.checkDictMood(model.getAntiqueYears(), "DYNASTY");

			if(tbool==false){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("藏品朝代在系统中不存在");
				return msg;
			}
			if(StringUtils.isNull(model.getAntiqueRemark())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("产品简介不能为空");
				return msg;
			}
			if(StringUtils.isNull(model.getSysId())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("系统ID不能为空");
				return msg;
			}
			
		}
		
		return msg;
	}

	@Override
	public CmsApiMessage update(CmsApiData<CmsAntique> apiData) throws Exception {
		CmsApiMessage msg=this.check(apiData);
		boolean bool=msg.getStatus();
		if (bool) {
			String token=apiData.getToken();
			String userName=TokenHelper.getUserName(token);
			String sysNo=apiData.getSysno();
			CmsAntique model = apiData.getData();
			String sysId=model.getSysId();
			if(StringUtils.isNull(sysId)){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.ERROR);
				msg.setText("添加失败!,sysId不能为空!");
				return msg;
			}
			
			//判断馆藏数据是否存在
			String queryId=this.cmsApiService.queryAntiqueBySysId(model.getSysId(),sysNo);
			if(queryId==null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.ANTIQUE_ERROR);
				msg.setText(model.getSysId()+" 该藏品在系统不存在，无法更新!");
				return msg;
			}
			model.setAntiqueId(queryId);
			
			//判断场所数据是否存在
			String venueId=this.cmsApiService.queryVenueBySysId(model.getVenueId(),sysNo);
			if(venueId==null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText(model.getVenueId()+" 该场所在系统中不存在!");
				return msg;
			}
			model.setVenueId(venueId);
			
			SysUser queryUser = new SysUser();
			queryUser.setUserAccount(userName);
		    List<SysUser> userList=this.cmsUserService.querySysUserByCondition(queryUser);
		    if(userList.size()>0){
		    	
		    	CmsAntique queryModel=this.cmsAntiqueService.queryCmsAntiqueById(queryId);
		    	if(queryModel!=null){
		    		SysUser sysUser=userList.get(0);
			    	model.setAntiqueState(Constant.PUBLISH);
			    	
			    	//上传图片，到文化云系统
			    	String strUrl=model.getAntiqueImgUrl();
			    	CmsApiFile apiFile=this.cmsApiAttachmenetService.checkImage(strUrl);
			    	if(apiFile.getSuccess()==0){
			    		msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.DATA_ERROR);
						msg.setText("上传图片时发生错误："+apiFile.getMsg());
						return msg;
			    	}
			    	String imageUrl=this.cmsApiAttachmenetService.uploadImage(strUrl, sysUser,"2");
			    	if(StringUtils.isNotNull(imageUrl)){
			    		model.setAntiqueImgUrl(imageUrl);
			    	}
			    	
			    	int success=this.cmsAntiqueService.editCmsAntique(model, sysUser);
					if(success>0){
						msg.setStatus(true);
						msg.setCode(-1);
						msg.setText(model.getAntiqueName()+"  馆藏修改成功!");
					}
					else{
						msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.ERROR);
						msg.setText("添加失败!,未知错误");
					
					}
		    	}
		    	else{
		    		msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.ERROR);
					msg.setText("系统没有此数据不能修改");
		    	}
		    	
				
			}
		    else{
		    	msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.USER_ERROR);
				msg.setText(userName+" 用户不存在");
				return msg;
		    }
		}
		return msg;
	}

	@Override
	public CmsApiMessage delete(CmsApiData<CmsAntique> apiData) throws Exception {
		CmsApiMessage msg=new CmsApiMessage();
		String sysNo=apiData.getSysno();
		String token=apiData.getToken();
		String sysId=apiData.getId();
		msg=CmsApiUtil.checkToken(sysNo, token);
		if(msg.getStatus()){
			String userName=TokenHelper.getUserName(token);
			if(StringUtils.isNull(sysId)){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.ERROR);
				msg.setText("id参数不能为空");
			}
			SysUser queryUser = new SysUser();
			queryUser.setUserAccount(userName);
		    List<SysUser> userList=this.cmsUserService.querySysUserByCondition(queryUser);
		    if(userList.size()>0){
		    	SysUser sysUser=userList.get(0);
		    	String modelId=this.cmsApiService.queryAntiqueBySysId(sysId,sysNo);
		    	if(StringUtils.isNotNull(modelId)){
		    		CmsAntique model=this.cmsAntiqueService.queryCmsAntiqueById(modelId);
		    		int success=this.cmsAntiqueService.deleteCmsAntique(model, sysUser);
		    		if(success>0){
						msg.setStatus(true);
						msg.setCode(-1);
						msg.setText(modelId+" 馆藏删除成功!");
					}
					else{
						msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.ANTIQUE_ERROR);
						msg.setText("添加失败!,未知错误");
					
					}
		    	}
		    	else{
					msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.ERROR);
					msg.setText(sysId+" 数据不存在");
				
				}
		    	
				
			}
		    else{
		    	msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.USER_ERROR);
				msg.setText(userName+" 用户不存在");
				return msg;
		    }
		}
		return msg;
	}

}

