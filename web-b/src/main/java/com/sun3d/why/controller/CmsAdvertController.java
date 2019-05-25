package com.sun3d.why.controller;

import com.sun3d.why.model.CmsAdvert;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsAdvertService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.service.impl.CmsAdvertServiceImpl;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <p>
 * 广告控制层，负责跟页面数据的交互以及对下层的数据方法的调用
 * <p/>
 * Created by cj on 2015/4/24.
 */
@Controller
@RequestMapping(value = "/advert")
public class CmsAdvertController {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(CmsAdvertController.class.getName());
    /**
     * 自动注入广告业务操作层service实例
     */
    @Autowired
    private CmsAdvertService cmsAdvertService;
    /**
     * 自动注入数据字典业务操作层service实例
     */
    @Autowired
    private SysDictService sysDictService;
    /**
     * 自动注入请求对应的session实例
     */
    @Autowired
    private HttpSession session;

    @Autowired
    private CacheService cacheService;
    /**
     * 跳转到广告管理的首页面，获取数据查询条件，分页信息，返回分页数据和分页信息
     *
     * @param record CmsAdvert 广告对象，用于获取前台传递的查询参数
     * @param page   Pagination 分页功能对象
     * @return ModelAndView 页面跳转及数据传递
     */
    @RequestMapping(value = "/advertIndex")
    public ModelAndView advertIndex(CmsAdvert record, Pagination page) {
        //创建一个ModelAndView对象，代表了MVC Web程序中Model与View的对象
        //view代表跳转的页面，model代表传到前台的数据
        ModelAndView model = new ModelAndView();
        List<CmsAdvert> list = null;
        List<CmsAdvert> pageList = new ArrayList<CmsAdvert>();
        try {
            SysUser user = (SysUser) session.getAttribute("user");
            if(user==null){
                return null;
            }
            if(StringUtils.isNotBlank(user.getUserCounty())){
                String key = user.getUserCounty().split(",")[0];
                if(!"45".equals(key))
                record.setAdvertSite(key);
            }

            list = cmsAdvertService.queryCmsAdvertByCondition(record,page);

            for(CmsAdvert cmsAdvert:list){
                CmsAdvert cmsAdverts = cmsAdvert;
                String url = cmsAdvert.getAdvertPicUrl();
                if(StringUtils.isNotBlank(url)){
                    String[] picUrl = url.split("\\.");
                    String picUrls = picUrl[0]+"_300_300."+picUrl[1];
                    cmsAdverts.setAdvertPicUrl(picUrls);
                }
                pageList.add(cmsAdverts);
            }

        } catch (Exception e) {
            logger.error("加载广告列表页面时出错!",e);
        }
        model.setViewName("admin/advert/advertIndex");
        model.addObject("list", pageList);
        model.addObject("page", page);
        model.addObject("record",record);
        return model;
    }


