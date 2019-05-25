package com.sun3d.why.webservice.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsRoomBookMapper;
import com.sun3d.why.dao.CmsRoomOrderMapper;
import com.sun3d.why.dao.CmsTeamUserDetailPicMapper;
import com.sun3d.why.dao.CmsTeamUserMapper;
import com.sun3d.why.dao.CmsUserOperatorLogMapper;
import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTeamUserDetailPic;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.service.CmsApplyJoinTeamService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.TeamUserAppService;

/**
 * app团体信息
 */
@Service
@Transactional
public class TeamUserAppServiceImpl implements TeamUserAppService {
    @Autowired
    private CmsTeamUserMapper cmsTeamUserMapper;
    
    @Autowired
    private CmsApplyJoinTeamService applyJoinTeamService;
    
    @Autowired
    private CmsTeamUserDetailPicMapper teamUserDetailPicMapper;
    
    @Autowired
    private CmsRoomOrderMapper cmsRoomOrderMapper;

    @Autowired
    private CmsRoomBookMapper cmsRoomBookMapper;
    
    @Autowired
    private CmsUserOperatorLogMapper cmsUserOperatorLogMapper;
    /**
     * app根据用户id判断用户是否为团体用户
     * @param userId 用户id
     * @return
     */
    @Override
    public String queryAppTeamUserList(String userId) {
        Map<String, Object> map = new HashMap<String, Object>();
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        map.put("applyIsState", Constant.APPLY_IS_STATE_ADMIN);
        map.put("applyCheckState", Constant.APPLY_ALREADY_PASS);
        if(userId!=null && StringUtils.isNotBlank(userId)){
            map.put("userId", userId);
        }
        List<CmsTeamUser> teamUserList= cmsTeamUserMapper.queryAppTeamUserList(map);
            if (CollectionUtils.isNotEmpty(teamUserList)) {
                for (CmsTeamUser teamUsers : teamUserList) {
                    Map<String, Object> teamMap = new HashMap<String, Object>();
                    teamMap.put("teamUserName", teamUsers.getTuserName() != null ? teamUsers.getTuserName() : "");
                    teamMap.put("TUserId", teamUsers.getTuserId() != null ? teamUsers.getTuserId() : "");
                    listMap.add(teamMap);
                }
            }

        else{
            return JSONResponse.commonResultFormat(1, "场馆预定只针对团体用户开放，请多谅解！如您有需要，请到所在街道或社区活动中心进行申请成为团体，并开通账号，感谢您的使用。", null);
        }
            return JSONResponse.toAppResultFormat(0, listMap);
    }
	@Override
	public String addCmsTeamUser(CmsTeamUser teamUser,String []teamUserDetailPics,String roomOrderId) {
		
		int count  = cmsTeamUserMapper.addCmsTeamUser(teamUser);
		
		 if (count > 0){
             CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
             applyJoinTeam.setTuserId(teamUser.getTuserId());
             applyJoinTeam.setUserId(teamUser.getUserId());
             applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_PASS);
             applyJoinTeam.setApplyCheckTime(new Date());
             applyJoinTeam.setApplyIsState(1);
             applyJoinTeam.setApplyCreateUser(teamUser.getUserId());
             applyJoinTeam.setApplyUpdateUser(teamUser.getUserId());
             applyJoinTeamService.addApplyJoinTeam(applyJoinTeam, null);
             
             if(teamUserDetailPics!=null&&teamUserDetailPics.length>0)
             {
            	 for (String url : teamUserDetailPics) {
            		 
            		 if(StringUtils.isNotBlank(url))
            		 {
            			 int index=url.indexOf("front");
          	             url = url.substring(index,url.length());
            			 CmsTeamUserDetailPic record=new CmsTeamUserDetailPic();
                		 record.setTuserDetailPicId(UUIDUtils.createUUId());
                		 record.setTuserId(teamUser.getTuserId());
                		 record.setUrl(url);
                		 teamUserDetailPicMapper.insert(record);     	
            		 }
				}
             }
             
             if(StringUtils.isNotBlank(roomOrderId))
             {
            	 CmsRoomOrder cmsRoomOrder = cmsRoomOrderMapper.queryCmsRoomOrderById(roomOrderId);
            	 
            	 cmsRoomOrder.setTuserId(teamUser.getTuserId());
            	 
            	 cmsRoomOrder.setTuserName(teamUser.getTuserName());
            	 
            	 cmsRoomOrderMapper.editCmsRoomOrder(cmsRoomOrder);
//            	 
//            	 CmsRoomBook cmsRoomBook = cmsRoomBookMapper.queryCmsRoomBookById(cmsRoomOrder.getBookId());
//             
//            	 if(cmsRoomBook.getO)
//            	 
//            	 cmsRoomBook.setTuserId(teamUser.getTuserId());
//            	 
//            	 cmsRoomBookMapper.editCmsRoomBook(cmsRoomBook); 
             }
             
        	 CmsUserOperatorLog record= CmsUserOperatorLog.createInstance(null, null, teamUser.getTuserId(), teamUser.getUserId(), CmsUserOperatorLog.USER_TYPE_NORMAL, UserOperationEnum.TUSER_CREATE);
        	 
        	 cmsUserOperatorLogMapper.insert(record);
             
             return JSONResponse.commonResultFormat(0, "添加使用者成功!", null);
         }
		 else
			 return JSONResponse.commonResultFormat(1, "添加使用者失败!", null);
			 
		
		
	}
	@Override
	public String editCmsTeamUser(CmsTeamUser teamUser, String[] teamUserDetailPics, String roomOrderId) {
	
		
		
		int count  = cmsTeamUserMapper.editCmsTeamUser(teamUser);
		
		 if (count > 0){
			 
			 teamUserDetailPicMapper.deleteByTuserId(teamUser.getTuserId());
			 
            if(teamUserDetailPics!=null&&teamUserDetailPics.length>0)
            {
            	
           	 for (String url : teamUserDetailPics) {
           		 
           		 if(StringUtils.isNotBlank(url))
           		 {
           			 int index=url.indexOf("front");
         	             url = url.substring(index,url.length());
           			 CmsTeamUserDetailPic record=new CmsTeamUserDetailPic();
               		 record.setTuserDetailPicId(UUIDUtils.createUUId());
               		 record.setTuserId(teamUser.getTuserId());
               		 record.setUrl(url);
               		 teamUserDetailPicMapper.insert(record);     	
           		 }
				}
            }
            
            teamUser= cmsTeamUserMapper.queryCmsTeamUserById(teamUser.getTuserId());
            
            Integer userIsDisplay=teamUser.getTuserIsDisplay();
            
            if(userIsDisplay==0||userIsDisplay==1)
            {
            	 CmsUserOperatorLog record= CmsUserOperatorLog.createInstance(null, roomOrderId, teamUser.getTuserId(), teamUser.getUserId(), CmsUserOperatorLog.USER_TYPE_NORMAL,UserOperationEnum.EDIT_INFO );
               	 
                 cmsUserOperatorLogMapper.insert(record);
            }
            
            else if(userIsDisplay==3)
            {
            	CmsUserOperatorLog record= CmsUserOperatorLog.createInstance(null, roomOrderId, teamUser.getTuserId(), teamUser.getUserId(), CmsUserOperatorLog.USER_TYPE_NORMAL,UserOperationEnum.AUTH_RE_SUBMIT );
               	 
                cmsUserOperatorLogMapper.insert(record);
                
                teamUser.setTuserIsDisplay(0);
                
                cmsTeamUserMapper.editCmsTeamUser(teamUser);
            }
            
            if(StringUtils.isNotBlank(roomOrderId))
            {
           	 CmsRoomOrder cmsRoomOrder = cmsRoomOrderMapper.queryCmsRoomOrderById(roomOrderId);
           	 
           	 cmsRoomOrder.setTuserId(teamUser.getTuserId());
           	 
           	 cmsRoomOrder.setTuserName(teamUser.getTuserName());
           	 
           	 cmsRoomOrderMapper.editCmsRoomOrder(cmsRoomOrder);
//           	 
//           	 CmsRoomBook cmsRoomBook = cmsRoomBookMapper.queryCmsRoomBookById(cmsRoomOrder.getBookId());
//            
//           	 if(cmsRoomBook.getO)
//           	 
//           	 cmsRoomBook.setTuserId(teamUser.getTuserId());
//           	 
//           	 cmsRoomBookMapper.editCmsRoomBook(cmsRoomBook); 
            }
         
            
            return JSONResponse.commonResultFormat(0, "编辑使用者成功!", null);
        }
		 else
			 return JSONResponse.commonResultFormat(1, "编辑使用者失败!", null);
	}

}
