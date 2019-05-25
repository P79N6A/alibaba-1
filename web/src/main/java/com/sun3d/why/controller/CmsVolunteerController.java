package com.sun3d.why.controller;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;
import com.culturecloud.model.request.volunteer.SaveVolunteerApplyVO;
import com.culturecloud.model.request.volunteer.VolunteerRecruitDetailVO;
import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.dao.dto.CcpVolunteerApplyDto;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpVolunteerApplyService;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.QRCode;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@RequestMapping("/volunteer")
@Controller
public class CmsVolunteerController {
	private Logger logger = LoggerFactory.getLogger(CmsVolunteerController.class);
	private static final String VOLUNTEER_H5_PATH = "wechatStatic/toVolunteerDetail.do?recruitId=";
	private static final String REDIS_PREFIX = "WjVolunteerQrCode-";
	@Autowired
	private HttpSession session;
	@Autowired
	private StaticServer staticServer;
	@Autowired
	private BasePath basePath;
	@Autowired
	private CacheService cacheService;
	@Autowired
	private CcpVolunteerApplyService ccpVolunteerApplyService;
	
	
	/**志愿者招募首页
     * @return
     */
    @RequestMapping("/volunteerRecruitIndex")
    public String volunteerRecruitIndex(){
        return "index/volunteer/recruitList";
    }
    
    /**
     * 招募列表
     * @return
     */
    @RequestMapping(value = "/getVolunteerRecruitList")
    public String getVolunteerRecruitList(HttpServletResponse response) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"volunteerRecruit/recruitList","{}");
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 详情页跳转
     * @param recruitId
     * @return
     */
    @RequestMapping(value = "/toVolunteerDetail")
    public ModelAndView toVolunteerDetail(String recruitId,String recruitName){
    	ModelAndView model = new ModelAndView();
    	model.addObject("recruitId", recruitId);
    	try{
        	model.addObject("recruitName", URLDecoder.decode(URLDecoder.decode(recruitName, "UTF-8"), "UTF-8"));
        } catch (Exception e){
        	model.addObject("recruitName", "");
        	e.printStackTrace();
        }
    	model.setViewName("index/volunteer/recruitDetail");
    	return model;
    }
    /**
     * 获得志愿者详情
     * @param recruitId
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getVolunteerDetail")
    public String getVolunteerDetail(@RequestParam String recruitId,HttpServletResponse response) throws Exception{
    	VolunteerRecruitDetailVO requestVO=new VolunteerRecruitDetailVO();
    	requestVO.setRecruitId(recruitId);
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"volunteerRecruit/recruitDetail",requestVO);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * 获取H5链接的二维码
     * @param recruitId
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getVolunteerDetailCode")
    @ResponseBody
    public String getVolunteerDetailCode(String recruitId,HttpServletRequest request) throws Exception{
    	if (cacheService.isExistKey(REDIS_PREFIX + recruitId)){
    		String resultString = cacheService.getValueByKey(REDIS_PREFIX + recruitId);
    		return resultString;
    	}
    	//生成二维码的内容路径
    	StringBuffer textString = new StringBuffer();
    	String path = request.getContextPath();
        textString.append(request.getScheme() + "://" + request.getServerName() + path + "/");
        textString.append(VOLUNTEER_H5_PATH).append(recruitId);
    	//封装二维码路径生成二维码图片
        StringBuffer sb = new StringBuffer();
        sb.append(basePath.getBasePath());
        sb.append("/wjVolunteer/");
        sb.append(recruitId);
        sb.append(".jpg");
        QRCode.create_image(textString.toString(), sb.toString(),300);
        //返回
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append(staticServer.getStaticServerUrl());
        stringBuffer.append("/wjVolunteer/");
        stringBuffer.append(recruitId);
        stringBuffer.append(".jpg");
        //存入redis
        cacheService.setValueToRedis(REDIS_PREFIX + recruitId, stringBuffer.toString(), null);
        return stringBuffer.toString();	
    }
    /**
	 * 我要报名 创建申请人
	 * 
	 * @param recruitId
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/toVoluJoin")
	public String toVoluJoin(String recruitId, HttpServletRequest request) {

		request.setAttribute("recruitId", recruitId);

		return "index/volunteer/voluJoin";
	}	
	@RequestMapping(value = "/saveVolunteerApply")
	@EmojiInspect
	public String saveVolunteerApply(CcpVolunteerApply acpVolunteerApply, String[] volunteerApplyPic,
			HttpServletResponse response) throws Exception {

		SaveVolunteerApplyVO requestVO = new SaveVolunteerApplyVO();

		requestVO.setAcpVolunteerApply(acpVolunteerApply);
		requestVO.setVolunteerApplyPic(volunteerApplyPic);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "volunteerRecruit/applyVolunteer", requestVO);

		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	/**
     * 我的报名
     * @return
     */
    @RequestMapping("/queryMyVolunEnroll")
    public ModelAndView queryMyVolunEnroll(Pagination page){
        ModelAndView modelAndView = new ModelAndView();
        page.setRows(5);
        //获取用户信息
        CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");        
        if(null==user){
            return new ModelAndView("redirect:/frontTerminalUser/userLogin.do");            
        }
        List<CcpVolunteerApplyDto> volunDtoList=ccpVolunteerApplyService.queryCcpVolunteerApply(user.getUserId(), page);
        modelAndView.addObject("volunList",volunDtoList);
        modelAndView.addObject("page",page);
        modelAndView.setViewName("/index/userCenter/myVolunEnroll");
        return modelAndView;
    }

}
