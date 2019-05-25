package com.sun3d.why.controller.ticket;

import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.service.CmsAntiqueService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

/**
 * <p>
 * 藏品模块前台请求处理控制层
 * 负责跟页面数据的交互以及对下层的数据方法的调用
 * </p>
 * Created by cj on 2015/4/21.
 */
@Controller
@RequestMapping(value = "/ticketAntique")
public class TicketAntiqueController {

    /**
     * 自动注入藏品业务操作层service实例
     */
    @Autowired
    private CmsAntiqueService cmsAntiqueService;
    /**
     * 自动注入数据字典业务操作层service实例
     */
    @Autowired
    private SysDictService sysDictService;
    /**
     * 自动注入馆藏业务操作层service实例
     */
    @Autowired
    private CmsVenueService cmsVenueService;
    /**
     *  数据统计逻辑控制层
     */
    @Autowired
    private StatisticService statisticService;
    /**
     * log4j日志
     */
    private Logger logger = Logger.getLogger(TicketAntiqueController.class);

    /**
     * 加载前台馆藏列表
     *
     * @author cj
     * @date 2015-06-17
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/antiqueList")
    public ModelAndView antiqueList(String typeId,String dynasty,String key,String venueId){
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        List<SysDict> sysDictList = new ArrayList<SysDict>();
        CmsVenue cmsVenue = null;
        try {
            SysDict dict = new SysDict();
            dict.setDictState(Constant.NORMAL);
            dict.setDictCode("DYNASTY");
            List<SysDict> dictLists = sysDictService.querySysDictByByCondition(dict);

            if(CollectionUtils.isNotEmpty(dictLists)){
                SysDict sysDict = dictLists.get(0);
                dict.setDictCode(null);
                dict.setDictParentId(sysDict.getDictId());
                sysDictList = sysDictService.querySysDictByByCondition(dict);
            }
            if(StringUtils.isNotBlank(venueId)){
                cmsVenue = cmsVenueService.queryVenueById(venueId);
                model.addObject("cmsVenue",cmsVenue);
            }
            if(StringUtils.isNotBlank(dynasty)){
                model.addObject("dynasty",dynasty);
            }
            model.addObject("key",key);
        } catch (Exception e) {
            logger.error("加载馆藏列表时出错!", e);
        }
        model.setViewName("ticket/antique/ticketAntiqueList");
        model.addObject("dictList",sysDictList);
        return model;
    }

    /**
     * 加载前台馆藏列表
     *
     * @author cj
     * @date 2015-06-17
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/antiqueListLoad")
    public ModelAndView antiqueListLoad(String antiqueName,String venueId,String antiqueYears,Pagination page,String antiqueVenueId){
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        List<CmsAntique> antiqueList = null;
        try {
            if(StringUtils.isNotBlank(venueId)){
                page.setRows(30);
                CmsAntique cmsAntique = new CmsAntique();
                cmsAntique.setAntiqueState(Constant.PUBLISH);
                cmsAntique.setAntiqueIsDel(Constant.NORMAL);
                if(StringUtils.isNotBlank(antiqueName)){
                    cmsAntique.setAntiqueName(antiqueName);
                }
                if(StringUtils.isNotBlank(venueId)){
                    cmsAntique.setVenueId(venueId);
                }
                if(StringUtils.isNotBlank(antiqueYears)){
                    cmsAntique.setAntiqueYears(antiqueYears);
                }
                if(StringUtils.isNotBlank(antiqueVenueId)){
                    cmsAntique.setAntiqueVenueId(antiqueVenueId);
                }
                antiqueList = cmsAntiqueService.queryAntiqueListForIndex(page,cmsAntique,null);
            }
        } catch (Exception e) {
            logger.error("加载场馆前台首页数据时出错!",e);
        }
        model.addObject("antiqueList",antiqueList);
        model.addObject("page",page);
        model.setViewName("ticket/antique/ticketAntiqueListLoad");
        return model;
    }


    /**
     * 根绝前台传过来的藏品ID进行单条查询
     * 返回藏品信息数据至前台藏品详情页
     *
     * @param antiqueId String 藏品信息ID
     * @author cj
     * @date 2015-04-29
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/antiqueDetail")
    public ModelAndView antiqueDetail(String antiqueId){
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        CmsAntique cmsAntique = null;
        CmsVenue cmsVenue = null;
        CmsStatistics statistics = null;
        //查询数据字典中馆藏信息相关的数据
        List<SysDict> sysDictList = new ArrayList<SysDict>();
        try {

            SysDict dict = new SysDict();
            dict.setDictState(Constant.NORMAL);
            dict.setDictCode("DYNASTY");
            List<SysDict> dictLists = sysDictService.querySysDictByByCondition(dict);

            if(CollectionUtils.isNotEmpty(dictLists)){
                SysDict sysDict = dictLists.get(0);
                dict.setDictCode(null);
                dict.setDictParentId(sysDict.getDictId());
                sysDictList = sysDictService.querySysDictByByCondition(dict);
            }

            //馆藏ID不为空时进行相关信息查询
            if(StringUtils.isNotBlank(antiqueId)){
                cmsAntique = cmsAntiqueService.queryCmsAntiqueById(antiqueId);
                //如果馆藏信息不为空且场馆ID不为空，则请求场馆信息
                if(cmsAntique != null && StringUtils.isNotBlank(cmsAntique.getVenueId())) {
                    cmsVenue = cmsVenueService.queryVenueById(cmsAntique.getVenueId());
                }

                //统计数据(喜欢、浏览)
                statistics = statisticService.queryStatistics(antiqueId, Constant.COLLECT_ANTIQUE);
            }else{
                logger.error("馆藏ID为空，馆藏详情处理终止!");
            }
        } catch (Exception e) {
            logger.error("根据馆藏ID加载馆藏详情页时出错!", e);
        }
        model.setViewName("ticket/antique/ticketAntiqueDetail");
        model.addObject("cmsAntique",cmsAntique);
        model.addObject("cmsVenue",cmsVenue);
        model.addObject("dictList",sysDictList);
        model.addObject("statistics",statistics);
        return model;
    }


    /**
     * 前台馆藏详情页推荐馆藏
     * @param antiqueId
     * @return
     */
    @RequestMapping(value = "/relatedAntiqueList")
    @ResponseBody
    public List<CmsAntique> relatedAntiqueList(String antiqueId) {
        List<CmsAntique> antiqueList = null;
        if(StringUtils.isNotBlank(antiqueId)) {
            //馆藏详情
            CmsAntique cmsAntique = cmsAntiqueService.queryCmsAntiqueById(antiqueId);
            CmsAntique antiqueCondition = new CmsAntique();
            antiqueCondition.setAntiqueState(Constant.PUBLISH);
            antiqueCondition.setAntiqueIsDel(Constant.NORMAL);
            antiqueCondition.setVenueId(cmsAntique.getVenueId());
            antiqueCondition.setAntiqueId(antiqueId+"exclude");

            Pagination page = new Pagination();
            //前端显示六条
            page.setRows(6);
            antiqueList = cmsAntiqueService.queryRelatedAntique(antiqueCondition,page);
        }
        return antiqueList;
    }
}
