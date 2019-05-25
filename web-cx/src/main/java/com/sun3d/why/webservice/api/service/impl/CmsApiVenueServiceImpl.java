/*
@author lijing
@version 1.0 2015年8月4日 下午3:50:56
场所添加，删除，修改，校验服务
*/

package com.sun3d.why.webservice.api.service.impl;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsDeptService;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiFile;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.service.CmsApiAttachmenetService;
import com.sun3d.why.webservice.api.service.CmsApiService;
import com.sun3d.why.webservice.api.service.CmsApiTagsService;
import com.sun3d.why.webservice.api.service.CmsApiVenueService;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.CmsApiUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CmsApiVenueServiceImpl implements CmsApiVenueService {
	private final Logger logger = LoggerFactory.getLogger(CmsApiVenueServiceImpl.class);
	
	@Autowired
	private CmsApiService cmsApiService;
	@Autowired
	private CmsVenueService cmsVenueService;
	//系统用户逻辑控制层
	@Autowired
	private CmsUserService cmsUserService;
	@Autowired
	private CmsApiTagsService cmsApiTagsService;
	@Autowired
	private CmsApiAttachmenetService cmsApiAttachmenetService;

	@Autowired
	private SysDictService sysDictService;

	@Autowired
	private CmsDeptService cmsDeptService;

	@Autowired
	private CmsVenueMapper cmsVenueMapper;

	@Override
	public CmsApiMessage save(CmsApiData<CmsVenue> apiData) throws Exception {
		CmsApiMessage msg=this.check(apiData);
		boolean bool=msg.getStatus();
		if (bool) {
			String token=apiData.getToken();
			String userName=TokenHelper.getUserName(token);
			String sysNo=apiData.getSysno();
			CmsVenue venue = apiData.getData();
			
			//判断场所数据是否存在
			String queryVenueId=this.cmsApiService.queryVenueBySysId(venue.getSysId(),sysNo);
			if(queryVenueId!=null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.VENUE_ERROR);
				msg.setText(venue.getSysId()+" 该场所在系统已经存在!");
				return msg;
			}


			Map map = new HashMap();
			map.put("deptIsFromVenue",1);
			map.put("deptName",venue.getVenueName());
			map.put("deptState",1);
//           map.put("deptParentId",venue.getVenueParentDeptId());
			int countName = cmsDeptService.queryAPICountByMap(map);
			if (countName > 0) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText(venue.getVenueName()+" 该场所名称重复!");
				return msg;
			}

//			CmsVenue cmsVenue = this.cmsVenueMapper.queryVenueByVenueName(venue.getVenueName());
//			if(null != cmsVenue){
//				msg.setStatus(false);
//				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//				msg.setText(venue.getVenueName()+" 该场所名称重复!");
//				return msg;
//			}

			SysUser queryUser = new SysUser();
			queryUser.setUserAccount(userName);
		    List<SysUser> userList=this.cmsUserService.querySysUserByCondition(queryUser);
		    if(userList.size()>0){
		    	SysUser sysUser=userList.get(0);

				if(null == venue.getVenueState() || "".equals(venue.getVenueState())){
					venue.setVenueState(Constant.PUBLISH);
				}
		    	venue.setSysNo(apiData.getSysno());
		    	//上传图片，到文化云系统
		    	String iconUrl=venue.getVenueIconUrl();
		    	
		    	CmsApiFile apiFile=this.cmsApiAttachmenetService.checkImage(iconUrl);
		    	if(apiFile.getSuccess()==0){
		    		msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.DATA_ERROR);
					msg.setText("上传图片时发生错误："+apiFile.getMsg());
					return msg;
		    	}
		    	String imageUrl=this.cmsApiAttachmenetService.uploadImage(iconUrl, sysUser,"3");
		    	if(StringUtils.isNotNull(imageUrl)){
		    		venue.setVenueIconUrl(imageUrl);
		    	}
		    	if(StringUtils.isNull(venue.getVenueMobile())){
		    		venue.setVenueMobile(venue.getVenueTel());
		    	}
		    	if(venue.getVenueIsFree()==null){
		    		venue.setVenueIsFree(1);
		    	}
		    	
		    	if(venue.getVenueHasRoom()==null){
		    		venue.setVenueHasRoom(1);
		    	}
		    	if(venue.getVenueHasAntique()==null){
		    		venue.setVenueHasAntique(1);
		    	}


				//根据传过来的类型标签的汉字查询why表中对应该的标签id，如果没有查到则设置为其他场馆标签
				String venueType = this.cmsApiService.getAPITags(venue.getVenueType(),"场馆类型");
				if(venueType == null){
					String venueTypeStr=this.cmsApiService.getAPITags("其他","场馆类型");
					venue.setVenueType(venueTypeStr);
				}else{
					venue.setVenueType(venueType);
				}

				//判断人群标签是否存在  hucheng
//				if(StringUtils.isNotNull(venue.getVenueCrowd())){
//					String venueCrowd=this.cmsApiService.getTags(venue.getVenueCrowd(),"VENUE_CROWD");
//					if(venueCrowd==null){
//						msg.setStatus(false);
//						msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//						msg.setText(venue.getVenueCrowd()+" 人群标签在系统中不存在");
//						return msg;
//					}
//
//					venue.setVenueCrowd(venueCrowd);
//				}


				//hucheng
//				if(StringUtils.isNotNull(venue.getVenueMood())){
//
//					//getVenueArea :49,长宁区   venueMood:虹桥
////					String areaLocation=this.cmsApiService.getAreaLocation(venue.getVenueArea(),venue.getVenueMood());
//					String venueArea = venue.getVenueArea();
//					String[] dictCodeAndName = venueArea.split(",");
//					String dictCode = null;
//					if(dictCodeAndName.length>0){
//						dictCode = dictCodeAndName[0];
//						String venueMood = this.cmsApiService.checkSysDictByChildName(dictCode, venue.getVenueMood());
//						if(venueMood==null){
//							msg.setStatus(false);
//							msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//							msg.setText(venue.getVenueCrowd()+" 地区标签在系统中不存在");
//							return msg;
//						}
//
//						venue.setVenueMood(venueMood);
//
//					}
//					else{
//						msg.setStatus(false);
//						msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//						msg.setText(venue.getVenueCrowd()+" 地区标签为空");
//						return msg;
//					}
//				}
		    	//venue.setVenueCrowd(CmsApiUtil.getTags(venue.getVenueCrowd()));

				//根据嘉定传过来的区域名称，来查询对应的id
				if(org.apache.commons.lang3.StringUtils.isNotBlank(venue.getVenueMood())){
					SysDict dict = sysDictService.querySysDictByDictName(venue.getVenueMood(),null);
					if(dict != null){
						venue.setVenueMood(dict.getDictId());
					}else{
						//sysNo 代表字系统的代号  1=嘉定  2 = 浦东  3 =  静安
						if("1".equals(sysNo)) {
							SysDict dictJD = sysDictService.querySysDictByDictName("其他", "jiadingquqita");
							if(null !=dictJD){
								venue.setVenueMood(dictJD.getDictId());
							}else{
								venue.setVenueMood(null);
							}

						}else if("2".equals(sysNo)){
							SysDict dictPD = sysDictService.querySysDictByDictName("其他", "pudongxinquqita");
							if(null !=dictPD){
								venue.setVenueMood(dictPD.getDictId());
							}else{
								venue.setVenueMood(null);
							}

						}else if("3".equals(sysNo)){

							SysDict dictJA = sysDictService.querySysDictByDictName("其他", "jinganquqita");
							if(null !=dictJA){
								venue.setVenueMood(dictJA.getDictId());
							}else{
								venue.setVenueMood(null);
							}
						}else{
							List<SysDict> sysDict = sysDictService.querySysDictByCode(sysNo);
							if(sysDict.size()>0){
								venue.setVenueMood(sysDict.get(0).getDictId());
							}else{
								venue.setVenueMood(null);
							}
						}
					}
				}

				//hucheng
				//sysNo 代表字系统的代号  1=嘉定  2 = 浦东  3 =  静安
				if("1".equals(sysNo)) {
					String deptNo = cmsDeptService.querySysDeptIdByDeptName("嘉定区");
					if(deptNo !=""&& deptNo!= null){
						venue.setVenueParentDeptId(deptNo);
					}
				}else if("2".equals(sysNo)){
					String deptNo = cmsDeptService.querySysDeptIdByDeptName("浦东新区");
					if(deptNo !=""&& deptNo!= null){
						venue.setVenueParentDeptId(deptNo);
					}

				}else if("3".equals(sysNo)){
					String deptNo = cmsDeptService.querySysDeptIdByDeptName("静安区");
					if(deptNo !=""&& deptNo!= null){
						venue.setVenueParentDeptId(deptNo);
					}

				}else{
					String deptNo = cmsDeptService.querySysDeptIdByDeptName("闸北区");
					if(deptNo !=""&& deptNo!= null){
						venue.setVenueParentDeptId(deptNo);
					}
				}

				//保存音频路径
				String audioUrlStr = venue.getVenueVoiceUrl();
				if(!"".equals(audioUrlStr)||null!=audioUrlStr){
					//String audioUrl=this.cmsApiAttachmenetService.uploadImage(audioUrlStr, sysUser,null);
					venue.setVenueVoiceUrl(null);
				}

		    	//保存数据到文化云系统
		    	int success=cmsVenueService.saveVenue(venue, sysUser);
				if(success>0){
					msg.setStatus(true);
					msg.setCode(-1);
					msg.setText(venue.getVenueName()+" 添加成功!");
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

	
	@Override
	public CmsApiMessage update(CmsApiData<CmsVenue> apiData) throws Exception {
		CmsApiMessage msg=this.check(apiData);
		String sysNo=apiData.getSysno();
		boolean bool=msg.getStatus();
		if (bool) {
			String token=apiData.getToken();
			String userName=TokenHelper.getUserName(token);
			
			CmsVenue model = apiData.getData();
			model.setSysNo(sysNo);
			//判断场所数据是否存在
			String queryVenueId=this.cmsApiService.queryVenueBySysId(model.getSysId(),sysNo);
//			if(StringUtils.isNull(queryVenueId)){
//				msg.setStatus(false);
//				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//				msg.setText(queryVenueId+" 该场所在系统不存在!");
//				return msg;
//			}

			//根据场馆名称查询对qj
				CmsVenue cmsVenue = this.cmsVenueMapper.queryVenueByVenueName(model.getVenueName());

				if(null != cmsVenue){
					if(!model.getSysId().equals(cmsVenue.getSysId())){
						msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.DATA_ERROR);
						msg.setText(model.getVenueName()+" 该场所名称重复!");
						return msg;
					}
				}



			SysUser queryUser = new SysUser();
			queryUser.setUserAccount(userName);
		    List<SysUser> userList=this.cmsUserService.querySysUserByCondition(queryUser);
		    if(userList.size()>0){
		    	CmsVenue queryModel=this.cmsVenueService.queryVenueById(queryVenueId);
//				if(queryModel!=null){
					SysUser sysUser=userList.get(0);

					if(null == model.getVenueState() || "".equals(model.getVenueState())){
						model.setVenueState(Constant.PUBLISH);
					}
					model.setVenueId(queryVenueId);
					
					//上传图片，到文化云系统
			    	String iconUrl=model.getVenueIconUrl();
			    	
			    	CmsApiFile apiFile=this.cmsApiAttachmenetService.checkImage(iconUrl);
			    	if(apiFile.getSuccess()==0){
			    		msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.DATA_ERROR);
						msg.setText("上传图片时发生错误："+apiFile.getMsg());
						return msg;
			    	}
			    	String imageUrl=this.cmsApiAttachmenetService.uploadImage(iconUrl, sysUser,"3");
			    	if(StringUtils.isNotNull(imageUrl)){
			    		model.setVenueIconUrl(imageUrl);
			    	}
			    	if(StringUtils.isNull(model.getVenueMobile())){
			    		model.setVenueMobile(model.getVenueTel());
			    	}
			    	
			    	if(model.getVenueIsFree()==null){
			    		model.setVenueIsFree(1);
			    	}
			    	
			    	if(model.getVenueHasRoom()==null){
			    		model.setVenueHasRoom(1);
			    	}
			    	if(model.getVenueHasAntique()==null){
			    		model.setVenueHasAntique(1);
			    	}

					//根据传过来的类型标签的汉字查询why表中对应该的标签id，如果没有查到则设置为其他场馆标签
					String venueType = this.cmsApiService.getAPITags(model.getVenueType(),"场馆类型");
					if(venueType == null){
						String venueTypeStr=this.cmsApiService.getAPITags("其他","场馆类型");
						model.setVenueType(venueTypeStr);
					}else{
						model.setVenueType(venueType);
					}


					//判断人群标签是否存在
//					if(StringUtils.isNotNull(model.getVenueCrowd())){
//						String venueCrowd=this.cmsApiService.getTags(model.getVenueCrowd(),"VENUE_CROWD");
//						if(venueCrowd==null){
//							msg.setStatus(false);
//							msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//							msg.setText(model.getVenueCrowd()+" 人群标签在系统中不存在");
//							return msg;
//						}
//
//						model.setVenueCrowd(venueCrowd);
//					}
//
//				  	model.setVenueCrowd(CmsApiUtil.getTags(model.getVenueCrowd()));
//			    	model.setVenueMood(CmsApiUtil.getTags(model.getVenueMood()));
//
					//根据嘉定传过来的区域名称，来查询对应的id
					if(org.apache.commons.lang3.StringUtils.isNotBlank(model.getVenueMood())){
						SysDict dict = sysDictService.querySysDictByDictName(model.getVenueMood(),null);
						if(dict != null){
							model.setVenueMood(dict.getDictId());
						}else{
							//sysNo 代表字系统的代号  1=嘉定  2 = 浦东  3 =  静安
							if("1".equals(sysNo)) {
								SysDict dictJD = sysDictService.querySysDictByDictName("其他", "jiadingquqita");
								if(null !=dictJD){
									model.setVenueMood(dictJD.getDictId());
								}else{
									model.setVenueMood(null);
								}

							}else if("2".equals(sysNo)){
								SysDict dictPD = sysDictService.querySysDictByDictName("其他", "pudongxinquqita");
								if(null !=dictPD){
									model.setVenueMood(dictPD.getDictId());
								}else{
									model.setVenueMood(null);
								}

							}else if("3".equals(sysNo)){
								SysDict dictJA = sysDictService.querySysDictByDictName("其他", "jinganquqita");
								if(null !=dictJA){
									model.setVenueMood(dictJA.getDictId());
								}else{
									model.setVenueMood(null);
								}
							}else{
								List<SysDict> sysDict = sysDictService.querySysDictByCode(sysNo);
								if(sysDict.size()<0){
									model.setVenueMood(sysDict.get(0).getDictId());
								}else{
									model.setVenueMood(null);
								}
							}
						}
					}

				//hucheng
				//sysNo 代表字系统的代号  1=嘉定  2 = 浦东  3 =  静安
				if("1".equals(sysNo)) {
					String deptNo = cmsDeptService.querySysDeptIdByDeptName("嘉定区");
					if(deptNo !=""&& deptNo!= null){
						model.setVenueParentDeptId(deptNo);
					}
				}else if("2".equals(sysNo)){
					String deptNo = cmsDeptService.querySysDeptIdByDeptName("浦东新区");
					if(deptNo !=""&& deptNo!= null){
						model.setVenueParentDeptId(deptNo);
					}

				}else if("3".equals(sysNo)){
					String deptNo = cmsDeptService.querySysDeptIdByDeptName("静安区");
					if(deptNo !=""&& deptNo!= null){
						model.setVenueParentDeptId(deptNo);
					}
				}else{
					String deptNo = cmsDeptService.querySysDeptIdByDeptName("闸北区");
					if(deptNo !=""&& deptNo!= null){
						model.setVenueParentDeptId(deptNo);
					}
				}
				//保存音频路径
					String audioUrlStr = model.getVenueVoiceUrl();
					if(!"".equals(audioUrlStr)||null!=audioUrlStr){
						//String audioUrl=this.cmsApiAttachmenetService.uploadImage(audioUrlStr, sysUser,null);
						model.setVenueVoiceUrl(null);
					}

					//如果场馆id为空的话，说明文化云DB没有当前场馆信息，就执行insert，否则修改
					if(StringUtils.isNull(queryVenueId)){
						//保存数据到文化云系统
						int success=cmsVenueService.saveVenue(model, sysUser);
						if(success>0){
							msg.setStatus(true);
							msg.setCode(-1);
							msg.setText(model.getVenueName()+" 插入成功!");
						}
						else{
							msg.setStatus(false);
							msg.setCode(CmsApiStatusConstant.ERROR);
							msg.setText("添加失败!,未知错误");

						}
					}else{
						int success=cmsVenueService.editVenueById(model);
						if(success>0){
							msg.setStatus(true);
							msg.setCode(-1);
							msg.setText(model.getVenueName()+" 修改成功!");
						}
						else{
							msg.setStatus(false);
							msg.setCode(CmsApiStatusConstant.ERROR);
							msg.setText("添加失败!,未知错误");

						}
					}
//				}
//				else{
//					msg.setStatus(false);
//					msg.setCode(CmsApiStatusConstant.ERROR);
//					msg.setText("系统没有此数据不能修改");
//				}
		    	
				
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
	public CmsApiMessage delete(CmsApiData<CmsVenue> apiData) throws Exception {
		CmsApiMessage msg=new CmsApiMessage();
		String sysNo=apiData.getSysno();
		String token=apiData.getToken();
		String sysId=apiData.getId();
		msg=CmsApiUtil.checkToken(sysNo, token);
		if(msg.getStatus()){
			if(StringUtils.isNotNull(sysId)){
				String userName=TokenHelper.getUserName(token);
				SysUser queryUser = new SysUser();
				queryUser.setUserAccount(userName);
			    List<SysUser> userList=this.cmsUserService.querySysUserByCondition(queryUser);
			    if(userList.size()>0){
			    	SysUser sysUser=userList.get(0);
			    	String queryVenueId=this.cmsApiService.queryVenueBySysId(sysId,sysNo);
					if(StringUtils.isNull(queryVenueId)){
						msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.DATA_ERROR);
						msg.setText(queryVenueId+" 该场所在系统不存在!");
						return msg;
					}
					CmsVenue cmsVenue = this.cmsVenueService.queryVenueById(queryVenueId);

					if(cmsVenue != null){
						SysDept dept = cmsDeptService.querySysDeptByDeptId(cmsVenue.getVenueDeptId());
						if(dept != null){
							dept.setDeptState(2);
							int editCount = this.cmsDeptService.editSysDept(dept);
						}
						//如果场馆的状态是5代表是在回收站中删除，则直接物理删除，否则逻辑删除
						if(cmsVenue.getVenueState()==5){
							int success = this.cmsVenueService.deleteVenueById(queryVenueId);
							if(success>0){
								msg.setStatus(true);
								msg.setCode(CmsApiStatusConstant.SUCCESS);
								msg.setText("删除成功!");
								return msg;
							}else{
								msg.setStatus(false);
								msg.setCode(CmsApiStatusConstant.DATA_ERROR);
								msg.setText("发生未知错误，删除没有成功");
								return msg;
							}
						}else{
							int success=this.cmsVenueService.updateStateByVenueIds(queryVenueId, sysUser.getUserId());
							if(success>0){
								msg.setStatus(true);
								msg.setCode(CmsApiStatusConstant.SUCCESS);
								msg.setText("删除成功!");
								return msg;
							}
							else{
								msg.setStatus(false);
								msg.setCode(CmsApiStatusConstant.DATA_ERROR);
								msg.setText("发生未知错误，删除没有成功");
								return msg;
							}
						}
					}else{
						msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.VENUE_ERROR_NULL);
						msg.setText("场馆不存在，不能执行删除");
						return msg;
					}
			    }
			    else{
			    	msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.USER_ERROR);
					msg.setText("用户不存在，不能执行删除");
					return msg;
			    }
			}
			else{
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("id为空数据，不能执行删除");
				return msg;
			}
		}
		return msg;
	}
	//校验系统数据，校验系统编号，token是否有效
	private CmsApiMessage check(CmsApiData<CmsVenue> apiData) throws Exception {
		CmsApiMessage msg=new CmsApiMessage();
		String sysNo=apiData.getSysno();
		String token=apiData.getToken();
		
		msg=CmsApiUtil.checkToken(sysNo, token);
		if(msg.getStatus()){
			CmsVenue model=apiData.getData();
			
			if(model==null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("数据不能为空");
				return msg;
			}
			if(StringUtils.isNull(model.getSysId())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("系统ID不能为空");
				return msg;
			}
			if(StringUtils.isNull(model.getVenueName())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场所名称不能为空");
				return msg;
			}
			if(model.getVenueName().length()>100){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场所名称字符长度超过");
				return msg;
			}
			if(StringUtils.isNull(model.getVenueIconUrl())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("封面地址不能为空");
				return msg;
			}
			if(StringUtils.isNotNull(model.getVenueIconUrl())){
				//封面不为空，系统下载文件流，并上次到文化云中，并把文化云中地址给封面地址
				
			}
			
			if(StringUtils.isNull(model.getVenueProvince())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("省不能为空");
				return msg;
			}
			if(!"44,上海市".equals(model.getVenueProvince())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("省数据填写出错，请填写 44,上海市");
				return msg;
			}
		
			
			if(StringUtils.isNull(model.getVenueCity())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("市名称不能为空");
				return msg;
			}
			if(!"45,上海市".equals(model.getVenueCity())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("城市数据填写出错，请填写 45,上海市");
				return msg;
			}
			
			if(StringUtils.isNull(model.getVenueArea())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("区名称不能为空");
				return msg;
			}
			boolean abool=this.cmsApiTagsService.checkDictArea(model.getVenueArea());
			if(abool==false){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText(model.getVenueArea()+" 在系统中不存在");
				return msg;
			}
			
			//判断标签
			if(StringUtils.isNull(model.getVenueType())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场所类型标签不能为空");
				return msg;
			}
			
			/*if(StringUtils.isNull(model.getVenueCrowd())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("人群标签不能为空");
				return msg;
			}
			*//*if(StringUtils.isNull(model.getVenueMood())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("位置标签不能为空");
				return msg;
			}*/
			
		
			//判断场所位置标签是否存在
			
			//boolean mdbool=this.checkTags(model.getVenueType(),"VENUE_CROWD");
			
			if(StringUtils.isNull(model.getVenueAddress())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场所地址不能为空");
				return msg;
			}
			
			if(model.getVenueLon()==null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场馆坐标经度不能为空");
				return msg;
			}
			
			if(model.getVenueLat()==null){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场馆坐标纬度不能为空");
				return msg;
			}
			
//			if(StringUtils.isNull(model.getVenueLinkman())){
//				msg.setStatus(false);
//				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//				msg.setText("场所联系人不能为空");
//				return msg;
//			}
			
			if(StringUtils.isNull(model.getVenueTel())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场所联系电话不能为空");
				return msg;
			}
			
			if(StringUtils.isNull(model.getVenueOpenTime())){
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场所开放时间不能为空");
				return msg;
			}
			
			if(model.getVenueIsFree()==null){
				model.setVenueIsFree(1);
			}
			
			if(model.getVenueHasRoom()==null){
				model.setVenueHasRoom(1);
			}
			
			if(model.getVenueHasAntique()==null){
				model.setVenueHasAntique(1);
			}
			
		
			msg.setStatus(true);
			msg.setCode(CmsApiStatusConstant.SUCCESS);
			msg.setText("数据校验成功");
		}
		
		return msg;
	}
	

	//	还原场馆回收站
	@Override
	public CmsApiMessage returnVenue(CmsApiData<CmsVenue> apiData) throws Exception {
		CmsApiMessage msg=new CmsApiMessage();
		String sysNo=apiData.getSysno();
		String token=apiData.getToken();
		String sysId=apiData.getId();
		msg=CmsApiUtil.checkToken(sysNo, token);
		if(msg.getStatus()){
			if(StringUtils.isNotNull(sysId)){
				String userName=TokenHelper.getUserName(token);
				SysUser queryUser = new SysUser();
				queryUser.setUserAccount(userName);
				List<SysUser> userList=this.cmsUserService.querySysUserByCondition(queryUser);
				if(userList.size()>0){
					SysUser sysUser=userList.get(0);
					String queryVenueId=this.cmsApiService.queryVenueBySysId(sysId,sysNo);
					if(StringUtils.isNull(queryVenueId)){
						msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.DATA_ERROR);
						msg.setText(queryVenueId+" 该场所在系统不存在!");
						return msg;
					}
					//根据id查询场馆信息
					CmsVenue cmsVenue = this.cmsVenueService.queryVenueById(queryVenueId);

					if(null != cmsVenue){
						SysDept dept = this.cmsDeptService.querySysDeptByDeptId(cmsVenue.getVenueDeptId());
						if(dept != null){
							dept.setDeptState(1);
							int editCount = this.cmsDeptService.editSysDept(dept);
						}
						int success = this.cmsVenueService.returnVenueByIds(queryVenueId,sysNo);

						if(success>0){
							msg.setStatus(true);
							msg.setCode(CmsApiStatusConstant.DATA_ERROR);
							msg.setText("还原成功!");
							return msg;
						}else{
							msg.setStatus(false);
							msg.setCode(CmsApiStatusConstant.DATA_ERROR);
							msg.setText("发生未知错误，还原没有成功");
							return msg;
						}
					}else{
						int success=this.cmsVenueService.updateStateByVenueIds(queryVenueId, sysUser.getUserId());
						if(success>0){
							msg.setStatus(true);
							msg.setCode(CmsApiStatusConstant.DATA_ERROR);
							msg.setText("还原成功!");
							return msg;
						}
						else{
							msg.setStatus(false);
							msg.setCode(CmsApiStatusConstant.DATA_ERROR);
							msg.setText("发生未知错误，还原没有成功");
							return msg;
						}
					}
				}
				else{
					msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.USER_ERROR);
					msg.setText("用户不存在，不能执行还原");
					return msg;
				}
			}
			else{
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("id为空数据，不能执行还原");
				return msg;
			}
		}
		return msg;
	}
}
