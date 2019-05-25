package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.BpAntique;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.BpAntiqueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping(value = "/bpAntique")
@Controller
public class BpAntiqueController {
	private Logger logger = Logger.getLogger(BpAntiqueController.class);
	@Autowired
	private BpAntiqueService bpAntiqueService;
	//当前session
    @Autowired
    private HttpSession session;
	/**
     * 跳转到文化文物列表的首页面
     *
     * @param record   BpAntique 藏品信息
     * @param page     Pagination 分页功能类
     * @return ModelAndView 页面及参数
     * @author jh
     * @date 2017-08-04
     */
    @RequestMapping(value = "/antiqueIndex")
    public ModelAndView antiqueIndex(BpAntique record, Pagination page, String searchKey,String antiqueDynasty,String antiqueType) {
        ModelAndView model = new ModelAndView();
        List<BpAntique> list = null;
        try {
            if(StringUtils.isNotBlank(searchKey)){
            	record.setSearchKey(searchKey);
            }
            if(StringUtils.isNotBlank(antiqueDynasty)){
            	record.setAntiqueDynasty(antiqueDynasty);
            }
            if(StringUtils.isNotBlank(antiqueType)){
            	record.setAntiqueType(antiqueType);
            }
            //session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //根据页面查询条件请求馆藏信息列表
                list = bpAntiqueService.queryBpAntiqueByCondition(page, record,  sysUser);
            } else {
                logger.error("当前登录用户不存在，文化文物列表处理终止!");
            }
        } catch (Exception e) {
            logger.error("跳转至文化文物列表页时出错!", e);
        }
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("record", record);
        model.addObject("searchKey", searchKey);
        model.setViewName("admin/bpAntique/antiqueIndex");
        return model;
    }

	/**
	 * 预发布文化文物
	 * 
	 * @return ModelAndView 页面及参数
	 */
	@RequestMapping(value = "/prePublishAntique")
	public ModelAndView prePublishAntique() {
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/bpAntique/publishAntique");
		return model;
	}
	/**
	 * 发布文化文物
	 * @param record BpAntique 文物信息
	 * @return String  操作成功为'success'、操作失败为'failure'
	 */
	@RequestMapping(value = "/publishAntique")
    @ResponseBody
    public String publishAntique(BpAntique record) {
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //插入操作
                count = bpAntiqueService.addBpAntique(record, sysUser);
            } else {
                logger.error("当前登录用户不存在，添加文物处理终止!");
            }
        } catch (Exception e) {
            logger.error("添加文物信息时出错!", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
	 /**
     * 逻辑删除操作(将ANTIQUE_IS_DEL值设为2)
     * @param antiqueId String 文物ID
     * @return String  操作成功为'success'、操作失败为'failure'
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
                    //执行馆藏信息表数据更新操作
                    count = bpAntiqueService.deleteBpAntique(antiqueId,sysUser);
                } else {
                    logger.error("文物ID为空，逻辑删除处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，逻辑删除处理终止!");
            }
        } catch (Exception e) {
            logger.error("逻辑删除文物信息时出错", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    /**
     * 文物上架,下架
     * @param antiqueId 文物id
     * @param antiqueIsDel 文物状态 1:上架;2:删除;3:下架
     * @return String  操作成功为'success'、操作失败为'failure'
     */
    @RequestMapping(value = "/removeAntique")
    @ResponseBody
    public String removeAntique(String antiqueId,String antiqueIsDel) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (StringUtils.isNotBlank(antiqueId) && StringUtils.isNotBlank(antiqueIsDel)) {
                    //执行馆藏信息表数据更新操作
                    count = bpAntiqueService.removeBpAntique(antiqueId,antiqueIsDel,sysUser);
                } else {
                    logger.error("文物ID或状态为空，上/下架处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，上/下架处理终止!");
            }
        } catch (Exception e) {
            logger.error("上/下架文物时出错", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    
    /**
     * 跳转到修改文物信息的页面
     * @param antiqueId 文物ID
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/preEditAntique")
    public ModelAndView preEditAntique(String antiqueId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        BpAntique bpAntique = null;
        try {
            if (StringUtils.isNotBlank(antiqueId)) {
                //根据馆藏ID查询馆藏信息
                bpAntique = bpAntiqueService.queryBpAntiqueById(antiqueId);
            } else {
                logger.error("文物ID为空，加载文物处理终止！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("跳转至文物修改页面时出错", e);
        }
        model.setViewName("admin/bpAntique/editAntique");
        model.addObject("record", bpAntique);
        return model;
    }
    /**
     * 修改文物信息
     * @param BpAntique record BpAntique 文物信息
     * @return String  操作成功为'success'、操作失败为'failure'
     */
    @RequestMapping(value = "/editAntique")
    @ResponseBody
    public String editAntique(BpAntique record) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
            	if (record != null && StringUtils.isNotBlank(record.getAntiqueId())) {
                    //执行馆藏信息表数据更新操作
                    count = bpAntiqueService.editbpAntique(record, sysUser);
                } else {
                    logger.error("文物信息或文物ID为空，更新处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，修改处理终止!");
            }
        } catch (Exception e) {
            logger.error("修改文物信息时出错", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
}
