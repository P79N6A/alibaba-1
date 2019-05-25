package com.sun3d.why.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsCommentService;
import com.sun3d.why.service.CmsCulturalOrderService;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping("/culturalOrder")
@Controller
public class CmsCulturalOrderController {
    private Logger logger = LoggerFactory.getLogger(CmsCulturalOrderController.class);
    
    @Autowired
    private HttpSession session;
    
    @Autowired
    private CmsCulturalOrderService cmsCulturalOrderService;
    
    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;
    
    @Autowired
    private CmsCommentService commentService;
    
    @Autowired
    private CmsTeamUserService cmsTeamUserService;
    /**
     * 文化云3.1前端首页
     *
     * @return
     */
    @RequestMapping("/culturalOrderIndex")
    public String cultureOrderIndex(HttpServletRequest request) {
        return "index/culturalOrder/culturalOrderIndex";
    }
    
    /**
     * 根据largeType显示页面
     */
    @RequestMapping("/showCulturalOrderIndexByLargeType")
    public String showCulturalOrderIndexByLargeType(Integer largeType){
    	if(largeType == 1){
    		return "index/culturalOrder/culturalOrderIndex";
    	}else{
    		return "index/culturalOrder/culturalOrderIndexAnother";
    	}
    }
    
    
    /**
     * 文化云3.4前端   首页活动列表查询
     *
     * @return
     */
    @RequestMapping("/culturalOrderList")
    @ResponseBody
    public String cultureOrderList(HttpServletRequest request, CmsCulturalOrder culturalOrder, Pagination page) {
        JSONObject jsonObject = new JSONObject();
        try {
        	Integer sortType = Integer.valueOf(request.getParameter("culturalOrderSortType"));
        	Integer pageIndex = Integer.valueOf(request.getParameter("pageIndex"));
        	page.setPage(pageIndex);
            page.setRows(12);
            List<CmsCulturalOrder> culturalOrderList = cmsCulturalOrderService.queryCulturalOrderList(culturalOrder, page, sortType,null);
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            if(culturalOrderList.size() > 0){
            	for(CmsCulturalOrder order : culturalOrderList){
            		if(order.getCulturalOrderLargeType() == 1){
            			if(order.getStartDate() != null){
                			String startDateStr = formatter.format(order.getStartDate());
                			order.setStartDateStr(startDateStr);
                		}
                		if(order.getEndDate() != null){
                			String endDateStr = formatter.format(order.getEndDate());
                			order.setEndDateStr(endDateStr);
                		}
            		}else{
            			if(order.getCulturalOrderStartDate() != null){
                			String startDateStr = formatter.format(order.getCulturalOrderStartDate());
                			order.setStartDateStr(startDateStr);
                		}
                		if(order.getCulturalOrderEndDate() != null){
                			String endDateStr = formatter.format(order.getCulturalOrderEndDate());
                			order.setEndDateStr(endDateStr);
                		}
            		}
            	}
            }
            jsonObject.put("list", culturalOrderList);
            jsonObject.put("page", page);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return jsonObject.toString();
    }
    
    
    /**
     * 显示详情
     * @param culturalOrderId
     * @param culturalOrderLargeType
     * @param userId
     * @return
     */
    @RequestMapping(value="/culturalOrderDetail")
    public ModelAndView culturalOrderDetail(HttpServletRequest request, String culturalOrderId, Integer culturalOrderLargeType){
    	ModelAndView mv = new ModelAndView();
    	String userId = null;
    	CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
    	if (user != null){
    		userId = user.getUserId();
    	}
    	CmsCulturalOrder order = cmsCulturalOrderService.queryCulturalOrderById(culturalOrderId, culturalOrderLargeType, userId);
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        	
    	if(culturalOrderLargeType == 1){
    		if(order.getStartDate() != null){
    			String startDateStr = formatter.format(order.getStartDate());
    			order.setStartDateStr(startDateStr);
    		}
    		if(order.getEndDate() != null){
    			String endDateStr = formatter.format(order.getEndDate());
    			order.setEndDateStr(endDateStr);
    		}
    		mv.setViewName("index/culturalOrder/culturalOrderDetail");
    	}else{
    		if(order.getCulturalOrderStartDate() != null){
    			String startDateStr = formatter.format(order.getCulturalOrderStartDate());
    			order.setStartDateStr(startDateStr);
    		}
    		if(order.getCulturalOrderEndDate() != null){
    			String endDateStr = formatter.format(order.getCulturalOrderEndDate());
    			order.setEndDateStr(endDateStr);
    		}
    		Date start = order.getCulturalOrderStartDate();
            String markedDates = formatter.format(order.getCulturalOrderStartDate());
            while(start.getTime() < order.getCulturalOrderEndDate().getTime()){
                start = new Date(start.getTime() + 86400000);
                markedDates += "," + formatter.format(start);
            }
    		mv.addObject("markedDates", markedDates);
    		mv.setViewName("index/culturalOrder/culturalOrderDetailAnother");
    	}
    	CmsComment comment = new CmsComment();
    	comment.setCommentType(30);
    	comment.setCommentRkId(culturalOrderId);
    	Integer commentCount = commentService.queryCommentCountByCondition(comment);
    	mv.addObject("commentCount", commentCount);
		mv.addObject("culturalOrder", order);
    	return mv;
    }
    
    //前台详情显示评论列表
    @RequestMapping(value = "/commentList")
    @ResponseBody
    public List<CmsComment> commentList(CmsComment cmsComment, Integer pageNum, Pagination page) {
        //评论列表
        page.setRows(10);
        page.setPage(pageNum);
        cmsComment.setCommentState(1);
        List<CmsComment> commentList = commentService.queryCommentByCondition(cmsComment, page, null);
        return commentList;
    }
    
    @RequestMapping(value="isTeamUser")
    @ResponseBody
    public String isTeamUser(HttpServletRequest request){
    	 CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
    	 if(user != null){
			 CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
	    	 applyJoinTeam.setApplyCheckState(3);
	   		 applyJoinTeam.setUserId(user.getUserId());
	   		 int ct = cmsTeamUserService.queryMyManagerTeamUserCount(applyJoinTeam,2,1);
	   		 if (ct > 0) {
	   			 return Constant.RESULT_STR_SUCCESS;
			 }else {
				 return Constant.RESULT_STR_FAILURE;
			 }   
    	 } else {
    		 return Constant.RESULT_STR_NOACTIVE;
    	 }  
    }
    
}
