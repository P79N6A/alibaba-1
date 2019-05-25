package com.sun3d.why.webservice.controller;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.AntiqueAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;
/**
 * 手机app接口 藏品列表
 * Created by Administrator on 2015/7/4
 */
@RequestMapping("/appAntique")
@Controller
public class AntiqueAppController {
    private Logger logger = Logger.getLogger(AntiqueAppController.class);
    @Autowired
    private AntiqueAppService antiqueAppService;
    /**
     * app获取藏品列表
     * @param venueId 展馆id
     * @param pageIndex 首页下表
     * @param pageNum 显示条数
     * @return json 10108:展馆id缺失
     */
    @RequestMapping(value = "/antiqueAppIndex")
    public String antiqueAppIndex(HttpServletResponse response,String venueId,String pageIndex,String pageNum, PaginationApp pageApp) throws Exception {
        String json="";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if(venueId!=null && StringUtils.isNotBlank(venueId)){
                json=antiqueAppService.queryAppAntiqueListById(venueId,pageApp);
            }
            else {
                json=JSONResponse.commonResultFormat(10108,"展馆id缺失",null);
            }
        }catch (Exception e){
                e.printStackTrace();
                logger.info("query antiqueIndex error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 根据藏品名称筛选藏品
     * @param antiqueTypeName 藏品类别名称
     * @param venueId 展馆id
     * @param pageIndex 首页下标
     * @param pageNum 显示条数
     * @return json  10109: 藏品类别参数缺失
     * @throws Exception
     */
    @RequestMapping(value = "/screenAppAntiqueTypeName")
    public String screenAppAntiqueTypeName(PaginationApp pageApp, HttpServletResponse response,String antiqueTypeName,String pageIndex,String pageNum,String venueId) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json=antiqueAppService.queryAppAntiqueListByTypeName(antiqueTypeName,pageApp,venueId);
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
     * @param antiqueDynasty 藏品年代
     * @param pageIndex 首页下标
     * @param pageNum 显示条数
     * @param venueId 展馆id
     * @return json  10110: 藏品年代参数缺失
     * @throws Exception
     */
    @RequestMapping(value = "/screenAppAntiqueDynasty")
    public String screenAppAntiqueDynasty(PaginationApp pageApp, HttpServletResponse response,String antiqueDynasty,String pageIndex,String pageNum,String venueId) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            json=antiqueAppService.queryAppAntiqueListByDynasty(antiqueDynasty,pageApp,venueId);
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
     * app获取藏品详情
     * @param antiqueId 藏品id
     * @return json 10110:藏品id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/antiqueAppDetail")
    public String antiqueAppDetail( HttpServletResponse response,String antiqueId,String userId) throws Exception {
        String json="";
        if(StringUtils.isNotBlank(antiqueId) && antiqueId!=null){
            json=antiqueAppService.queryAppAntiqueById(antiqueId,userId);
        }else{
            json=JSONResponse.commonResultFormat(10110,"藏品id缺失",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}



