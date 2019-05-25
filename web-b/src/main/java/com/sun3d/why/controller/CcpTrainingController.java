package com.sun3d.why.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.model.bean.training.CcpTraining;
import com.culturecloud.model.request.training.CcpTrainingVO;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.CallUtils;
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
import java.util.List;

@RequestMapping("/training")
@Controller
public class CcpTrainingController {
    private Logger logger = LoggerFactory.getLogger(CcpTrainingController.class);

    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;

    /**
     * 培训表页
     *
     * @return
     */
    @RequestMapping("/trainingIndex")
    public ModelAndView heritageIndex(CcpTrainingVO vo) {
        ModelAndView model = new ModelAndView();
        try {
            HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "training/list", vo);
            JSONObject jsonObject = JSON.parseObject(res.getData());
            List<CcpTraining> trainingList = JSON.parseArray(jsonObject.get("data").toString(), CcpTraining.class);
            model.addObject("trainingList", trainingList);
            model.addObject("CcpTrainingVO", vo);
            model.setViewName("admin/training/trainingIndex");
        } catch (Exception e) {
            logger.error("heritageIndex error {}", e);
        }
        return model;
    }

    /**
     * 跳转至视频编辑页面
     *
     * @return
     */
    @RequestMapping(value = "/preTraining")
    public String preTraining(HttpServletRequest request, CcpTrainingVO vo) {
        if (StringUtils.isNotBlank(vo.getTrainingId())) {
            HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "training/list", vo);
            JSONObject jsonObject = JSON.parseObject(res.getData());
            List<CcpTraining> trainingList = JSON.parseArray(jsonObject.get("data").toString(), CcpTraining.class);
            request.setAttribute("training", trainingList.get(0));
        }
        return "admin/training/preTraining";
    }

    /**
     * 增改培训视频
     *
     * @return
     */
    @RequestMapping(value = "/changeTraining")
    public String changeTraining(HttpServletResponse response, HttpServletRequest request, CcpTrainingVO vo) throws Exception {
        SysUser sysUser = (SysUser) session.getAttribute("user");
        vo.setCreateUser(sysUser.getUserId());
        HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "training/change", vo);
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return "success";
    }
}
