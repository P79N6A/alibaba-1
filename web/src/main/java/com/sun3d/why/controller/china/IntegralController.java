package com.sun3d.why.controller.china;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.alibaba.fastjson.JSON;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.culturecloud.model.bean.live.CcpLiveUser;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.TerminalUserAppService;

@RequestMapping("/chinaIntegral")
@Controller
public class IntegralController {
	private Logger logger = LoggerFactory.getLogger(IntegralController.class);

	@Autowired
    private UserIntegralDetailService userIntegralDetailService;
	@Autowired
    private UserIntegralMapper userIntegralMapper;
	@Autowired
    private UserIntegralDetailMapper userIntegralDetailMapper;
	@Autowired
	private UserIntegralService userIntegralService;
	@Autowired
    private TerminalUserAppService terminalUserAppService;
	@Autowired
	private HttpSession session;

	/**
     * 注册积分(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/registerAddIntegralByJson", method = RequestMethod.POST)
    public String registerAddIntegralByJson(HttpServletResponse response,@RequestBody String jsonUser) throws IOException{
    	CmsTerminalUser terminalUser = JSON.parseObject(jsonUser, CmsTerminalUser.class);//把data数据解析成对象
    	String json = "";
		try {
			if (terminalUser != null && StringUtils.isNotBlank(terminalUser.getUserId())) {
				int result = userIntegralDetailService.registerAddIntegral(terminalUser.getUserId());
				json = JSONResponse.toAppResultFormat(200, result);
			} else {
				json = JSONResponse.toAppResultFormat(500, "用户id缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "积分添加失败");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 每日登陆积分(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/checkDayIntegralByJson", method = RequestMethod.POST)
    public String checkDayIntegralByJson(HttpServletResponse response,@RequestBody String jsonUser) throws IOException{
    	CmsTerminalUser terminalUser = JSON.parseObject(jsonUser, CmsTerminalUser.class);//把data数据解析成对象
    	String json = "";
		try {
			if (terminalUser != null && StringUtils.isNotBlank(terminalUser.getUserId())) {
				int result = userIntegralDetailService.checkDayIntegral(terminalUser.getUserId());
				json = JSONResponse.toAppResultFormat(200, result);
			} else {
				json = JSONResponse.toAppResultFormat(500, "用户id缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "积分添加失败");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 取消订单积分(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/removeOrderIntegralByJson", method = RequestMethod.POST)
    public String removeOrderIntegralByJson(HttpServletResponse response,@RequestBody String jsonOrder) throws IOException{
    	CmsActivityOrder cmsActivityOrder = JSON.parseObject(jsonOrder, CmsActivityOrder.class);//把data数据解析成对象
    	String json = "";
		try {
			if (cmsActivityOrder.getCostTotalCredit()!=null && Integer.parseInt(cmsActivityOrder.getCostTotalCredit()) > 0) {
                UserIntegral userIntegral = userIntegralMapper.selectUserIntegralByUserId(cmsActivityOrder.getUserId());
                userIntegral.setIntegralNow(userIntegral.getIntegralNow() + Integer.parseInt(cmsActivityOrder.getCostTotalCredit()));
                int count = userIntegralMapper.updateByPrimaryKeySelective(userIntegral);
                if (count > 0) {
                    UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
                    userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
                    userIntegralDetail.setCreateTime(new Date());
                    userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
                    userIntegralDetail.setIntegralChange(Integer.parseInt(cmsActivityOrder.getCostTotalCredit()));
                    userIntegralDetail.setChangeType(0);
                    userIntegralDetail.setIntegralFrom("取消订单返还活动预订所需积分，订单ID：" + cmsActivityOrder.getActivityOrderId());
                    userIntegralDetail.setIntegralType(IntegralTypeEnum.RETURN_INTEGRAL.getIndex());
                    userIntegralDetailMapper.insertSelective(userIntegralDetail);
                    json = JSONResponse.toAppResultFormat(200, "success");
                }else{
                	json = JSONResponse.toAppResultFormat(500, "false");
                }
            }
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "false");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 评论积分(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/commentAddIntegralByJson", method = RequestMethod.POST)
    public String commentAddIntegralByJson(HttpServletResponse response,@RequestBody String jsonComment) throws IOException{
    	CmsComment cmsComment = JSON.parseObject(jsonComment, CmsComment.class);//把data数据解析成对象
    	String json = "";
		try {
			if (cmsComment != null) {
				int result = userIntegralDetailService.commentAddIntegral(cmsComment.getCommentUserId(), cmsComment.getCommentId());
				json = JSONResponse.toAppResultFormat(200, result);
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "积分添加失败");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 积分变动(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/updateIntegralByJson", method = RequestMethod.POST)
    public String updateIntegralByJson(HttpServletResponse response,@RequestBody String jsonUser) throws IOException{
    	UserIntegralDetail vo = JSON.parseObject(jsonUser, UserIntegralDetail.class);//把data数据解析成对象
    	String json = "";
		try {
			if (vo != null && vo.getUserId() != null) {
				UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(vo.getUserId());
				if(userIntegral!=null){
					List<UserIntegralDetail> detailList = new ArrayList<UserIntegralDetail>();
					if(vo.getUpdateType() == 1){
						Map<String,Object> data = new HashMap<String,Object>();
						data.put("integralType", vo.getIntegralType());
						data.put("integralFrom", vo.getIntegralFrom());
						data.put("integralId", userIntegral.getIntegralId());
						detailList = userIntegralDetailMapper.queryUserIntegralDetail(data);
					}
					if((vo.getUpdateType()==1&&detailList.size()==0)||vo.getUpdateType()==0){
						int integralChange = vo.getIntegralChange();
						if(vo.getChangeType() == 1){
							integralChange = -integralChange;
						}
						int result = this.updateUserNowIntegral(userIntegral, integralChange);
						if(result>0){
							UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
							userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
							userIntegralDetail.setCreateTime(new Date());
							userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
							userIntegralDetail.setIntegralChange(vo.getIntegralChange());
							userIntegralDetail.setChangeType(vo.getChangeType());
							userIntegralDetail.setIntegralFrom(vo.getIntegralFrom());
							userIntegralDetail.setIntegralType(vo.getIntegralType());
							userIntegralDetailMapper.insertSelective(userIntegralDetail);
						}
					}
					json = JSONResponse.toAppResultFormat(200, "success");
				}else{
					json = JSONResponse.toAppResultFormat(500, "userIntegral不存在");
				}
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "false");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    private int updateUserNowIntegral(UserIntegral userIntegral,int integralChange){
		Integer integralNow=userIntegral.getIntegralNow();
		Integer integralHis=userIntegral.getIntegralHis();
		integralNow+=integralChange;
		userIntegral.setIntegralNow(integralNow);
		if(integralChange>0){
			integralHis+=integralChange;
			userIntegral.setIntegralHis(integralHis);
		}
		return userIntegralMapper.updateByPrimaryKeySelective(userIntegral);
	}
    
    /**
     * 积分变动(扣减)(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/deleteIntegralByJson", method = RequestMethod.POST)
    public String deleteIntegralByJson(HttpServletResponse response,@RequestBody String jsonUser) throws IOException{
    	UserIntegralDetail vo = JSON.parseObject(jsonUser, UserIntegralDetail.class);//把data数据解析成对象
    	String json = "";
		try {
			if (vo != null && vo.getUserId() != null) {
				UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(vo.getUserId());
				if(userIntegral!=null){
					List<UserIntegralDetail> detailList = new ArrayList<UserIntegralDetail>();
					Map<String,Object> data = new HashMap<String,Object>();
					data.put("integralType", vo.getIntegralType());
					data.put("integralFrom", vo.getIntegralFrom());
					data.put("integralId", userIntegral.getIntegralId());
					detailList = userIntegralDetailMapper.queryUserIntegralDetail(data);
					
					if(detailList.size()>0){
						int result = this.deleteUserNowIntegral(userIntegral, vo.getIntegralChange());
						if(result>0){
							if(vo.getUpdateType() == 1){
								detailList.get(0).setIntegralFrom("(已扣)"+vo.getIntegralFrom());
								userIntegralDetailMapper.updateByPrimaryKeySelective(detailList.get(0));
							}
							
							UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
							userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
							userIntegralDetail.setCreateTime(new Date());
							userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
							userIntegralDetail.setIntegralChange(vo.getIntegralChange());
							userIntegralDetail.setChangeType(1);
							userIntegralDetail.setIntegralFrom(vo.getIntegralFrom());
							userIntegralDetail.setIntegralType(IntegralTypeEnum.DELETE_INTEGRAL.getIndex());
							userIntegralDetailMapper.insertSelective(userIntegralDetail);
						}
					}
					json = JSONResponse.toAppResultFormat(200, "success");
				}else{
					json = JSONResponse.toAppResultFormat(500, "userIntegral不存在");
				}
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "false");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    private int deleteUserNowIntegral(UserIntegral userIntegral,int integralChange){
		userIntegral.setIntegralNow(userIntegral.getIntegralNow() - integralChange);
		return userIntegralMapper.updateByPrimaryKeySelective(userIntegral);
	}
    
    /**
     * 转发积分(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/forwardingIntegralByJson", method = RequestMethod.POST)
    public String forwardingIntegralByJson(HttpServletResponse response,@RequestBody String jsonForwarding) throws IOException{
    	Map<String, String> map = JSON.parseObject(jsonForwarding, Map.class);//把data数据解析成对象
    	String json = "";
		try {
			userIntegralDetailService.forwardAddIntegral(map.get("userId"), map.get("url"));
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "积分添加失败");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 用户近30天积分列表(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/userIntegralDetailByJson", method = RequestMethod.POST)
    public String appUserIntegralDetailByJson(HttpServletResponse response,@RequestBody String jsonIntegralDetail) throws IOException{
    	Map<String, String> map = JSON.parseObject(jsonIntegralDetail, Map.class);//把data数据解析成对象
    	String json="";
		try {
	        if (StringUtils.isNotBlank(map.get("userId")) ) {
	        	PaginationApp pageApp = new PaginationApp();
		       	if(map.get("pageIndex")!=null&&map.get("pageNum")!=null){
		       		pageApp.setFirstResult(Integer.parseInt(map.get("pageIndex")));
		       	    pageApp.setRows(Integer.parseInt(map.get("pageNum")));
		       	}
		       	Calendar calendar = Calendar.getInstance();      
	        	calendar.setTime(new Date());      
	        	calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 30);      
	            Date beforeDate= calendar.getTime();  
	       	 
	            json=terminalUserAppService.queryUserIntegralDetail(pageApp,map.get("userId"),beforeDate);
	        } else {
	        	json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
	        }
		} catch (Exception e) {
		    e.printStackTrace();
		    json=JSONResponse.toAppResultFormat(0, "系统异常");
		}
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 用户详细积分列表(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/userIntegralDetailListByJson", method = RequestMethod.POST)
    public String userIntegralDetailListByJson(HttpServletResponse response,@RequestBody String jsonIntegralDetail) throws IOException{
    	Map<String, String> map = JSON.parseObject(jsonIntegralDetail, Map.class);//把data数据解析成对象
    	String json="";
    	try {
    		if (StringUtils.isNotBlank(map.get("userId")) ) {
	        	PaginationApp pageApp = new PaginationApp();
		       	if(map.get("pageIndex")!=null&&map.get("pageNum")!=null){
		       		pageApp.setFirstResult(Integer.parseInt(map.get("pageIndex")));
		       	    pageApp.setRows(Integer.parseInt(map.get("pageNum")));
		       	}
           
                json=terminalUserAppService.queryUserIntegralDetail(pageApp,map.get("userId"),null);
            } else {
                json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            json=JSONResponse.toAppResultFormat(0, "系统异常");
        }
   	 	response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null; 
    }
    
    /**
     * 直播点赞加积分(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/liveLikeAddIntegralByJson", method = RequestMethod.POST)
    public String liveLikeAddIntegralByJson(HttpServletResponse response,@RequestBody String jsonData) throws IOException{
    	CcpLiveUser liveUser = JSON.parseObject(jsonData, CcpLiveUser.class);//把data数据解析成对象
    	String json = "";
		try {
			if (liveUser != null) {
				
				String userId=liveUser.getUserId();
				String liveActivityId=liveUser.getLiveActivity();
				
				int result = userIntegralDetailService.liveLikeAddIntegral(userId, liveActivityId);
				
				json = JSONResponse.toAppResultFormat(200, result);
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "积分添加失败");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 直播评论加积分
     * @param response
     * @param jsonData
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/liveAddCommentByJson", method = RequestMethod.POST)
    public String liveAddCommentByJson(HttpServletResponse response,@RequestBody String jsonData) throws IOException{
    	CcpLiveMessage message = JSON.parseObject(jsonData, CcpLiveMessage.class);//把data数据解析成对象
    	String json = "";
		try {
			if (message != null) {
				
				int result = userIntegralDetailService.liveCommentAddIntegral(message);
				json = JSONResponse.toAppResultFormat(200, result);
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "积分添加失败");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 直播评论删除扣积分
     * @param response
     * @param jsonData
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/liveDeleteCommentByJson", method = RequestMethod.POST)
    public String liveDeleteCommentByJson(HttpServletResponse response,@RequestBody String jsonData) throws IOException{
    	CcpLiveMessage message = JSON.parseObject(jsonData, CcpLiveMessage.class);//把data数据解析成对象
    	String json = "";
		try {
			if (message != null) {
				
				int result = userIntegralDetailService.liveCommentDeleteIntegral(message);
				json = JSONResponse.toAppResultFormat(200, result);
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "积分扣除失败");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 删除评论积分(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/commentDeleteIntegralByJson", method = RequestMethod.POST)
    public String commentDeleteIntegralByJson(HttpServletResponse response,@RequestBody String jsonComment) throws IOException{
    	CmsComment cmsComment = JSON.parseObject(jsonComment, CmsComment.class);//把data数据解析成对象
    	String json = "";
		try {
			if (cmsComment != null) {
				int result = userIntegralDetailService.commentDeleteIntegral(cmsComment.getCommentUserId(), cmsComment.getCommentId());
				json = JSONResponse.toAppResultFormat(200, result);
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "积分扣除失败");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 获取用户积分(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/getUserIntegral", method = RequestMethod.POST)
    public String getUserIntegral(HttpServletResponse response,@RequestBody String jsonUser) throws IOException{
    	CmsTerminalUser terminalUser = JSON.parseObject(jsonUser, CmsTerminalUser.class);//把data数据解析成对象
    	String json = "";
		try {
			if (terminalUser != null && terminalUser.getUserId() != null) {
				UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(terminalUser.getUserId());
				if(userIntegral!=null){
					json = JSONResponse.toAppResultFormat(200, userIntegral);
				}else{
					json = JSONResponse.toAppResultFormat(500, "userIntegral不存在");
				}
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "false");
		}
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
}
