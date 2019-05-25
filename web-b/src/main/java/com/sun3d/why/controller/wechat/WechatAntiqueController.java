package com.sun3d.why.controller.wechat;

import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.AntiqueAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Map;

@RequestMapping("/wechatAntique")
@Controller
public class WechatAntiqueController {
    private Logger logger = Logger.getLogger(WechatAntiqueController.class);
    @Autowired
    private AntiqueAppService antiqueAppService;
    @Autowired
    private CacheService cacheService;
    /**
     * wechat获取藏品列表
     *
     * @param venueId   展馆id
     * @param pageIndex 首页下表
     * @param pageNum   显示条数
     * @return json 10108:展馆id缺失
     */
    @RequestMapping(value = "/antiqueAppIndex")
    public String antiqueAppIndex(HttpServletResponse response, String venueId, String pageIndex, String pageNum, PaginationApp pageApp) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (venueId != null && StringUtils.isNotBlank(venueId)) {
                json = antiqueAppService.queryAppAntiqueListById(venueId, pageApp);
            } else {
                json = JSONResponse.commonResultFormat(10108, "展馆id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query antiqueIndex error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 根据藏品名称筛选藏品
     *
     * @param antiqueTypeName 藏品类别名称
     * @param venueId         展馆id
     * @param pageIndex       首页下标
     * @param pageNum         显示条数
     * @return json  10109: 藏品类别参数缺失
     * @throws Exception
     */
    @RequestMapping(value = "/screenAppAntiqueTypeName")
    public String screenAppAntiqueTypeName(PaginationApp pageApp, HttpServletResponse response, String antiqueTypeName, String pageIndex, String pageNum, String venueId) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json = antiqueAppService.queryAppAntiqueListByTypeName(antiqueTypeName, pageApp, venueId);
        } catch (Exception e) {
            logger.info("出错了!");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 根据藏品年代筛选藏品
     *
     * @param antiqueDynasty 藏品年代
     * @param pageIndex      首页下标
     * @param pageNum        显示条数
     * @param venueId        展馆id
     * @return json  10110: 藏品年代参数缺失
     * @throws Exception
     */
    @RequestMapping(value = "/screenAppAntiqueDynasty")
    public String screenAppAntiqueDynasty(PaginationApp pageApp, HttpServletResponse response, String antiqueDynasty, String pageIndex, String pageNum, String venueId) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json = antiqueAppService.queryAppAntiqueListByDynasty(antiqueDynasty, pageApp, venueId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * wechat获取藏品详情
     *
     * @param antiqueId 藏品id
     * @return json 10110:藏品id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/antiqueAppDetail")
    public String antiqueAppDetail(HttpServletResponse response, String antiqueId) throws Exception {
        String json = "";
        if (StringUtils.isNotBlank(antiqueId) && antiqueId != null) {
            json = antiqueAppService.queryAppAntiqueById(antiqueId);
        } else {
            json = JSONResponse.commonResultFormat(10110, "藏品id缺失", null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 藏品列表页页
     * @param venueId
     * @return
     */
    @RequestMapping("/preAntiqueList")
    public String preVenueList(HttpServletRequest request, String venueId){
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("venueId", venueId);
        return "wechat/venue/antiqueList";
    }
    /**
     * 藏品列表页页
     * @param antiqueId
     * @return
     */
    @RequestMapping("/preAntiqueDetail")
    public String preAntiqueDetail(HttpServletRequest request, String antiqueId){
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("antiqueId", antiqueId);
        return "wechat/venue/antique_detail";
    }
}



