package com.sun3d.why.controller.wechat;

import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.culturecloud.enumeration.operation.OperatFunction;
import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.culturecloud.model.request.association.AssociationActivityVO;
import com.culturecloud.model.request.association.AssociationResourceListVO;
import com.culturecloud.model.request.association.GetAssociationDetailVO;
import com.culturecloud.model.request.association.SaveCcpAssociationFlowerVO;
import com.sun3d.why.annotation.SysBusinessLog;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpAssociationService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.CollectAppService;

@RequestMapping("/wechatAssn")
@Controller
public class WechatAssociationController {
	
    private Logger logger = Logger.getLogger(WechatAssociationController.class);
    @Autowired
    private CacheService cacheService;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CollectAppService collectAppService;
    @Autowired
    private CcpAssociationService ccpAssociationService;

    /**社团列表页
     * @return
     */
    @RequestMapping("/toAssnList")
    @SysBusinessLog(remark = "跳转到社团列表页",operation = OperatFunction.WHST)
    public String assnList(HttpServletRequest request){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        return "wechat/association/assnList";
    }
    
    /**社团详情页
     * @return
     */
    @RequestMapping("/toAssnDetail")
    public String toAssnDetail(HttpServletRequest request, String assnId){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("assnId", assnId);
        return "wechat/association/assnDetail";
    }
    
    /**社团图片列表页
     * @return
     */
    @RequestMapping("/toAssnImg")
    public String toAssnImg(HttpServletRequest request, String assnId){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("assnId", assnId);
        return "wechat/association/assnImg";
    }
    
    /**社团视频列表页
     * @return
     */
    @RequestMapping("/toAssnVideo")
    public String toAssnVideo(HttpServletRequest request, String assnId){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("assnId", assnId);
        return "wechat/association/assnVideo";
    }
    
    /**社团活动列表页
     * @return
     */
    @RequestMapping("/toAssnActivity")
    public String toAssnActivity(HttpServletRequest request, String assnId){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        request.setAttribute("assnId", assnId);
        return "wechat/association/assnActivity";
    }

    /**获取社团列表
     * @return
     */
    @RequestMapping("/getAssnList")
    public String getAssnList(HttpServletResponse response) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"association/getAssociationList",null);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**获取社团详情
     * @return
     */
    @RequestMapping("/getAssnDetail")
    public String getAssnDetail(HttpServletResponse response,GetAssociationDetailVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"association/getAssociationDetail",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**获取社团资源
     * @return
     */
    @RequestMapping("/getAssnRes")
    public String getAssnRes(HttpServletResponse response,AssociationResourceListVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"associationRes/associationResourceList",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**获取社团在线活动
     * @return
     */
    @RequestMapping("/getAssnActivity")
    public String getAssnActivity(HttpServletResponse response,AssociationActivityVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"association/associationActivity",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**获取社团历史活动
     * @return
     */
    @RequestMapping("/getAssnHistoryActivity")
    public String getAssnHistoryActivity(HttpServletResponse response,AssociationActivityVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"association/associationHistoryActivity",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**社团浇花
     * @return
     */
    @RequestMapping("/saveAssnFlower")
    public String saveAssnFlower(HttpServletResponse response,SaveCcpAssociationFlowerVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"associationFlower/saveCcpAssociationFlower",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 用户关注社团
     * @param userId     用户id
     * @param assnId 社团id
     * @throws Exception
     */
    @RequestMapping(value = "/wcCollectAssn")
    public String wcCollectAssn(HttpServletRequest request, HttpServletResponse response, String userId, String assnId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(assnId)) {
                json = collectAppService.addCollectAssociation(userId, assnId);
            } else {
                json = JSONResponse.commonResultFormat(10121, "用户或社团id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }

    /**
     * 取消社团关注
     * @param userId     用户id
     * @param assnId 社团id
     * @throws Exception
     */
    @RequestMapping(value = "/wcDelCollectAssn")
    public String wcDelCollectAssn(HttpServletRequest request, HttpServletResponse response, String userId, String assnId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(assnId)) {
                json = collectAppService.delCollectAssociation(userId, assnId);
            } else {
                json = JSONResponse.commonResultFormat(10121, "用户或社团id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }
    
    /**社团申请页
     * @return
     */
    @RequestMapping("/toAssnApply")
    public String toAssnApply(HttpServletRequest request){
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        return "wechat/association/assnApply";
    }
    
    /**
     * 申请社团
     * @param ccpAssociationApply
     * @return
     */
    @RequestMapping("/applyAssociation")
    @SysBusinessLog(remark = "申请社团")
    @ResponseBody
    public String applyAssociation(CcpAssociationApply ccpAssociationApply) {
        try {
        	ccpAssociationApply.setAssnId(UUIDUtils.createUUId());
        	ccpAssociationApply.setAssnState(0);
        	ccpAssociationApply.setCreateTime(new Date());
        	ccpAssociationApply.setUpdateTime(new Date());
        	boolean rsBoolean = ccpAssociationService.saveAssnApply(ccpAssociationApply);
        	if(rsBoolean){
        		return Constant.RESULT_STR_SUCCESS;
        	}else{
        		return Constant.RESULT_STR_FAILURE;
        	}
        } catch (Exception e) {
            logger.info("applyAssociation error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
    }
}