    /**
     * 跳转到添加广告的页面
     *
     * @author cj
     * @date 2015-04-29
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/preAddAdvert")
    public ModelAndView preAddCmsAdvert() {
        //创建一个ModelAndView对象，代表了MVC Web程序中Model与View的对象
        //view代表跳转的页面，model代表传到前台的数据
        ModelAndView model = new ModelAndView();
        model.setViewName("admin/advert/addAdvert_bak");
        return model;
    }

    @RequestMapping("/add")
    @ResponseBody
    public String  add(CmsAdvert record,final String siteId){
        SysUser sysUser = (SysUser) session.getAttribute("user");
        try{
            if(sysUser != null){
                Integer count = cmsAdvertService.addCmsAdvert(record,sysUser);
                if(String.valueOf(count).equals("100")){
                    return Constant.ADVERT_NOT_INSERT;
                }else{
                    //删除缓存
                    Runnable runnable = new Runnable() {
                        @Override
                        public void run() {
                            cacheService.deleteValueByKey(CacheConstant.ADVERT_IMG+siteId);
                        }
                    };
                    Thread thread = new Thread(runnable);
                    thread.start();
                    return Constant.RESULT_STR_SUCCESS;
                }
            }
        }catch (Exception e){
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 根绝前台传过来的属性添加广告信息
     * 返回添加操作的返回值，后续跳转交由前台控制
     *
     * @param record CmsAdvert 广告会员
     * @author cj
     * @date 2015-04-28
     * @return String  操作成功为'success'、操作失败为'failure'
     */
    @RequestMapping(value = "/addAdvert")
    @ResponseBody
    public String addCmsAdvert(CmsAdvert record,final String siteId) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        int sendAdvertPosSort = 0;
        int[] listPosSort = null;
        try {
            final  String  _thisId = record.getAdvertPos();
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                record.setAdvertColumn(CmsAdvertServiceImpl.getAdvertPos(record.getAdvertPos()));
                record.setAdvertSite(record.getAdvertPos());
                List<CmsAdvert> cmsAdvertsList = cmsAdvertService.queryAdvertSitePosition(record);
                //获取从页面上会传递过来的 版位图片的顺序 编号
                sendAdvertPosSort = record.getAdvertPosSort();
                //表示该站点  对应的图片顺序为空，这样就可以直接写入
                if(cmsAdvertsList.size() == 0){
                    if( sendAdvertPosSort == 1 ){
                        count = cmsAdvertService.addCmsAdvert(record,sysUser);
                        if(count > 0){
                            if("100".equals(String.valueOf(count))){
                                return Constant.ADVERT_NOT_INSERT;
                            }else{

                                //删除缓存
                                Runnable runnable = new Runnable() {
                                    @Override
                                    public void run() {
                                        cacheService.deleteValueByKey(CacheConstant.ADVERT_IMG+_thisId);
                                    }
                                };
                                Thread thread = new Thread(runnable);
                                thread.start();

                                return Constant.RESULT_STR_SUCCESS;
                            }
                        }else{
                            return Constant.RESULT_STR_FAILURE;
                        }
                    } else {
                        return Constant.ADVERT_HAVE_POSITION;//插入的序号不是第一位，是否继续进行 需要重新调用插入的接口，会针对这个重新定义一个接口
                    }
                } else {
                    count = cmsAdvertService.addCmsAdvert(record,sysUser);
                    if(count > 0){
                        if("100".equals(String.valueOf(count))){
                            return Constant.ADVERT_NOT_INSERT;
                        }else{
                            //删除缓存
                           Runnable runnable = new Runnable() {
                                @Override
                                public void run() {
                                    cacheService.deleteValueByKey(CacheConstant.ADVERT_IMG+_thisId);
                                }
                            };
                            Thread thread = new Thread(runnable);
                            thread.start();
                            return Constant.RESULT_STR_SUCCESS;
                        }
                    }else{
                        return Constant.RESULT_STR_FAILURE;
                    }
                }
            }else{
                logger.error("当前登录用户不存在或没有登录，添加操作终止!");
            }
        } catch (Exception e) {
            logger.error("添加广告信息时出错!", e);
        }
        return Constant.RESULT_STR_FAILURE;

    }

    /**
     * 跳转到修改广告信息的页面
     *
     * @param advertId String 广告ID
     * @author cj
     * @date 2015-04-29
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/preEditAdvert")
    public ModelAndView preEditAdvert(String advertId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        CmsAdvert cmsAdvert = null;
        try {
            if(StringUtils.isNotBlank(advertId)){
                //根据广告ID查询广告信息
                cmsAdvert = cmsAdvertService.queryCmsAdvertById(advertId);
            }else{
                logger.error("广告ID为空，处理终止!");
            }
        } catch (Exception e) {
            logger.error("加载广告编辑页面时出错!",e);
        }
        model.setViewName("admin/advert/editAdvert");
        model.addObject("record", cmsAdvert);
        return model;
    }

    /**
     * 根绝前台传过来的属性修改广告信息
     * 返回修改操作的返回值，后续跳转交由前台控制
     *
     * @param record CmsAdvert 广告模型
     * @author cj
     * @date 2015-04-29
     * @return String  操作成功为'success'、操作失败为'failure'
     */
    @RequestMapping(value = "/editAdvert", method = RequestMethod.POST)
    @ResponseBody
    public String editAdvert(CmsAdvert record) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(record != null && StringUtils.isNotBlank(record.getAdvertId())){
                    //执行广告信息表数据更新操作
                    count= cmsAdvertService.editCmsAdvert(record,sysUser);
                }else{
                    logger.error("广告信息不存在或广告ID不存在，无法进行更新操作");
                }
            }else{
                logger.error("当前登录用户不存在，更新操作终止");
            }
        } catch (Exception e) {
            logger.error("修改广告信息时出错", e);
        }
        if(count>0){
            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 根据前台传入广告ID进行逻辑删除操作
     * 返回删除操作的返回值，后续跳转交由前台控制
     *
     * @param advertId String 广告ID
     * @author cj
     * @date 2015-04-29
     * @return String  操作成功为'success'、操作失败为'failure'  下架
     */
    @RequestMapping(value = "/deleteAdvert")
    @ResponseBody
    public String deleteCmsAdvert(String advertId, final String siteId) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(StringUtils.isNotBlank(advertId)){
                    //根据广告ID查询广告信息
                    CmsAdvert cmsAdvert = cmsAdvertService.queryCmsAdvertById(advertId);
                    count = cmsAdvertService.deleteCmsAdvert(cmsAdvert,sysUser);
                }else{
                    logger.error("广告ID为空，删除操作终止");
                }
            }else{
                logger.error("当前登录用户不存在，更新操作终止");
            }
        } catch (Exception e) {
            logger.error("逻辑删除广告信息时出错", e);
        }
        if(count>0){
            //删除缓存
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    cacheService.deleteValueByKey(CacheConstant.ADVERT_IMG+siteId);
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();

            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    @RequestMapping(value = "/recovery")
    @ResponseBody
    public String recoveryCmsAdvert(String id,final String siteId,String advertPosSort,String displayPosition,HttpServletRequest request) {
        try {
            SysUser user = (SysUser) request.getSession().getAttribute("user");
            if(user==null){
                return Constant.RESULT_STR_FAILURE;
            }

            //重新上线看该位置是否存在已上线的轮播图
            CmsAdvert advert = new CmsAdvert();
            advert.setAdvertPosSort(Integer.parseInt(advertPosSort));
            advert.setAdvertSite(siteId);
            if(StringUtils.isNotBlank(displayPosition)){
                advert.setDisplayPosition(displayPosition);
            }
            if(cmsAdvertService.queryExistSort(advert)>0){
                //当前排序已存在
                return  Constant.RESULT_STR_REPEAT;
            }

            cmsAdvertService.recoveryCmsAdvert(id,user);
            //删除缓存
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    cacheService.deleteValueByKey(CacheConstant.ADVERT_IMG+siteId);
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception e) {
            logger.error("修改广告信息时出错",e);
        }
        return Constant.RESULT_STR_FAILURE;
    }

    //删除
    @RequestMapping(value = "/delete")
    @ResponseBody
    public String deleteCmsAdvert(String id,final String siteId,HttpServletRequest request) {
        try {
            SysUser user = (SysUser) request.getSession().getAttribute("user");
            if(user==null){
                return Constant.RESULT_STR_FAILURE;
            }
            cmsAdvertService.deleteCmsAdvert(id, user);
            //删除缓存
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    cacheService.deleteValueByKey(CacheConstant.ADVERT_IMG+siteId);
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception e) {
            logger.error("修改广告信息时出错",e);
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 根绝前台传过来的广告ID进行单条查询
     * 返回广告信息数据至广告信息查看页面
     *
     * @param advertId String 广告ID
     * @author cj
     * @date 2015-04-29
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/viewAdvert")
    public ModelAndView viewCmsAdvert(String advertId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        List<SysDict> siteList = null;
        List<SysDict> columnList = null;
        List<SysDict> posList = null;
        CmsAdvert cmsAdvert = null;
        try {
            //数据字典中获取网站数据
            Map map = new HashMap();
            map.put("dictCode", "SITE");
            siteList = sysDictService.querySysDictByByMap(map);
            //数据字典中获取栏目数据
            map = new HashMap();
            map.put("dictCode", "COLUMN");
            columnList = sysDictService.querySysDictByByMap(map);
            //数据字典中获取版位数据
            map = new HashMap();
            map.put("dictCode", "POS");
            posList = sysDictService.querySysDictByByMap(map);
            //根据广告ID查询广告信息
            cmsAdvert = cmsAdvertService.queryCmsAdvertById(advertId);
        } catch (Exception e) {
            logger.error("查看广告信息时出错", e);
        }
        model.setViewName("admin/advert/viewAdvert");
        model.addObject("record", cmsAdvert);
        model.addObject("siteList",siteList);
        model.addObject("columnList",columnList);
        model.addObject("posList",posList);
        return model;
    }

    /**
     * 根据广告信息中的网站、栏目以及版位获取最大版位顺序
     *
     * @param cmsAdvert 广告信息
     * @author cj
     * @date 2015-05-08
     * @return
     */
    @RequestMapping(value = "/getMaxAdvertPosSort")
    @ResponseBody
    public int getMaxAdvertPosSort(CmsAdvert cmsAdvert) {
        Integer sort = 0;
        try {
            sort = cmsAdvertService.queryMaxAdvertPosSort(cmsAdvert);
        } catch (Exception e) {
            logger.error("根据某条广告的站点、栏目以及版位信息查找同种类型广告信息的最大排序数字时出错",e);
        }
        return sort;
    }

    /**
     * 根据站点名称以及栏目名称得到与之相关的广告信息
     *
     * @param
     * @param
     * @author cj
     * @date 2015-05-08
     * @return
     */
    @RequestMapping(value = "/getAdvertByName")
    @ResponseBody
    public List<CmsAdvert> getAdvertByName(CmsAdvert advert,String keyWord){
        List<CmsAdvert> advertList = null;
        try {
                advertList = cmsAdvertService.queryAdvertByName(advert.getAdvertSite(),keyWord);
        } catch (Exception e) {
            logger.error("根据站点名称以及栏目名称请求相应广告时出错",e);
        }
        return advertList;
    }

    @RequestMapping(value="/addAdvertShow" ,method= RequestMethod.GET)
    public ModelAndView addAdvertShow(CmsAdvert cmsAdvert,HttpServletRequest request){
        String linkType = request.getParameter("LinkType");
        ModelAndView model = new ModelAndView();
        model.addObject("cmsAdvert",cmsAdvert);
/*        if(StringUtils.isNotBlank(cmsAdvert.getAdvertId())){
            CmsAdvert advert = cmsAdvertService.queryCmsAdvertById(cmsAdvert.getAdvertId());
            model.addObject("record",advert);
        }*/
        SysUser user = (SysUser) session.getAttribute("user");
        if(user==null){
            return null;
        }
        if(StringUtils.isNotBlank(user.getUserCounty())){
            String key = user.getUserCounty().split(",")[0];
            if(!"45".equals(key)){
                String areaName = getAdvertPos(key);
                model.addObject("areaName",areaName);
                model.addObject("siteId",key);
            }
        }
        model.addObject("linkType",linkType);
        model.addObject("dictList",getRecList());
        model.setViewName("admin/advert/addAppAdvert");
        return model;
    }
    @RequestMapping(value="/editAdvertShow" ,method=RequestMethod.GET)
    public ModelAndView editAdvertShow(CmsAdvert cmsAdvert,HttpServletRequest request){

        String linkType = request.getParameter("LinkType");
        ModelAndView model = new ModelAndView();
        model.addObject("cmsAdvert",cmsAdvert);

        SysUser user = (SysUser) session.getAttribute("user");
        if(user==null){
            return null;
        }
        if(StringUtils.isNotBlank(user.getUserCounty())){
            String key = user.getUserCounty().split(",")[0];
            if(!"45".equals(key)){
                String areaName = getAdvertPos(key);
                model.addObject("areaName",areaName);
                model.addObject("siteId",key);
            }
        }

        if(StringUtils.isNotBlank(cmsAdvert.getAdvertId())){
            CmsAdvert advert = cmsAdvertService.queryCmsAdvertById(cmsAdvert.getAdvertId());
            model.addObject("record",advert);
        }
        model.addObject("linkType",linkType);
        model.addObject("dictList",getRecList());
        model.setViewName("admin/advert/addAppAdvert");
        return model;
    }

    @RequestMapping(value = "/getAdvertJson/{id}")
    @ResponseBody
    public List<CmsAdvert> getAdvertJson(@PathVariable String id) {
        List<CmsAdvert> list = this.cmsAdvertService.queryAdvertBySite(id,null);
        return list;
    }
 





    private List<SysDict> getRecList(){
        List<SysDict> sysDictList = new ArrayList<SysDict>();
        try{

            SysDict dict = new SysDict();
            dict.setDictState(Constant.NORMAL);
            dict.setDictCode("ADVERTRECDES");
            List<SysDict> dictList = sysDictService.querySysDictByByCondition(dict);

            if(CollectionUtils.isNotEmpty(dictList)){
                SysDict sysDict = dictList.get(0);
                dict.setDictCode(null);
                dict.setDictParentId(sysDict.getDictId());
                sysDictList = sysDictService.querySysDictByByCondition(dict);
            }
        }catch (Exception e){

        }

        return sysDictList;
    }


    public static String  getAdvertPos(String key){

        Map<String,Object> map = new HashMap<String, Object>();

        map.put("0",Constant.advertPos_app);

        map.put("45",Constant.advertPos_45);
        map.put("46",Constant.advertPos_46);
        map.put("48",Constant.advertPos_48);
        map.put("49",Constant.advertPos_49);
        map.put("50",Constant.advertPos_50);
        map.put("51",Constant.advertPos_51);
        map.put("52",Constant.advertPos_52);
        map.put("53",Constant.advertPos_53);
        map.put("54",Constant.advertPos_54);

        map.put("55",Constant.advertPos_55);
        map.put("56",Constant.advertPos_56);

        map.put("57",Constant.advertPos_57);
        map.put("58",Constant.advertPos_58);
        map.put("59",Constant.advertPos_59);
        map.put("60",Constant.advertPos_60);
        map.put("61",Constant.advertPos_61);

        map.put("63",Constant.advertPos_63);
        map.put("64",Constant.advertPos_64);

        return (String)map.get(key);
    }



    @RequestMapping(value ="/addHomeHotRecommendAdvert", method = RequestMethod.POST)
    @ResponseBody
    public String addHomeHotRecommendAdvert(CmsAdvert record,String startTime,String endTime) {
        System.out.println(startTime);
        //默认为0，如果后续流程执行出错，则操作失败
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        int count ;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(StringUtils.isNotBlank(startTime)) {
                    record.setActivityTime(sdf.parse(startTime));
                }
                if(StringUtils.isNotBlank(endTime)){
                    record.setActivityEndTime(sdf.parse(endTime));
                }
                 record.setIsRecommendType(1);
                count = cmsAdvertService.addRecommendCmsAdvert(record, sysUser);
                if(count > 0){
                        return Constant.RESULT_STR_SUCCESS;
                } else{

                    return Constant.RESULT_STR_FAILURE;
                }

            }else {
                logger.error("当前登录用户不存在或没有登录，添加操作终止!");
            }

        } catch (Exception e) {
            logger.error("添加广告信息时出错!", e);
        }
        return Constant.RESULT_STR_FAILURE;

    }


    //删除
    @RequestMapping(value = "/upateIsRecommendAdvert")
    @ResponseBody
    public String upateIsRecommendAdvert(HttpServletRequest request) {

        //获取 id
        String  advertId = request.getParameter("advertId");
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if( StringUtils.isNotBlank(advertId)){
                  CmsAdvert record =  new CmsAdvert();
                    record.setAdvertId(advertId);

                    //执行广告信息表数据更新操作
                    count= cmsAdvertService.editRecommendCmsAdvert(record,sysUser);
                }else{
                    logger.error("广告信息不存在或广告ID不存在，无法进行更新操作");
                }
            }else{
                logger.error("当前登录用户不存在，更新操作终止");
            }
        } catch (Exception e) {
            logger.error("修改广告信息时出错", e);
        }
        if(count>0){
            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }


    /**
     * app端轮播图管理List
     *
     * @param record CmsAdvert 广告对象，用于获取前台传递的查询参数
     * @param page   Pagination 分页功能对象
     * @return ModelAndView 页面跳转及数据传递
     */
    @RequestMapping(value = "/appRecommendadvertlist")
    public ModelAndView appRecommendadvertlist(CmsAdvert record, Pagination page) {
        //创建一个ModelAndView对象，代表了MVC Web程序中Model与View的对象
        //view代表跳转的页面，model代表传到前台的数据
        ModelAndView model = new ModelAndView();
        List<CmsAdvert> list = null;
        List<CmsAdvert> pageList = new ArrayList<CmsAdvert>();
        try {
            SysUser user = (SysUser) session.getAttribute("user");
            if(user==null){
                return null;
            }
            if(StringUtils.isNotBlank(user.getUserCounty())){
                String key = user.getUserCounty().split(",")[0];
                if(!"45".equals(key))
                    record.setAdvertSite(key);
            }

            list = cmsAdvertService.appRecommendadvertlist(record,page);

            for(CmsAdvert cmsAdvert:list){
                CmsAdvert cmsAdverts = cmsAdvert;
                String url = cmsAdvert.getAdvertPicUrl();
                if(StringUtils.isNotBlank(url)){
                    String[] picUrl = url.split("\\.");
                    String picUrls = picUrl[0]+"_300_300."+picUrl[1];
                    cmsAdverts.setAdvertPicUrl(picUrls);
                }
                pageList.add(cmsAdverts);
            }
        } catch (Exception e) {
            logger.error("加载广告列表页面时出错!",e);
        }
        model.setViewName("admin/advert/advertIndex");
        model.addObject("list", pageList);
        model.addObject("page", page);
        model.addObject("record",record);
        model.addObject("LinkType","APP");
        return model;
    }



}
