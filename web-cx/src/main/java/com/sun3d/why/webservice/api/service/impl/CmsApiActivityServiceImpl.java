/*
@author lijing
@version 1.0 2015年8月4日 下午3:50:56
活动添加，删除，修改，校验服务
*/
package com.sun3d.why.webservice.api.service.impl;

import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiFile;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.service.CmsApiActivityService;
import com.sun3d.why.webservice.api.service.CmsApiAttachmenetService;
import com.sun3d.why.webservice.api.service.CmsApiService;
import com.sun3d.why.webservice.api.service.CmsApiTagsService;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.CmsApiUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CmsApiActivityServiceImpl implements CmsApiActivityService {
    @Autowired
    private CmsApiService cmsApiService;
    @Autowired
    private CmsActivityService cmsActivityService;
    /*@Autowired
    private CmsVenueService cmsVenueService;*/
    @Autowired
    private CmsUserService cmsUserService;
    @Autowired
    private CmsApiTagsService cmsApiTagsService;
    @Autowired
    private CmsApiAttachmenetService cmsApiAttachmenetService;

    @Autowired
    private SysDictService sysDictService;

    @Autowired
    private CmsActivityMapper activityMapper;

    @Override
    public CmsApiMessage save(CmsApiData<CmsActivity> apiData) throws Exception {
        CmsApiMessage msg = this.check(apiData);
        boolean bool = msg.getStatus();
        if (bool) {
            String token = apiData.getToken();
            String userName = TokenHelper.getUserName(token);
            String sysNo = apiData.getSysno();
            CmsActivity model = apiData.getData();

            //判断活动是否存在
            String queryId = this.cmsApiService.queryActivityBySysId(model.getSysId(), sysNo);
            if (queryId != null) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.ACTIVITY_ERROR);
                msg.setText(model.getSysId() + " 该活动在系统已经存在!");
                return msg;
            }

            //查询活动名称是否重复
            Map map = new HashMap<>();
            map.put("activityName", model.getActivityName());
            map.put("activityTime", model.getActivityTime());
            int resultNum = this.activityMapper.queryAPIActivityNameIsExists(map);
            if (resultNum > 0) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.ACTIVITY_ERROR);
                msg.setText(model.getActivityName() + " 该活动名重复!");
                return msg;
            }
            //判断场所数据是否存在
            String venueId = this.cmsApiService.queryVenueBySysId(model.getVenueId(), sysNo);
            if (venueId == null) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.VENUE_ERROR);
                msg.setText(model.getVenueId() + " 该场所在系统中不存在!");
                return msg;
            }
            model.setVenueId(venueId);

            SysUser queryUser = new SysUser();
            queryUser.setUserAccount(userName);
            List<SysUser> userList = this.cmsUserService.querySysUserByCondition(queryUser);
            if (userList.size() > 0) {
                SysUser sysUser = userList.get(0);

                //上传图片，到文化云系统
                String iconUrl = model.getActivityIconUrl();
                CmsApiFile apiFile = this.cmsApiAttachmenetService.checkImage(iconUrl);
		    	if(apiFile.getSuccess()==0){
		    		msg.setStatus(false);
					msg.setCode(CmsApiStatusConstant.DATA_ERROR);
					msg.setText("上传图片时发生错误："+apiFile.getMsg());
					return msg;
		    	}
		    	String imageUrl=this.cmsApiAttachmenetService.uploadImage(iconUrl, sysUser,"2");
		    	if(StringUtils.isNotNull(imageUrl)){
		    		model.setActivityIconUrl(imageUrl);
		    	}
                //如果不填写预定，则默认为不可预定
                if (model.getActivityIsReservation() == null || model.getActivityIsReservation() == 1) {
                    model.setActivityIsReservation(1);
                }
                if (model.getActivityIsReservation() != 1) {
                    model.setActivityState(Constant.UNUSED);
                }
//				else{
//		    		if(model.getActivityIsReservation()== 2){
//						model.setActivityIsReservation(2);
//		    			model.setActivitySalesOnline("N");
//		    		}
//		    	}
//		    	if(model.getActivitySalesOnline()== null || "N".equals(model.getActivitySalesOnline())){
//		    		model.setActivitySalesOnline("N");
//		    	} else if("Y".equals(model.getActivitySalesOnline())){
//		    		model.setActivityIsReservation(2);
//					model.setActivitySalesOnline("Y");
//		    	}

                //如果没有传活动状态过，就设置为已发布活动
                if (null == model.getActivityState() || "".equals(model.getActivityState())) {
                    model.setActivityState(Constant.PUBLISH);
                }

                model.setSysNo(apiData.getSysno());

                //判断活动类型标签是否符合条件
                String activityType = this.cmsApiService.getAPITags(model.getActivityType(), "活动类型");
                if (activityType == null) {
                    String activityTypeStr = this.cmsApiService.getAPITags("其他", "活动类型");
                    model.setActivityType(activityTypeStr + ",");
                } else {
                    model.setActivityType(activityType + ",");
                }

                //根据嘉定传过来的区域名称，来查询对应的id
                if (org.apache.commons.lang3.StringUtils.isNotBlank(model.getActivityLocation())) {
                    SysDict dict = sysDictService.querySysDictByDictName(model.getActivityLocation(), null);
                    if (dict != null) {
                        model.setActivityLocation(dict.getDictId());
                    } else {
                        if ("1".equals(sysNo)) {
                            SysDict dictJD = sysDictService.querySysDictByDictName("其他", "jiadingquqita");
                            if (null != dictJD) {
                                model.setActivityLocation(dictJD.getDictId());
                            } else {
                                model.setActivityLocation(null);
                            }
                        } else if ("2".equals(sysNo)) {
                            SysDict dictPD = sysDictService.querySysDictByDictName("其他", "pudongxinquqita");
                            if (null != dictPD) {
                                model.setActivityLocation(dictPD.getDictId());
                            } else {
                                model.setActivityLocation(null);
                            }
                        } else if ("3".equals(sysNo)) {
                            SysDict dictJA = sysDictService.querySysDictByDictName("其他", "jinganquqita");
                            if (null != dictJA) {
                                model.setActivityLocation(dictJA.getDictId());
                            } else {
                                model.setActivityLocation(null);
                            }
                        } else {
                            List<SysDict> sysDict = sysDictService.querySysDictByCode(sysNo);
                            if (sysDict.size() > 0) {
                                model.setActivityLocation(sysDict.get(0).getDictId());
                            } else {
                                model.setActivityLocation(null);
                            }
                        }
                    }
                }

                String success = cmsActivityService.addAPIActivity(model, sysUser, null);
                if (StringUtils.isNotNull(success) && "success".equals(success)) {
                    msg.setStatus(true);
                    msg.setCode(-1);
                    msg.setText(model.getActivityName() + "  活动添加成功!");
                } else {
                    msg.setStatus(false);
                    msg.setCode(CmsApiStatusConstant.ERROR);
                    msg.setText("添加失败!,未知错误:" + success);

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

    //首先校验token是否合法，然后校验活动数据是否完整
    private CmsApiMessage check(CmsApiData<CmsActivity> apiData) throws Exception {
        CmsApiMessage msg = new CmsApiMessage();
        String sysNo = apiData.getSysno();
        String token = apiData.getToken();

        msg = CmsApiUtil.checkToken(sysNo, token);
        if (msg.getStatus()) {
            CmsActivity model = apiData.getData();
            if (model == null) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("数据不能为空");
                return msg;
            }
            if (StringUtils.isNull(model.getSysId())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("子系统id不能为空");
                return msg;
            }
            if (StringUtils.isNull(model.getVenueId())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("场所id不能为空");
                return msg;
            }

            if (StringUtils.isNull(model.getActivityName())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("活动名称不能为空");
                return msg;
            }

            if (StringUtils.isNull(model.getActivityIconUrl())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("活动图片路径不能为空");
                return msg;
            }

            //对应嘉定的栏目
            if (StringUtils.isNull(model.getActivityType())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("该活动主题类型不能为空");
                return msg;
            }

            if (StringUtils.isNull(model.getActivityStartTime())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("活动开始时间不能为空");
                return msg;
            }

            if (!CmsApiUtil.isDate(model.getActivityStartTime())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("活动开始时间不是日期格式  yyyy-MM-dd hh:mm");
                return msg;
            }

            if (StringUtils.isNull(model.getActivityAddress())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("活动地址不能为空");
                return msg;
            }

            if (model.getActivityLon() == null) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("活动坐标经度不能为空");
                return msg;
            }
            if (model.getActivityLat() == null) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("活动坐标纬度不能为空");
                return msg;
            }
            if (StringUtils.isNull(model.getActivityTel())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("活动电话不能为空");
                return msg;
            }
            if (model.getActivityIsFree() == null) {
                model.setActivityIsFree(1);
            }

            //富文本里面的内容不能为空
            if (StringUtils.isNull(model.getActivityMemo())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("活动描述不能为空");
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
    public CmsApiMessage update(CmsApiData<CmsActivity> apiData) throws Exception {
        CmsApiMessage msg = this.check(apiData);
        boolean bool = msg.getStatus();
        if (bool) {
            String token = apiData.getToken();
            String userName = TokenHelper.getUserName(token);
            String sysNo = apiData.getSysno();
            CmsActivity model = apiData.getData();
            String sysId = model.getSysId();
            String queryId = this.cmsApiService.queryActivityBySysId(sysId, sysNo);
            //查询活动名称是否重复
            CmsActivity cmsActivity = this.activityMapper.queryCmsActivityByActivityName(model.getActivityName());
            if (null != cmsActivity && !model.getActivityId().equals(cmsActivity.getSysId())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.ACTIVITY_ERROR);
                msg.setText(model.getActivityName() + " 该活动名重复!");
                return msg;
            }
            //判断场所数据是否存在
            String venueId = this.cmsApiService.queryVenueBySysId(model.getVenueId(), sysNo);
            if (venueId == null) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText(model.getVenueId() + " 该场所在系统中不存在!");
                return msg;
            }
            model.setVenueId(venueId);


            SysUser queryUser = new SysUser();
            queryUser.setUserAccount(userName);
            List<SysUser> userList = this.cmsUserService.querySysUserByCondition(queryUser);
            if (userList.size() > 0) {
                SysUser sysUser = userList.get(0);
                model.setActivityId(queryId);
                //上传图片，到文化云系统
                String iconUrl = model.getActivityIconUrl();
                CmsApiFile apiFile = this.cmsApiAttachmenetService.checkImage(iconUrl);
                if (apiFile.getSuccess() == 0) {
                    msg.setStatus(false);
                    msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                    msg.setText("上传图片时发生错误：" + apiFile.getMsg());
                    return msg;
                }
                String imageUrl = this.cmsApiAttachmenetService.uploadImage(iconUrl, sysUser, "2");
                if (StringUtils.isNotNull(imageUrl)) {
                    model.setActivityIconUrl(imageUrl);
                }

                //如果不填写预定，则默认为不可预定
                if (model.getActivityIsReservation() == null) {
                    model.setActivityIsReservation(1);
                }

                if (null == model.getActivityState() || "".equals(model.getActivityState())) {
                    model.setActivityState(Constant.PUBLISH);
                }
                model.setSysNo(apiData.getSysno());

                String activityType = this.cmsApiService.getAPITags(model.getActivityType(), "活动类型");
                if (activityType == null) {
                    String activityTypeStr = this.cmsApiService.getAPITags("其他", "活动类型");
                    model.setActivityType(activityTypeStr + ",");
                } else {
                    model.setActivityType(activityType + ",");
                }

                //根据嘉定传过来的区域名称，来查询对应的id
                if (org.apache.commons.lang3.StringUtils.isNotBlank(model.getActivityLocation())) {
                    SysDict dict = sysDictService.querySysDictByDictName(model.getActivityLocation(), null);
                    if (dict != null) {
                        model.setActivityLocation(dict.getDictId());
                    } else {
                        if ("1".equals(sysNo)) {
                            model.setActivityLocation(sysDictService.querySysDictByDictName("其他", "jiadingquqita").getDictId());
                        } else if ("2".equals(sysNo)) {
                            model.setActivityLocation(sysDictService.querySysDictByDictName("其他", "pudongxinquqita").getDictId());
                        } else if ("3".equals(sysNo)) {
                            SysDict dictJA = sysDictService.querySysDictByDictName("其他", "jinganquqita");
                            if (null != dictJA) {
                                model.setActivityLocation(dictJA.getDictId());
                            } else {
                                model.setActivityLocation(null);
                            }
                        } else {
                            List<SysDict> sysDict = sysDictService.querySysDictByCode(sysNo);
                            if (sysDict.size() > 0) {
                                model.setActivityLocation(sysDict.get(0).getDictId());
                            } else {
                                model.setActivityLocation(null);
                            }
                        }
                    }
                }
                String success = null;
                if (StringUtils.isNull(queryId)) {
                    //如果活动数据在文化云这边不存在，则新增一条数据
                    success = cmsActivityService.addAPIActivity(model, sysUser, "");
                } else {
                    //否则修改数据
                    success = cmsActivityService.editActivityAPI(model, sysUser, "", false);
                }
                if (StringUtils.isNotNull(success) && "success".equals(success)) {
                    msg.setStatus(true);
                    msg.setCode(-1);
                    msg.setText(model.getActivityName() + "  活动修改成功!");
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
    public CmsApiMessage delete(CmsApiData<CmsActivity> apiData) throws Exception {
        CmsApiMessage msg = new CmsApiMessage();
        String sysNo = apiData.getSysno();
        String token = apiData.getToken();
        String sysId = apiData.getId();
        msg = CmsApiUtil.checkToken(sysNo, token);

        if (msg.getStatus()) {
            String userName = TokenHelper.getUserName(token);
            SysUser queryUser = new SysUser();
            queryUser.setUserAccount(userName);
            List<SysUser> userList = this.cmsUserService.querySysUserByCondition(queryUser);

            if (userList.size() > 0) {
                //modeId即活动的id
                String modelId = this.cmsApiService.queryActivityBySysId(sysId, sysNo);
                if (StringUtils.isNotNull(modelId)) {
                    //根据活动id查询活动的信息
                    CmsActivity cmsActivity = cmsActivityService.queryCmsActivityByActivityId(modelId);
                    //5代表活动在回收站状态，回收站里面删除是物理删除了
                    if (cmsActivity.getActivityState() == 5) {
                        cmsActivityService.deleteByActivityId(cmsActivity.getActivityId());
                        msg.setStatus(true);
                        msg.setCode(-1);
                        msg.setText(modelId + " 活动删除成功!");
                        return msg;
                    } else {
                        //逻辑删除
                        boolean bool = this.cmsActivityService.updateActivityDelStatus(modelId, 1);
                        if (bool) {
                            msg.setStatus(true);
                            msg.setCode(-1);
                            msg.setText(modelId + " 活动删除成功!");
                        } else {
                            msg.setStatus(false);
                            msg.setCode(CmsApiStatusConstant.ERROR);
                            msg.setText("删除失败:" + sysId);

                        }
                    }
                } else {
                    msg.setStatus(false);
                    msg.setCode(CmsApiStatusConstant.ACTIVITY_ERROR);
                    msg.setText(sysId + " 的活动不存在!");
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
    public CmsApiMessage returnActivity(CmsApiData<CmsActivity> apiData) throws Exception {
        CmsApiMessage msg = new CmsApiMessage();
        String sysNo = apiData.getSysno();
        String token = apiData.getToken();
        String activityId = apiData.getId();//sys_id

        //验证token
        msg = CmsApiUtil.checkToken(sysNo, token);

        if (msg.getStatus()) {
            String userName = TokenHelper.getUserName(token);
            SysUser queryUser = new SysUser();
            queryUser.setUserAccount(userName);
            List<SysUser> userList = this.cmsUserService.querySysUserByCondition(queryUser);

            if (userList.size() > 0) {
                //modeId即活动的id
                String modelId = this.cmsApiService.queryActivityBySysId(activityId, sysNo);

                if (StringUtils.isNotNull(modelId)) {
                    CmsActivity cmsActivity = cmsActivityService.queryCmsActivityByActivityId(modelId);
                    if (null != cmsActivity) {
                        boolean status = cmsActivityService.backActivityAPI(modelId, sysNo);
                        if (status) {
                            msg.setStatus(true);
                            msg.setCode(-1);
                            msg.setText(modelId + " 活动还原成功!");
                        } else {
                            msg.setStatus(false);
                            msg.setCode(CmsApiStatusConstant.ERROR);
                            msg.setText(modelId + " 活动还原失败!");
                        }
                    } else {
                        msg.setStatus(false);
                        msg.setCode(CmsApiStatusConstant.ACTIVITY_ERROR);
                        msg.setText(modelId + " 的活动不存在!");
                    }
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
}

