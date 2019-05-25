package com.sun3d.why.controller.wechat;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.dao.dto.QygProjectEntryDto;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.qyg.QygProjectEntry;
import com.sun3d.why.model.qyg.QygUser;
import com.sun3d.why.model.qyg.QygVote;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.QygProjectEntryService;
import com.sun3d.why.service.QygSuggestionService;
import com.sun3d.why.service.QygVoteService;
import com.sun3d.why.util.BindWS;

@RequestMapping("/wechatQyg")
@Controller
public class WechatQygController {
	
	@Autowired
    private CacheService cacheService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private QygVoteService qygVoteService;
    @Autowired
    private QygProjectEntryService qygProjectEntryService;
    
    private Date voteEndTime;
	
    private Logger logger = LoggerFactory.getLogger(WechatQygController.class);
    
    public WechatQygController() {
    	
    	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	   
    	try {
			voteEndTime = df.parse("2017-01-13 17:00:00");
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	
	}
    
    
    /**
     * 配送中心H5首页
     * @param request
     * @param tab
     * @return
     * @throws ParseException
     */
	@RequestMapping(value = "/index")
	public String index(HttpServletRequest request,Integer tab)throws ParseException{
		//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("tab", tab);
        if(tab != null){
        	if(tab == 0){
            	request.setAttribute("entrySubject", "文艺演出");
            }else if(tab == 1){
            	request.setAttribute("entrySubject", "艺术导赏");
            }else if(tab == 2){
            	request.setAttribute("entrySubject", "展览展示");
            }else if(tab == 3){
            	request.setAttribute("entrySubject", "特色活动");
            }else{
            	request.setAttribute("entrySubject", "文艺演出");
            }
        }else{
        	request.setAttribute("entrySubject", "文艺演出");
        }
      
		if(voteEndTime.before(new Date())) {
			request.setAttribute("noVote", 1);
       }
//		time = df.parse("2017-01-08 20:00:00");
//		if(time.before(new Date())) {
//			request.setAttribute("showRanking", 1);
//        }
        
		/*if(startTime.before(new Date())) {*/
			  return "wechat/static/qyg/index";
      }
        /*}
		}
		else
			return "wechat/static/qyg/commingsoon";

		 return "wechat/static/qyg/index";
	}
	
	
	/**
     * 跳转配送中心H5详情页面
     * @param request
     * @return
     * @throws ParseException 
     */
    @RequestMapping(value = "/toDetail")
    public String toDetail(HttpServletRequest request,String entryId) throws ParseException {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("entryId", entryId);
        QygProjectEntryDto entry=qygProjectEntryService.queryUserById(entryId);
        request.setAttribute("entry", entry);
        
		if(voteEndTime.before(new Date())) {
			request.setAttribute("noVote", 1);
        }
        return "wechat/static/qyg/detail";
    }
	
    /**
     * 跳转配送中心H5排名页面
     * @param request
     * @return
     */
    @RequestMapping(value = "/toRanking")
    public String toRanking(HttpServletRequest request,Integer tab) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("tab", tab);
        if(tab != null){
        	if(tab == 0){
            	request.setAttribute("entrySubject", "文艺演出");
            }else if(tab == 1){
            	request.setAttribute("entrySubject", "艺术导赏");
            }else if(tab == 2){
            	request.setAttribute("entrySubject", "展览展示");
            }else if(tab == 3){
            	request.setAttribute("entrySubject", "特色活动");
            }else{
            	request.setAttribute("entrySubject", "文艺演出");
            }
        }else{
        	request.setAttribute("entrySubject", "文艺演出");
        }
    	if(voteEndTime.before(new Date())) {
			request.setAttribute("noVote", 1);
        }
    	
        return "wechat/static/qyg/ranking";
    }
    
	/**
     * 获取配送中心H5列表
     * @return
     */
    @RequestMapping(value = "/queryQyglist")
    @ResponseBody
    public List<QygProjectEntryDto> queryDclist(QygProjectEntryDto entry){
    	List<QygProjectEntryDto> list = null;
    	try {
			list = qygProjectEntryService.queryEntryList(entry);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return list;
    }
	
	
    /**
     * 打开投票规则页面
     * @return
     */
    @RequestMapping(value = "/voteRule")
    public String voteRule(HttpServletRequest request){
    	//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
    	return "wechat/static/qyg/rule";
    }
    
    
    /**
     * 打开赛事公告页面
     * @return
     */
    @RequestMapping(value = "/announcement")
    public String announcement(HttpServletRequest request){
    	//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
    	return "wechat/static/qyg/info";
    }
    
    /**
     * 配送中心H5投票
     * @param request
     * @return
     */
    @RequestMapping(value = "/addVote")
    @ResponseBody
    public String addVote(QygVote vo) {
         String saveQygVote = qygVoteService.saveQygVote(vo);
         return saveQygVote;
    }
    
    @RequestMapping("/insertQygUser")
    @ResponseBody
    public String insertQygUser(QygUser user,String entryId){
    	int rs=qygProjectEntryService.saveQygUser(user);
    	if(rs>0){
    		if(StringUtils.isNotBlank(entryId)){
    			QygVote vote=new QygVote();
    			vote.setEntryId(entryId);
    			vote.setUserId(user.getUserId());
    			
    			 qygVoteService.saveQygVote(vote);
    		}
    		return "success";
    	}else{
    		return "error";
    	}
    }
    
    /**
     * 2016年配送中心目录跳转
     * @return
     */
    @RequestMapping("/qygList2016")
    public String ListCatalog(HttpServletRequest request){
    	//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
    	return "wechat/static/qyg/qygList2016";
    }
    
    /**
     * 2017年配送中心目录跳转
     * @return
     */
    @RequestMapping("/qygList2017")
    public String CultureListCatalog(HttpServletRequest request){
    	//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
    	return "wechat/static/qyg/qygList2017";
    }
    
}
