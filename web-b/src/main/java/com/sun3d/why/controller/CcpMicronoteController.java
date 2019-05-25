package com.sun3d.why.controller;

import java.util.List;

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
import com.culturecloud.model.request.micronote.CcpMicronoteReqVO;
import com.culturecloud.model.response.micronote.CcpMicronoteResVO;
import com.google.gson.Gson;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@RequestMapping("/micronote")
@Controller
public class CcpMicronoteController {
	private Logger logger = LoggerFactory.getLogger(CcpMicronoteController.class);

    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;

    /**
     * 微笔记大赛列表页
     * @return
     */
    @RequestMapping("/micronoteIndex")
    public ModelAndView micronoteIndex(CcpMicronoteReqVO vo) {
        ModelAndView model = new ModelAndView();
        try {
        	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"micronote/getMicronoteList",vo);
    		JSONObject jsonObject = JSON.parseObject(res.getData());
    		BasePageResultListVO<CcpMicronoteResVO> micronoteRes = JSON.parseObject(jsonObject.get("data").toString(), BasePageResultListVO.class);
    		model.addObject("micronoteRes", micronoteRes);
            model.addObject("ccpMicronote", vo);
            model.setViewName("admin/micronote/micronoteIndex");
        } catch (Exception e) {
            logger.error("micronoteIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 删除微笔记
     * @return
     */
    @RequestMapping(value = "/deleteMicronote")
    public String deleteMicronote(HttpServletResponse response,CcpMicronoteReqVO vo) throws Exception{
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"micronote/deleteMicronote",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}
