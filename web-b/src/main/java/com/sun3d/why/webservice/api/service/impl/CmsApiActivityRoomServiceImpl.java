/*
@author lijing
@version 1.0 2015年8月4日 下午3:50:39
场所活动室添加，删除，修改，校验服务
*/
package com.sun3d.why.webservice.api.service.impl;

import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiFile;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.service.CmsApiActivityRoomService;
import com.sun3d.why.webservice.api.service.CmsApiAttachmenetService;
import com.sun3d.why.webservice.api.service.CmsApiService;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.CmsApiUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CmsApiActivityRoomServiceImpl implements CmsApiActivityRoomService {

	@Autowired
	private CmsApiService cmsApiService;
	@Autowired
	private CmsActivityRoomService cmsActivityRoomService;
	@Autowired
	private CmsUserService cmsUserService;

	@Autowired
	private CmsApiAttachmenetService cmsApiAttachmenetService;

	@Override
	public CmsApiMessage save(CmsApiData<CmsActivityRoom> apiData) throws Exception {
		CmsApiMessage msg = this.check(apiData);
		boolean bool = msg.getStatus();
		if (bool) {

			String token = apiData.getToken();
			String userName = TokenHelper.getUserName(token);
			String sysNo = apiData.getSysno();
			CmsActivityRoom model = apiData.getData();

			// 判断活动是否存在
			String queryId = this.cmsApiService.queryActivitRoomyBySysId(model.getSysId(), sysNo);
			if (queryId != null) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText(model.getSysId() + " 该活动室在系统已经存在!");
				return msg;
			}

			// 判断场所数据是否存在
			String venueId = this.cmsApiService.queryVenueBySysId(model.getRoomVenueId(), sysNo);
			if (venueId == null) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.VENUE_ERROR);
				msg.setText(model.getRoomVenueId() + " 该场所在系统中不存在!");
				return msg;
			}
			model.setRoomVenueId(venueId);

			SysUser queryUser = new SysUser();
			queryUser.setUserAccount(userName);
			List<SysUser> userList = this.cmsUserService.querySysUserByCondition(queryUser);
			if (userList.size() > 0) {
				SysUser sysUser = userList.get(0);

				String iconUrl = model.getRoomPicUrl();
				CmsApiFile apiFile = this.cmsApiAttachmenetService.checkImage(iconUrl);
				if (apiFile.getSuccess() == 0) {
					msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.DATA_ERROR);
					msg.setText("上传图片时发生错误：" + apiFile.getMsg());
					return msg;
				}
				String imageUrl = this.cmsApiAttachmenetService.uploadImage(iconUrl, sysUser, "5");
				if (StringUtils.isNotNull(imageUrl)) {
					model.setRoomPicUrl(imageUrl);
				}
				model.setSysNo(apiData.getSysno());
				String roomDays = apiData.getOtherData();
				String rtnRoomMsg = CmsApiUtil.checkRoomDays(roomDays);
				if (StringUtils.isNotNull(rtnRoomMsg)) {
					msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.ERROR);
					msg.setText("活动室RoomDays数据字符不合理：" + rtnRoomMsg);
					return msg;
				}
				roomDays=CmsApiUtil.getRoomDays(roomDays);//解析roomDays使其符合文化云字符格式

				//设置子系统活动室标签为其他类型
				String roomTagId = this.cmsApiService.getAPITags("其他","活动室标签");
				model.setRoomTag(roomTagId+",");

				int success = cmsActivityRoomService.addCmsActivityRoom(model, sysUser, roomDays);
				if (success > 0) {
					msg.setStatus(true);
					msg.setCode(-1);
					msg.setText(model.getRoomName() + "  活动室添加成功!");
				} else {
					msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.ERROR);
					msg.setText("添加失败!,未知错误");
				}

			} else {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.USER_ERROR);
				msg.setText(userName + " 用户不存在");
				return msg;
			}
		}
		return msg;
	}

	@Override
	public CmsApiMessage update(CmsApiData<CmsActivityRoom> apiData) throws Exception {
		CmsApiMessage msg = this.check(apiData);
		boolean bool = msg.getStatus();
		if (bool) {
			String token = apiData.getToken();
			String userName = TokenHelper.getUserName(token);
			String sysNo = apiData.getSysno();

			CmsActivityRoom model = apiData.getData();

			String sysId = model.getSysId();
			if (StringUtils.isNull(sysId)) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.ERROR);
				msg.setText("修改数据时id为空!");
				return msg;
			}

			// 判断活动是否存在
			String queryId = this.cmsApiService.queryActivitRoomyBySysId(model.getSysId(), sysNo);
			if (queryId == null) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.ACTIVITYROOM_ERROR);
				msg.setText(model.getSysId() + " 该活动室在系统不存在，无法修改!");
				return msg;
			}

			// 判断场所数据是否存在
			String venueId = this.cmsApiService.queryVenueBySysId(model.getRoomVenueId(), sysNo);
			if (venueId == null) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.VENUE_ERROR);
				msg.setText(model.getRoomVenueId() + " 该场所在系统中不存在!");
				return msg;
			}
			model.setRoomVenueId(venueId);
			
			SysUser queryUser = new SysUser();
			queryUser.setUserAccount(userName);
			List<SysUser> userList = this.cmsUserService.querySysUserByCondition(queryUser);
			if (userList.size() > 0) {
					
					model.setRoomId(queryId);
					SysUser sysUser = userList.get(0);
					
					String iconUrl = model.getRoomPicUrl();
					CmsApiFile apiFile=this.cmsApiAttachmenetService.checkImage(iconUrl);
			    	if(apiFile.getSuccess()==0){
			    		msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.DATA_ERROR);
						msg.setText("上传图片时发生错误："+apiFile.getMsg());
						return msg;
			    	}
					String imageUrl = this.cmsApiAttachmenetService.uploadImage(iconUrl, sysUser, "5");
					if (StringUtils.isNotNull(imageUrl)) {
						model.setRoomPicUrl(imageUrl);
					}
					
					String roomDays=apiData.getOtherData();
					String rtnRoomMsg=CmsApiUtil.checkRoomDays(roomDays);
					if(StringUtils.isNotNull(rtnRoomMsg)){
						msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.ERROR);
						msg.setText("活动室RoomDays数据字符不合理："+rtnRoomMsg);
						return msg;
					}
					roomDays=CmsApiUtil.getRoomDays(roomDays);//解析roomDays使其符合文化云字符格式
					
					int success = cmsActivityRoomService.editCmsActivityRoomAPI(model, sysUser, roomDays,sysNo);
					if (success > 0) {
						msg.setStatus(true);
						msg.setCode(-1);
						msg.setText(model.getRoomName() + " 活动室修改成功!");
					} else {
						msg.setStatus(false);
						msg.setCode(CmsApiStatusConstant.ERROR);
						msg.setText("添加失败!,未知错误");

					}
				

			} else {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.USER_ERROR);
				msg.setText(userName + " 用户不存在");
				return msg;
			}
		}
		return msg;
	}

	private CmsApiMessage check(CmsApiData<CmsActivityRoom> apiData) {
		CmsApiMessage msg = new CmsApiMessage();
		String sysNo = apiData.getSysno();
		String token = apiData.getToken();

		msg = CmsApiUtil.checkToken(sysNo, token);
		if (msg.getStatus()) {
			CmsActivityRoom model = apiData.getData();
			if (model == null) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("数据不能为空");
				return msg;
			}
			if (StringUtils.isNull(model.getRoomVenueId())) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("场所id不能为空");
				return msg;
			}

			if (StringUtils.isNull(model.getRoomName())) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("活动室名称不能为空");
				return msg;
			}

			if (StringUtils.isNull(model.getRoomPicUrl())) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("活动室图片不能为空");
				return msg;
			}

			if (StringUtils.isNull(model.getRoomNo())) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("活动室位置不能为空");
				return msg;
			}

			if (StringUtils.isNull(model.getRoomConsultTel())) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("咨询电话不能为空");
				return msg;
			}
			if (model.getRoomIsFree() != null) {
				model.setRoomIsFree(1);
			}
			if (StringUtils.isNull(model.getRoomArea())) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("活动室面积不能为空");
				return msg;
			}
			if (StringUtils.isNull(model.getSysId())) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("系统ID不能为空");
				return msg;
			}

		}
		return msg;
	}

	@Override
	public CmsApiMessage delete(CmsApiData<CmsActivityRoom> apiData) throws Exception {
		CmsApiMessage msg = new CmsApiMessage();
		String sysNo = apiData.getSysno();
		String token = apiData.getToken();
		String sysId = apiData.getId();
		msg = CmsApiUtil.checkToken(sysNo, token);
		if (msg.getStatus()) {
			if (StringUtils.isNotNull(sysId)) {
				String userName = TokenHelper.getUserName(token);
				// 判断活动室是否存在
				String queryId = this.cmsApiService.queryActivitRoomyBySysId(sysId, sysNo);

				if (queryId == null) {
					msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.ACTIVITYROOM_ERROR);
					msg.setText(apiData.getId() + " 该活动室在系统不存在，不能删除!");
					return msg;
				}

				SysUser queryUser = new SysUser();
				queryUser.setUserAccount(userName);
				List<SysUser> userList = this.cmsUserService.querySysUserByCondition(queryUser);
				if (userList.size() > 0) {
					SysUser sysUser = userList.get(0);

					CmsActivityRoom model = this.cmsActivityRoomService.queryCmsActivityRoomById(queryId);
					if (model != null) {

						if(model.getRoomState()==5){
							int success = cmsActivityRoomService.deleteRecycleActivityRoom(model.getRoomId());
							if (success > 0) {
								msg.setStatus(true);
								msg.setCode(-1);
								msg.setText(model.getRoomName() + " 活动室彻底删除成功!");
							} else {
								msg.setStatus(false);
								msg.setCode(CmsApiStatusConstant.ERROR);
								msg.setText("添加失败!,未知错误");
							}

						}else{
							int success = cmsActivityRoomService.deleteCmsActivityRoom(model, sysUser);
							if (success > 0) {
								msg.setStatus(true);
								msg.setCode(-1);
								msg.setText(model.getRoomName() + " 活动室删除成功!");
							} else {
								msg.setStatus(false);
								msg.setCode(CmsApiStatusConstant.ERROR);
								msg.setText("添加失败!,未知错误");
							}

						}
					}

				} else {
					msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.USER_ERROR);
					msg.setText(userName + " 用户不存在");
					return msg;
				}
			}
		}
		return msg;
	}

}
