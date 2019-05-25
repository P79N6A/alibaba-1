package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.contest.CcpContestAnswer;
import com.culturecloud.model.bean.contest.CcpContestQuestion;
import com.sun3d.why.dao.dto.CcpContestTopicQuestionDto;
import com.sun3d.why.model.CmsUserAnswer;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpContestTopicQuestionService;
import com.sun3d.why.util.Pagination;

@Controller
@RequestMapping("/contestTopicQuestion")
public class CcpContestTopicQuestionController {
	
	@Autowired
	private CcpContestTopicQuestionService contestTopicQuestionService;
	
	@Autowired
	private HttpSession session;
	  
	@RequestMapping("/managerTopicQuestion")
	public ModelAndView managerTopicQuestion(@RequestParam String topicId, Pagination page){
		 
		 ModelAndView model = new ModelAndView();
		 
		 List<CcpContestTopicQuestionDto> contestTopicQuestionList=contestTopicQuestionService.queryCcpContestTopicQuestions(topicId, page);
		 
		 model.addObject("contestTopicQuestionList", contestTopicQuestionList);
         model.addObject("page", page);
         model.addObject("topicId", topicId);
		 
		 model.setViewName("admin/contest/managerTopicQuestion");
		 
		 return model;
	 }
	
	  @RequestMapping("/preAddContestQuestion")
	  public ModelAndView preAddContestQuestion(@RequestParam String topicId){
		
		  ModelAndView model = new ModelAndView();
		  
	      model.addObject("topicId", topicId);
	      model.setViewName("admin/contest/addContestQuestion");
	        
	      return model;
	  }
	  
	  @RequestMapping("/addContestQuestion")
	  @ResponseBody
	  public String addContestQuestion(@RequestParam String topicId,
			  CcpContestQuestion question,
			  String[] answerText,String []answerPicUrl,String []isTrueCheck){
		  
		  try {
	            SysUser loginUser = (SysUser)session.getAttribute("user");
	            
	            if (loginUser == null) {
	                return "user";
	            }
	            
	            contestTopicQuestionService.saveCcpContestQuestion(question, topicId, answerPicUrl, answerText, isTrueCheck);
	            
	            return "success";
	        } catch (Exception ex) {
	            ex.printStackTrace();
	            return "error";
	        }
	  }   
	  
	  @RequestMapping("/preEditContestQuestion")
	  public ModelAndView preEditContestQuestion(@RequestParam String questionId,@RequestParam String topicId){
		
		  ModelAndView model = new ModelAndView();
		  
		  CcpContestQuestion question =contestTopicQuestionService.queryCcpContestQuestionById(questionId);

		 List<CcpContestAnswer> answers= contestTopicQuestionService.queryQuestionAnswer(questionId);
		  
		    model.addObject("question", question);
		    
		    model.addObject("topicId", topicId);
		    
		    model.addObject("answers", answers);
		 
	      model.setViewName("admin/contest/editContestQuestion");
	     return model;
	  }
	  
	  @RequestMapping("/userMessage")
	  public ModelAndView userMessage(@RequestParam String topicId,Pagination page,CmsUserAnswer cmsUserAnswer){
		  ModelAndView model=new ModelAndView();
		  List<CmsUserAnswer> userAnswersList=contestTopicQuestionService.queryUserMessage(topicId,page,cmsUserAnswer);
		  model.addObject("userAnswersList",userAnswersList);
		  model.addObject("topicId", topicId);
		  model.addObject("page", page);
		  model.addObject("cmsUserAnswer", cmsUserAnswer);
		  model.setViewName("admin/contest/userMessage");
		  return model;
	  }
	  
	  
}


