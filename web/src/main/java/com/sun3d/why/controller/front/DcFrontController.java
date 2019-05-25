package com.sun3d.why.controller.front;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.DcFrontUser;
import com.sun3d.why.model.DcVideo;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.DcFrontService;
import com.sun3d.why.service.DcVideoService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping("/dcFront")
@Controller
public class DcFrontController {
@Resource
private DcFrontService dcFrontService;
@Resource
private DcVideoService dcVideoService;
@Resource
private StaticServer staticServer;

    /**
     * 配送登陆页
     *
     *
     * @return
     */
    @RequestMapping(value = "/login")
    public ModelAndView login (){
        ModelAndView model = new ModelAndView();
        model.setViewName("index/dc/login");
        return model;
    }

    /**
     * 配送用戶登陆
     *
     *
     * @return
     */
    @RequestMapping(value = "/toLogin", method = RequestMethod.POST)
    @ResponseBody
    public String toLogin(DcFrontUser user, HttpServletRequest request) {
        return dcFrontService.login(user, request.getSession());
    }

    

	 /**
    * 配送列表页
    *
    *
    * @return
    */
   @RequestMapping(value = "/dcVideoList")
   public ModelAndView dcVideoList (DcVideo dcVideo,Pagination page,HttpServletRequest request){
	   
       ModelAndView model = new ModelAndView();
       
       String userId=dcVideo.getUserId();
       
       if(StringUtils.isBlank(userId)){
    	   
    	   Object sessionDcUser=request.getSession().getAttribute("dcUser");
    	   
    	   if(sessionDcUser!=null)
    	   {
    		   DcFrontUser loginUser=(DcFrontUser) sessionDcUser;
    		   userId=loginUser.getUserId();
    		   
    		   dcVideo.setUserId(userId);
    	   }
       }
       
       if(StringUtils.isNotBlank(userId)){

    	 List<DcVideo> list= dcVideoService.queryDcVideoByCondition(dcVideo, page);
    	      
    	 model.addObject("list", list);
    	 
    	 model.addObject("page", page);
       }
       model.setViewName("index/dc/list");
       return model;
   }
   
   /**
    * 上传视频
    * 
	 * @return
	 */
	@RequestMapping(value = "/uploadDcVideo")
	public ModelAndView uploadDcVideo(String videoId){
		   
		ModelAndView model = new ModelAndView();
		
		if(StringUtils.isNotBlank(videoId)){
			
			DcVideo dcVideo=dcVideoService.queryDcVideoByVideoId(videoId);
			   
			model.addObject("video", dcVideo);
		}
		   
	
		model.addObject("aliImgUrl", staticServer.getAliImgUrl());
		   
		model.setViewName("index/dc/dcVideo");
	    return model;
	}	   
	
	@RequestMapping(value = "/saveDcVideo")
	@ResponseBody
	public String saveDcVideo(DcVideo dcVideo,HttpServletRequest request){
		
		Object sessionDcUser=request.getSession().getAttribute("dcUser");
   	   
   	   if(sessionDcUser!=null)
   	   {
   		   DcFrontUser loginUser=(DcFrontUser) sessionDcUser;
   		
   		   return dcVideoService.saveDcVideo(dcVideo, loginUser);
   	   }
   	   else
		
   		   return "login";
	} 
	
	@RequestMapping(value = "/deleteDcVideo")
	@ResponseBody
	public String deleteDcVideo(String videoId,HttpServletRequest request){
		
		Object sessionDcUser=request.getSession().getAttribute("dcUser");
   	   
   	   if(sessionDcUser!=null)
   	   {
   		
   		   return dcVideoService.deleteDcVideo(videoId);
   	   }
   	   else
		
   		   return "login";
	}  
	
	@RequestMapping(value = "/logout")
	@ResponseBody
	public String logout(HttpServletRequest request){
		
		request.getSession().removeAttribute("dcUser");
		
		return Constant.RESULT_STR_SUCCESS;
	}  
	
	@RequestMapping(value = "/saveSuccess")
	public String saveSuccess(){
		return "index/dc/success";
	}
}
