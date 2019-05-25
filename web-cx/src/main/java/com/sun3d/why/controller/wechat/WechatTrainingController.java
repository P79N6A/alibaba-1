package com.sun3d.why.controller.wechat;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.model.bean.training.CcpTraining;
import com.culturecloud.model.request.training.CcpTrainingVO;
import com.sun3d.why.dao.CmsUserWantgoMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsUserWantgo;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@RequestMapping("/wechatTraining")
@Controller
public class WechatTrainingController {

    private Logger logger = Logger.getLogger(WechatTrainingController.class);

    @Autowired
    private CacheService cacheService;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsActivityService activityService;
    @Autowired
    private CmsUserWantgoMapper cmsUserWantgoMapper;

    /**
     * 跳转艺术培训页面
     *
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        CmsActivity act = new CmsActivity();
        act.setActivityType("e4c2cef5b0d24b2793ac00fd1098e4e7");
        Pagination page = new Pagination();
        page.setFirstResult(0);
        page.setRows(10);
        List<CmsActivity> actList = activityService.queryCmsActivityByCondition(act, page, null);
        CcpTrainingVO vo = new CcpTrainingVO();
        HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "training/list", vo);
        JSONObject jsonObject = JSON.parseObject(res.getData());
        List<CcpTraining> trainingList = JSON.parseArray(jsonObject.get("data").toString(), CcpTraining.class);
        request.setAttribute("trainingList", trainingList);
        request.setAttribute("actList", actList);
        request.setAttribute("sign", sign);
        return "wechat/training/trainingIndex";
    }


    /**
     * 跳转艺术培训页面
     *
     * @return
     */
    @RequestMapping(value = "/trainingDetail")
    public String trainingDetail(HttpServletRequest request, String trainingId, String userId) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        CcpTrainingVO vo = new CcpTrainingVO();
        vo.setTrainingId(trainingId);
        HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "training/list", vo);
        JSONObject jsonObject = JSON.parseObject(res.getData());
        List<CcpTraining> trainingList = JSON.parseArray(jsonObject.get("data").toString(), CcpTraining.class);
        CmsUserWantgo userWantgo = new CmsUserWantgo();
        userWantgo.setRelateId(trainingId);
        int a = cmsUserWantgoMapper.queryAppUserWantCountById(userWantgo);

        if (StringUtils.isBlank(userId)) {
            request.setAttribute("userWantgo", 0);
        } else {
            userWantgo.setUserId(userId);
            int status = cmsUserWantgoMapper.queryAppUserWantCountById(userWantgo);
            request.setAttribute("userWantgo", status);
        }
        request.setAttribute("want", a);
        request.setAttribute("training", trainingList.get(0));
        request.setAttribute("sign", sign);
        return "wechat/training/trainingDetail";
    }


    /**
     * 跳转艺术培训视频列表页
     *
     * @return
     */
    @RequestMapping(value = "/trainingVideoList")
    public String trainingVideoList(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        CcpTrainingVO vo = new CcpTrainingVO();
        HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "training/list", vo);
        JSONObject jsonObject = JSON.parseObject(res.getData());
        List<CcpTraining> trainingList = JSON.parseArray(jsonObject.get("data").toString(), CcpTraining.class);
        request.setAttribute("trainingList", trainingList);
        request.setAttribute("sign", sign);
        return "wechat/training/trainingVideoList";
    }


    /**
     * 跳转艺术培训视频列表页
     *
     * @return
     */
    @RequestMapping(value = "/trainingList")
    public String trainingList(HttpServletRequest request) {
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        return "wechat/training/trainingList";
    }
}
