package com.sun3d.why.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.model.bean.heritage.CcpHeritageImg;
import com.culturecloud.model.request.heritage.CcpHeritageReqVO;
import com.culturecloud.model.response.heritage.CcpHeritageResVO;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RequestMapping("/heritage")
@Controller
public class CcpHeritageController {
	private Logger logger = LoggerFactory.getLogger(CcpHeritageController.class);

    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;

    /**
     * 非遗列表页
     * @return
     */
    @RequestMapping("/heritageIndex")
    public ModelAndView heritageIndex(CcpHeritageReqVO vo) {
        ModelAndView model = new ModelAndView();
        try {
        	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"heritage/getCcpHeritageList",vo);
    		JSONObject jsonObject = JSON.parseObject(res.getData());
    		List<CcpHeritageResVO> heritageList = JSON.parseArray(jsonObject.get("data").toString(), CcpHeritageResVO.class);
            model.addObject("heritageList", heritageList);
            model.addObject("ccpHeritage", vo);
            model.setViewName("admin/heritage/heritageIndex");
        } catch (Exception e) {
            logger.error("heritageIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 跳转至非遗添加页面
     * @return
     */
    @RequestMapping(value = "/preAddHeritage")
    public String preAddHeritage(HttpServletRequest request) {
        return "admin/heritage/addHeritage";
    }
    
    /**
     * 跳转至非遗编辑页面
     * @return
     */
    @RequestMapping(value = "/preEditHeritage")
    public String preEditHeritage(HttpServletRequest request, CcpHeritageReqVO vo) {
    	CcpHeritageResVO ccpHeritageResVO = null;
        if (StringUtils.isNotBlank(vo.getHeritageId())) {
        	HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"heritage/getHeritageById",vo);
    		JSONObject jsonObject = JSON.parseObject(res.getData());
    		ccpHeritageResVO = JSON.parseObject(jsonObject.get("data").toString(), CcpHeritageResVO.class);
            request.setAttribute("heritage", ccpHeritageResVO);
        }
        return "admin/heritage/editHeritage";
    }
    
    /**
     * 添加非遗
     * @return
     */
    @RequestMapping(value = "/addHeritage")
    public String addHeritage(HttpServletResponse response,CcpHeritageReqVO vo,String [] heritageImgUrl) throws Exception{
    	vo.setHeritageId(UUIDUtils.createUUId());
    	vo.setCreateTime(new Date());
    	vo.setUpdateTime(new Date());
    	List <CcpHeritageImg> imglist = new ArrayList<CcpHeritageImg>();
    	for(String url:heritageImgUrl){
    		CcpHeritageImg ccpHeritageImg = new CcpHeritageImg();
    		ccpHeritageImg.setHeritageImgId(UUIDUtils.createUUId());
    		ccpHeritageImg.setHeritageId(vo.getHeritageId());
    		ccpHeritageImg.setHeritageImgUrl(url);
    		ccpHeritageImg.setCreateTime(new Date());
    		imglist.add(ccpHeritageImg);
    	}
    	vo.setCcpHeritageImgList(imglist);
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"heritage/saveCcpHeritage",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 编辑非遗
     * @return
     */
    @RequestMapping(value = "/editHeritage")
    public String editHeritage(HttpServletResponse response,CcpHeritageReqVO vo,String [] heritageImgUrl) throws Exception{
    	vo.setUpdateTime(new Date());
		List <CcpHeritageImg> imglist = new ArrayList<CcpHeritageImg>();
    	for(String url:heritageImgUrl){
    		CcpHeritageImg ccpHeritageImg = new CcpHeritageImg();
    		ccpHeritageImg.setHeritageImgId(UUIDUtils.createUUId());
    		ccpHeritageImg.setHeritageId(vo.getHeritageId());
    		ccpHeritageImg.setHeritageImgUrl(url);
    		ccpHeritageImg.setCreateTime(new Date());
    		imglist.add(ccpHeritageImg);
    	}
    	vo.setCcpHeritageImgList(imglist);
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"heritage/updateCcpHeritage",vo);
		response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}
