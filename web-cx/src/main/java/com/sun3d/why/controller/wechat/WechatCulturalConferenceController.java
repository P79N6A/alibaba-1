package com.sun3d.why.controller.wechat;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.dao.CcCommentMapper;
import com.sun3d.why.dao.CcUserInfoMapper;
import com.sun3d.why.dao.CcUserSignMapper;
import com.sun3d.why.model.CcComment;
import com.sun3d.why.model.CcUserInfo;
import com.sun3d.why.model.CcUserSign;
import com.sun3d.why.model.CmsUserCnAnswer;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.UUIDUtils;

/**
 * 互联网+公共文化服务会议
 * @author demonkb
 */
@RequestMapping("/cc")
@Controller
public class WechatCulturalConferenceController {

    @Autowired
    private CacheService cacheService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CcUserSignMapper ccUserSignMapper;
    @Autowired
    private CcUserInfoMapper ccUserInfoMapper;
    @Autowired
    private CcCommentMapper ccCommentMapper;

    private Logger logger = LoggerFactory.getLogger(WechatCulturalConferenceController.class);

    /**
     * 跳转到互联网+公共文化服务会议首页
     * @param request
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/static/cc/index";
    }
    
    /**
     * 跳转到列表
     * @param request
     * @return
     */
    @RequestMapping(value = "/list")
    public String list(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/static/cc/list";
    }
    
    /**
     * 跳转到签到
     * @param request
     * @return
     */
    @RequestMapping(value = "/sign")
    public String sign(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/static/cc/sign";
    }
    
    /**
     * 跳转到信息查询
     * @param request
     * @param type (1：住宿房间号；2：参观跟车号；3：餐饮分桌号)
     * @return
     */
    @RequestMapping(value = "/toInfoSearch")
    public String toInfoSearch(HttpServletRequest request, String type) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        
        request.setAttribute("type", type);
        return "wechat/static/cc/infoSearch";
    }
    
    /**
     * 跳转到查询结果
     * @param request
     * @param type (1：住宿房间号；2：参观跟车号；3：餐饮分桌号)
     * @return
     */
    @RequestMapping(value = "/toInfoResult")
    public String toInfoResult(HttpServletRequest request, String type ,CcUserInfo vo) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        
        request.setAttribute("type", type);
        CcUserInfo ccUserInfo = ccUserInfoMapper.queryUserInfo(vo);
        if(ccUserInfo!=null){
        	if(type.equals("1")){
            	request.setAttribute("result", ccUserInfo.getHouseNum());
            }else if(type.equals("2")){
            	request.setAttribute("result", ccUserInfo.getCarNum());
            }else if(type.equals("3")){
            	request.setAttribute("result", ccUserInfo.getRestNum());
            }
        }else{
        	request.setAttribute("result", "未查到");
        }
        return "wechat/static/cc/infoResult";
    }
    
    /**
     * 保存用户签到信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveUserSign")
    @EmojiInspect
    @ResponseBody
    public String saveUserSign(HttpServletRequest request,CcUserSign vo) {
    	int result = 1;
		try {
			CcUserSign ccUserSign = ccUserSignMapper.selectByPrimaryKey(vo.getUserId());
			if(ccUserSign!=null){
				return  "repeat";
			}else{
				vo.setCreateTime(new Date());
				result = ccUserSignMapper.insert(vo);
			}
			if(result == 1){
			    return  "200";
			}else{
			    return  "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "500";
		}
    }
    
    /**
     * 评论列表
     * return
     */
    @RequestMapping(value = "/getAllCcComment")
    @ResponseBody
    public List<CcComment> getAllCcComment(HttpServletResponse response) throws Exception {
    	return ccCommentMapper.queryAllCcComment();
    }
    
    /**
     * 保存用户评论信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveComment")
    @EmojiInspect
    @ResponseBody
    public String saveComment(HttpServletRequest request,CcComment vo) {
    	int result = 1;
		try {
			vo.setCommentId(UUIDUtils.createUUId());
			vo.setCreateTime(new Date());
			result = ccCommentMapper.insert(vo);
			if(result == 1){
			    return  "200";
			}else{
			    return  "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "500";
		}
    }
    
}
