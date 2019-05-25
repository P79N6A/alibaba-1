package com.sun3d.why.controller;

import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsAntiqueService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 藏品模块控制层，负责跟页面数据的交互以及对下层的数据方法的调用
 * </p>
 * Created by cj on 2015/4/21.
 */
@Controller
@RequestMapping(value = "/antique")
public class CmsAntiqueController {

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
     * 自动注入请求对应的session实例
     */
    @Autowired
    private HttpSession session;
    /**
     * log4j日志
     */
    private Logger logger = Logger.getLogger(CmsAntiqueController.class);

    /**
     * 跳转到藏品管理的首页面
     *
     * @param record   CmsAntique 藏品信息
     * @param page     Pagination 分页功能类
     * @param cmsVenue CmsVenue 场馆信息
     * @return ModelAndView 页面及参数
     * @author cj
     * @date 2015-04-28
     */
    @RequestMapping(value = "/antiqueIndex")
    public ModelAndView antiqueIndex(CmsAntique record, Pagination page, String searchKey, CmsVenue cmsVenue) {
        ModelAndView model = new ModelAndView();
        List<CmsAntique> list = null;
        try {
            if (StringUtils.isNotBlank(cmsVenue.getVenueId())) {
                cmsVenue = cmsVenueService.queryVenueById(cmsVenue.getVenueId());
            }
            if(StringUtils.isNotBlank(searchKey)){
            	record.setSearchKey(searchKey);
            }
            //session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //根据页面查询条件请求馆藏信息列表
                list = cmsAntiqueService.queryCmsAntiqueByCondition(page, record, cmsVenue, sysUser);
            } else {
                logger.error("当前登录用户不存在，馆藏列表处理终止!");
            }
        } catch (Exception e) {
            logger.error("跳转至藏品管理页时出错!", e);
        }
        //等于1时返回草稿箱
        if (String.valueOf(Constant.DRAFT).equals(String.valueOf(record.getAntiqueState()))) {
            model.setViewName("admin/antique/antiqueDraftList");
        } else if (String.valueOf(Constant.TRASH).equals(String.valueOf(record.getAntiqueState()))) {
            model.setViewName("admin/antique/antiqueRecycleList");
        } else {
            model.setViewName("admin/antique/antiqueIndex");
        }
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("record", record);
        model.addObject("searchKey", searchKey);
        model.addObject("cmsVenue", cmsVenue);
        return model;
    }

    /**
     * 跳转到添加馆藏的页面
     *
     * @return ModelAndView 页面及参数
     * @author cj
     * @date 2015-04-28
     */
    @RequestMapping(value = "/preAddAntique")
    public ModelAndView preAddAntique(String venueId) {
        /**
         * 添加时场馆Id
         */
        ModelAndView model = new ModelAndView();
        try {
            if (StringUtils.isNotBlank(venueId)) {
                CmsVenue cmsVenue = cmsVenueService.queryVenueById(venueId);
                model.addObject("cmsVenue", cmsVenue);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        model.setViewName("admin/antique/addAntique");
        return model;
    }

    /**
     * 根绝前台传过来的属性添加馆藏信息
     * 返回添加操作的返回值，后续跳转交由前台控制
     *
     * @param record CmsAntique 藏品信息
     * @return String  操作成功为'success'、操作失败为'failure'
     * @author cj
     * @date 2015-04-28
     */
    @RequestMapping(value = "/addAntique")
    @ResponseBody
    public String addAntique(CmsAntique record) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //执行馆藏信息入库操作
                count = cmsAntiqueService.addCmsAntique(record, sysUser);
            } else {
                logger.error("当前登录用户不存在，馆藏列表处理终止!");
            }
        } catch (Exception e) {
            logger.error("添加馆藏信息时出错!", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 跳转到修改藏品信息的页面
     *
     * @param antiqueId    String 藏品信息ID
     * @param antiqueState String 馆藏状态
     * @param antiqueIsDel String 馆藏是否删除标记
     * @return ModelAndView 页面及参数
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/preEditAntique")
    public ModelAndView preEditAntique(String antiqueId, String antiqueState, String antiqueIsDel, String venueId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        CmsAntique cmsAntique = null;
        CmsVenue cmsVenue = null;
        try {
            if (StringUtils.isNotBlank(antiqueId)) {
                //根据馆藏ID查询馆藏信息
                cmsAntique = cmsAntiqueService.queryCmsAntiqueById(antiqueId);
                cmsVenue = cmsVenueService.queryVenueById(cmsAntique.getVenueId());
            } else {
                logger.error("馆藏信息或馆藏ID为空，加载馆藏处理终止！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("跳转至馆藏修改页面时出错", e);
        }
        model.setViewName("admin/antique/editAntique");
        model.addObject("record", cmsAntique);
        model.addObject("cmsVenue", cmsVenue);
        model.addObject("antiqueState", antiqueState);
        model.addObject("antiqueIsDel", antiqueIsDel);
        model.addObject("venueId", venueId);
        return model;
    }

    /**
     * 根绝前台传过来的属性修改馆藏信息
     * 返回修改操作的返回值，后续跳转交由前台控制
     *
     * @param record CmsAntique 藏品信息
     * @return String  操作成功为'success'、操作失败为'failure'
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/editAntique", method = RequestMethod.POST)
    @ResponseBody
    public String editAntique(CmsAntique record) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (record != null && StringUtils.isNotBlank(record.getAntiqueId())) {
                    //执行馆藏信息表数据更新操作
                    count = cmsAntiqueService.editCmsAntique(record, sysUser);
                } else {
                    logger.error("馆藏信息或馆藏ID为空，更新处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，更新处理终止!");
            }
        } catch (Exception e) {
            logger.error("修改馆藏信息时出错", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }


    /**
     * 根绝前台传过来的藏品ID进行逻辑删除操作
     * 返回删除操作的返回值，后续跳转交由前台控制
     *
     * @param antiqueId String 藏品信息ID
     * @return String  操作成功为'success'、操作失败为'failure'
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/deleteAntique")
    @ResponseBody
    public String deleteAntique(String antiqueId) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (StringUtils.isNotBlank(antiqueId)) {
                    //根据馆藏ID查询馆藏信息
                    CmsAntique record = cmsAntiqueService.queryCmsAntiqueById(antiqueId);
                    //执行馆藏信息表数据更新操作
                    count = cmsAntiqueService.deleteCmsAntique(record, sysUser);
                } else {
                    logger.error("馆藏ID为空，逻辑删除处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，逻辑删除处理终止!");
            }
        } catch (Exception e) {
            logger.error("逻辑删除馆藏信息时出错", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 根绝前台传过来的藏品ID进行逻辑删除操作
     * 返回恢复操作的返回值，后续跳转交由前台控制
     *
     * @param antiqueId String 藏品信息ID
     * @return String  操作成功为'success'、操作失败为'failure'
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/recoverAntique")
    @ResponseBody
    public String recoverAntique(String antiqueId) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (StringUtils.isNotBlank(antiqueId)) {
                    //根据馆藏ID查询馆藏信息
                    CmsAntique record = cmsAntiqueService.queryCmsAntiqueById(antiqueId);
                    //执行馆藏信息表数据更新操作
                    count = cmsAntiqueService.recoverCmsAntique(record, sysUser);
                } else {
                    logger.error("馆藏ID为空，恢复馆藏处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，逻辑删除处理终止!");
            }
        } catch (Exception e) {
            logger.error("从回收站中恢复馆藏信息时出错", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 根绝前台传过来的藏品ID进行单条查询
     * 返回藏品信息数据至藏品信息查看页面
     *
     * @param antiqueId String 藏品信息ID
     * @return ModelAndView 页面及参数
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/viewAntique")
    public ModelAndView viewAntique(String antiqueId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        List<SysDict> sysDictList = null;
        CmsAntique cmsAntique = null;
        CmsVenue cmsVenue = null;
        try {
            //查询数据字典中馆藏信息相关的数据
            Map map = new HashMap();
            map.put("dictCode", "ANTIQUE");
            sysDictList = sysDictService.querySysDictByByMap(map);
            //根据馆藏ID查询馆藏信息
            cmsAntique = cmsAntiqueService.queryCmsAntiqueById(antiqueId);
            //如果馆藏信息不为空且场馆ID不为空，则请求场馆信息
            if (cmsAntique != null && StringUtils.isNotBlank(cmsAntique.getVenueId())) {
                cmsVenue = cmsVenueService.queryVenueById(cmsAntique.getVenueId());
            }
        } catch (Exception e) {
            logger.error("加载馆藏查看页面时出错", e);
        }
        model.setViewName("admin/antique/viewAntique");
        model.addObject("record", cmsAntique);
        model.addObject("sysDictList", sysDictList);
        model.addObject("cmsVenue", cmsVenue);
        return model;
    }


    @RequestMapping(value = "/updateState")
    @ResponseBody
    public String updateAntiqueState(String antiqueId) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (StringUtils.isNotBlank(antiqueId)) {
                    return cmsAntiqueService.updateAntiqueStateById(antiqueId, sysUser);
                } else {
                    logger.error("馆藏ID为空，更新处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，逻辑删除处理终止!");
            }
        } catch (Exception e) {
            logger.error("更新馆藏信息时出错", e);
        }
        return Constant.RESULT_STR_FAILURE;
    }

    @RequestMapping(value = "/physicalDelete")
    @ResponseBody
    public String physicalDelete(String antiqueId) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (StringUtils.isBlank(antiqueId)) {
                    cmsAntiqueService.deleteAntiqueById(antiqueId);
                    logger.info("系统用户" + sysUser.getUserId() + "删除藏品" + antiqueId);
                    return Constant.RESULT_STR_SUCCESS;
                } else {
                    logger.error("馆藏ID为空，逻辑删除处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，逻辑删除处理终止!");
            }
        } catch (Exception e) {
            logger.error("逻辑删除馆藏信息时出错", e);
        }
        return Constant.RESULT_STR_FAILURE;
    }


}
