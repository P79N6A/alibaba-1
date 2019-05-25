package com.sun3d.why.controller.front;

import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.service.*;
import com.sun3d.why.statistics.service.StatisticCultureUserService;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.*;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Administrator on 2015/8/19. 非遗前台
 */
@RequestMapping("/frontCulture")
@Controller
public class FrontCultureController {


    private Logger logger = LoggerFactory.getLogger(FrontCultureController.class);

    @Autowired
    private CmsCultureService cmsCultureService;

    @Autowired
    private StatisticService statisticService;

    @Autowired
    private SysDictService dictService;
    @Autowired
    private StatisticCultureUserService statisticCultureUserService;



    @Autowired
    private CmsCommentService commentService;

    @Autowired
    private CmsCultureInheritorService cultureInheritorService;

    @Autowired
    private HttpSession session;
    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;
    @RequestMapping("/cultureIndex")
    public ModelAndView index(HttpServletRequest request){
        try{
            List<SysDict>  typeList =  dictService.querySysDictByParentCode("CULTURETYPE");
            List<SysDict>  systemList  = dictService.querySysDictByParentCode("CULTURESYSTEM");
            List<SysDict>  yearList  = dictService.querySysDictByParentCode("CULTUREYEAR");

            request.setAttribute("typeList",typeList);
            request.setAttribute("systemList",systemList);
            request.setAttribute("yearList",yearList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return  new ModelAndView("index/culture/index");
    }

    @RequestMapping(value = "/indexLoad")
    public ModelAndView indexLoad(CmsCulture culture, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            page.setRows(20);
            List<CmsCulture> dataList = cmsCultureService.queryForFront(culture,page);
            model.setViewName("index/culture/indexLoad");
            model.addObject("dataList", dataList);
            model.addObject("page", page);
            model.addObject("c", culture);
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("cultureLoad error...." + e);
        }
        return model;
    }

    @RequestMapping(value = "/cultureDetail")
    public ModelAndView cultureDetail(String cultureId) {
        ModelAndView model = new ModelAndView();
        try {
            // 详情
            CmsCulture culture = cmsCultureService.queryById(cultureId);
            // 浏览量
            CmsStatistics statistics = statisticService.queryStatistics(cultureId, Constant.COLLECT_CULTURE);
            // 标签
            // 得到标签
            List<String> dictNameList = new ArrayList<String>();
            if(StringUtils.isNotBlank(culture.getCultureSystem())){
                SysDict dict = dictService.querySysDictByDictId(culture.getCultureSystem());
                dictNameList.add(dict.getDictName());
            }
            if(StringUtils.isNotBlank(culture.getCultureYears())){
                SysDict dict = dictService.querySysDictByDictId(culture.getCultureYears());
                dictNameList.add(dict.getDictName());
            }
            if(StringUtils.isNotBlank(culture.getCultureType())){
                SysDict dict = dictService.querySysDictByDictId(culture.getCultureType());
                dictNameList.add(dict.getDictName());
            }

            // 前端2.0已审核评论数
            CmsComment comment = new CmsComment();
            comment.setCommentRkId(culture.getCultureId());
            comment.setCommentType(Constant.TYPE_CULTURE);
            int commentCount = commentService.queryCommentCountByCondition(comment);

            // 推荐非遗
            Pagination page = new Pagination();
            page.setRows(3);
            List<CmsCulture> recommendCultureList = cmsCultureService.queryRecommendCulture(culture, page);

            // 传承人
            CmsCultureInheritor cultureInheritor = new CmsCultureInheritor();
            cultureInheritor.setCultureId(cultureId);
            List<CmsCultureInheritor> cultureInheritorList = cultureInheritorService.queryCultureInheritorByCondition(cultureInheritor, null);

            model.addObject("cultureInheritorList", cultureInheritorList);
            model.addObject("recommendCultureList", recommendCultureList);
            model.addObject("commentCount", commentCount);
            model.addObject("dictNameList", dictNameList);
            model.addObject("culture", culture);
            model.addObject("statistics", statistics);
        } catch (Exception e) {
            logger.info("cultureDetail error...." + e);
        }
        model.setViewName("index/culture/cultureDetail");
        return model;
    }

    /**
     * 前端2.0 添加评论
     * @param comment
     * @param cultureId
     * @return
     */
    @RequestMapping(value = "/addComment")
    @ResponseBody
    public String addComment(CmsComment comment,String cultureId) {
        try{
            if(session.getAttribute("terminalUser") != null){
                String sensitiveWords= CmsSensitive.sensitiveWords(comment, cmsSensitiveWordsMapper);
                if(StringUtils.isNotBlank(sensitiveWords) && sensitiveWords.equals("sensitiveWords")){
                    return  Constant.SensitiveWords_EXIST;
                }

                CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
                comment.setCommentUserId(user.getUserId());
                comment.setCommentType(Constant.TYPE_CULTURE);
                comment.setCommentRkId(cultureId);
                return commentService.addComment(comment);
            }
        }catch (Exception e){
            logger.info("addComment error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    //前端2.0 评论列表
    @RequestMapping(value = "/commentList")
    @ResponseBody
    public List<CmsComment> commentList(String cultureId,Integer pageNum) {
        //评论列表
        CmsComment cmsComment = new CmsComment();
        cmsComment.setCommentRkId(cultureId);
        cmsComment.setCommentType(Constant.TYPE_CULTURE);
        Pagination page = new Pagination();
        page.setRows(10);
        page.setPage(pageNum);
        cmsComment.setCommentState(1);
        List<CmsComment> commentList = commentService.queryCommentByCondition(cmsComment, page,null);
        return commentList;
    }

    @RequestMapping("/addScan")
    @ResponseBody
    public String addScan(final  String id,final HttpServletRequest request){
        if(StringUtils.isBlank(id)){
            return Constant.RESULT_STR_FAILURE;
        }
        Runnable runner = new Runnable() {
            @Override
            public void run() {
                CmsCultureUserStatistcs  c = new CmsCultureUserStatistcs();
                c.setId(UUIDUtils.createUUId());
                //type 1 浏览
                c.setOperateType(1);
                c.setIp(IpUtil.getIpAddress(request));
                c.setCultureId(id);
                c.setCreateTime(new Date());
                c.setUpdateTime(new Date());
                CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
                if(user!=null){
                    c.setUserId(user.getUserId());
                    c.setCreateUser(user.getUserName());
                    c.setStatus(2);
                }else{
                    c.setStatus(1);
                }
                statisticCultureUserService.addCultureUserStatistics(c);
            }
        };
        Thread t = new Thread();
        t.start();
        return Constant.RESULT_STR_SUCCESS;
    }
}
