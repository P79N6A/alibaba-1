package com.sun3d.why.controller;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityImgReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityReqVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityImgResVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityResVO;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@RequestMapping("/beautycity")
@Controller
public class CcpBeautycityController {
	private Logger logger = LoggerFactory.getLogger(CcpBeautycityController.class);

    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;

    /**
     * 最美城市用户信息列表
     * @return
     */
    @RequestMapping("/beautycityIndex")
    public ModelAndView beautycityIndex(CcpBeautycityReqVO vo) {
        ModelAndView model = new ModelAndView();
        try {
        	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"beautycity/getBeautycityList",vo);
    		JSONObject jsonObject = JSON.parseObject(res.getData());
    		BasePageResultListVO<CcpBeautycityResVO> beautycityRes = JSON.parseObject(jsonObject.get("data").toString(), BasePageResultListVO.class);
    		model.addObject("beautycityRes", beautycityRes);
            model.addObject("ccpBeautycity", vo);
            model.setViewName("admin/beautycity/beautycityIndex");
        } catch (Exception e) {
            logger.error("beautycityIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 最美城市照片列表
     * @return
     */
    @RequestMapping("/beautycityImgIndex")
    public ModelAndView beautycityImgIndex(CcpBeautycityImgReqVO vo) {
        ModelAndView model = new ModelAndView();
        try {
        	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"beautycity/getBeautycityImgList",vo);
    		JSONObject jsonObject = JSON.parseObject(res.getData());
    		BasePageResultListVO<CcpBeautycityImgResVO> beautycityImgRes = JSON.parseObject(jsonObject.get("data").toString(), BasePageResultListVO.class);
    		model.addObject("beautycityImgRes", beautycityImgRes);
            model.addObject("ccpBeautycityImg", vo);
            model.setViewName("admin/beautycity/beautycityImgIndex");
        } catch (Exception e) {
            logger.error("beautycityImgIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 删除微笔记
     * @return
     */
    @RequestMapping(value = "/deleteBeautycityImg")
    public String deleteBeautycityImg(HttpServletResponse response,CcpBeautycityImgReqVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"beautycity/deleteBeautycityImg",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}
