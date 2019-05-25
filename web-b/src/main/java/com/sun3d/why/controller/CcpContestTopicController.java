package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.contest.CcpContestTemplate;
import com.culturecloud.model.bean.contest.CcpContestTopic;
import com.culturecloud.model.bean.contest.CcpContestTopicPass;
import com.sun3d.why.dao.dto.CcpContestTopicDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpContestTemplateService;
import com.sun3d.why.service.CcpContestTopicService;
import com.sun3d.why.util.Pagination;


/**
 * 主题 controller
 * @author zhangshun
 *
 */
@Controller
@RequestMapping("/contestTopic")
public class CcpContestTopicController {
	
	  private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	 @Autowired
	 private HttpSession session;
	 
	 @Autowired
	 private StaticServer staticServer;
	  
	 @Autowired
	 private CcpContestTopicService contestTopicService;
	 
	 @Autowired
	 private CcpContestTemplateService contestTemplateService;

	  @RequestMapping("/contestTopicIndex")
	  public ModelAndView contestTopicIndex(CcpContestTopic topic, Pagination page) {
	        ModelAndView model = new ModelAndView();
	        try {
	            
	            List<CcpContestTopicDto> contestTopicList=contestTopicService.queryCcpContestTopic(topic, page);

	            model.addObject("contestTopicList", contestTopicList);
	            model.addObject("page", page);
	            model.addObject("topic", topic);
	            model.setViewName("admin/contest/contestTopicIndex");
	        } catch (Exception e) {
	            logger.error("contestTopicIndex error {}", e);
	        }
	        return model;
	    }  
	  
	/** 
	 * 智力竞赛首页
	 * @param topic
	 * @param page
	 * @return
	 */
	@RequestMapping("/contestQuizIndex")
	public ModelAndView contestQuizIndex(CcpContestTopic topic, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
        	
        	 SysUser loginUser = (SysUser)session.getAttribute("user");
        	 
        	 if(loginUser!=null)
        	 {
        		 if(loginUser.getUserIsManger()==null||loginUser.getUserIsManger()!=1)
            	 {
            		 topic.setCreateSysUserId(loginUser.getUserId());
            	 }
            	 topic.setTopicStatus(3);
                
                List<CcpContestTopicDto> contestTopicList=contestTopicService.queryCcpContestTopic(topic, page);

                model.addObject("contestTopicList", contestTopicList);
                model.addObject("page", page);
                model.addObject("topic", topic);
                model.setViewName("admin/contestQuiz/contestQuizIndex");
        	 }
        	 else
        		 model.setViewName("admin/main");
        	 
        	 
        } catch (Exception e) {
            logger.error("contestTopicIndex error {}", e);
        }
        return model;
    }    
	  
	 @RequestMapping("/preAddContestQuiz")
	  public ModelAndView preAddContestQuiz(){
		
		  ModelAndView model = new ModelAndView();
		  String aliImgUrl=staticServer.getAliImgUrl();
	    	
		  model.addObject("aliImgUrl", aliImgUrl);
	    	
	        model.setViewName("admin/contestQuiz/addContestQuiz");
	        return model;
	  }
	 
	  @RequestMapping("/preEditContestQuiz")
	  public ModelAndView preEditContestQuiz(@RequestParam String topicId){
		
		  ModelAndView model = new ModelAndView();
		  
		  CcpContestTopic contestTopic=contestTopicService.queryCcpContestTopicById(topicId);
		  
		  String templateId=contestTopic.getTemplateId();
		  
		  if(StringUtils.isNotBlank(templateId))
		  {
			  CcpContestTemplate template= contestTemplateService.selectContestTemplateById(templateId);
			  
			  model.addObject("template", template);
		  }
		  
		  model.addObject("contestTopic", contestTopic);
		  
		  String aliImgUrl=staticServer.getAliImgUrl();
	    	
		  model.addObject("aliImgUrl", aliImgUrl);
		  
	      model.setViewName("admin/contestQuiz/addContestQuiz");
	     return model;
	  }
	  
	  
	  @RequestMapping("/preAddContestTopic")
	  public ModelAndView preAddContestTopic(){
		
		  ModelAndView model = new ModelAndView();
	        model.setViewName("admin/contest/addContestTopic");
	        return model;
	  }
	  
	  @RequestMapping("/preEditContestTopic")
	  public ModelAndView preEditContestTopic(@RequestParam String topicId){
		
		  ModelAndView model = new ModelAndView();
		  
		  CcpContestTopic contestTopic=contestTopicService.queryCcpContestTopicById(topicId);
		  
		 List<CcpContestTopicPass> passList= contestTopicService.queryCcpContestTopicPassByTopicId(topicId);
		  
		  model.addObject("contestTopic", contestTopic);
		  
		  model.addObject("passList", passList);
		  
	      model.setViewName("admin/contest/editContestTopic");
	     return model;
	  }
	  
	  
	/**
	 * 保存文化竞赛
	 * @param topic
	 * @param passNameTopic
	 * @param passNumber
	 * @param passName
	 * @return
	 */
	@RequestMapping("/addContestTopic")
	  @ResponseBody
	  public String addContestTopic(CcpContestTopic topic,String passNameTopic,Integer[] passNumber,String []passName){
		  
		  try {
	            SysUser loginUser = (SysUser)session.getAttribute("user");
	            
	            if (loginUser == null) {
	                return "user";
	            }
	            
	            topic.setPassName(passNameTopic);
	            
	            contestTopicService.saveContestTopic(topic,passNumber,passName, loginUser);
	            
	            return "success";
	        } catch (Exception ex) {
	            logger.error("addContestTopic action error {}", ex);
	            ex.printStackTrace();
	            return "error";
	        }
	  }   
	
	@RequestMapping("/addContestQuiz")
	  @ResponseBody
	  public String addContestQuiz(CcpContestTopic topic,Integer selectTemplate,String coverImgUrl,String backgroundImgUrl){
		  
		  try {
	            SysUser loginUser = (SysUser)session.getAttribute("user");
	            
	            if (loginUser == null) {
	                return "user";
	            }
	            CcpContestTemplate template=null;
	            
	            if(selectTemplate!=null)
	            {
	            	// 自定义模板
	            	if(selectTemplate==2){
	            		
	            		template=new CcpContestTemplate();
	            		template.setTemplateId(topic.getTemplateId());
	            		template.setCoverImgUrl(coverImgUrl);
	            		template.setBackgroundImgUrl(backgroundImgUrl);
	            	}
	            }
	            
	            contestTopicService.saveContestQuiz(topic,template, loginUser);
	            
	            return "success";
	        } catch (Exception ex) {
	            logger.error("addContestQuiz action error {}", ex);
	            ex.printStackTrace();
	            return "error";
	        }
	  }   
	  
	  
	/**
	 * 上架下架
	 * @param topicId
	 * @return
	 */
	  @RequestMapping(value="/topicStatusChange")
	  @ResponseBody
	  public String topicStatusChange(@RequestParam String topicId) {
	        try {
	            SysUser loginUser = (SysUser)session.getAttribute("user");
	            
	            if (loginUser == null) {
	                return "user";
	            }
	           
	            int rs = this.contestTopicService.topicStatusChange(topicId, loginUser);
	            
	            if(rs>0)
	            	return "success";
	            
	        } catch (Exception e) {
	            this.logger.error("update error {}", e);
	            return "error";
	        }
	        return "error";
	    }
	  
	
	
}
