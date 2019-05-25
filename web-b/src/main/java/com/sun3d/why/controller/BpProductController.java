package com.sun3d.why.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.BpProduct;
import com.sun3d.why.model.BpProductOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.BpProductService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping(value = "/bpProduct")
@Controller
public class BpProductController {
	private Logger logger = Logger.getLogger(BpProductController.class);
	@Autowired
	private BpProductService bpProductService;
	//当前session
    @Autowired
    private HttpSession session;
    
    /**
     * 跳转到文化商城列表的首页面
     *
     * @param record   BpProduct 商品信息
     * @param page     Pagination 分页功能类
     * @return ModelAndView 页面及参数
     * @author jh
     * @date 2017-08-09
     */
    @RequestMapping(value = "/productIndex")
    public ModelAndView productIndex(BpProduct record, Pagination page, String searchKey,String createStartTime,String createEndTime) {
        ModelAndView model = new ModelAndView();
        List<BpProduct> list = null;
        try {
            if(StringUtils.isNotBlank(searchKey)){
            	record.setSearchKey(searchKey);
            }
            
            //session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //根据页面查询条件请求商品信息列表
                list = bpProductService.queryBpProductByCondition(page, record,  sysUser,createStartTime,createEndTime);
            } else {
                logger.error("当前登录用户不存在，文化商城列表处理终止!");
            }
        } catch (Exception e) {
            logger.error("跳转文化商城列表页时出错!", e);
        }
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("record", record);
        model.addObject("searchKey", searchKey);
        model.addObject("createStartTime", createStartTime);
        model.addObject("createEndTime", createEndTime);
        model.setViewName("admin/bpProduct/productIndex");
        return model;
    }
	/**
	 * 预发布文化商城
	 * 
	 * @return ModelAndView 页面及参数
	 */
	@RequestMapping(value = "/prePublishProduct")
	public ModelAndView prePublishProduct() {
		ModelAndView model = new ModelAndView();
		model.setViewName("admin/bpProduct/publishProduct");
		return model;
	}
	/**
	 * 发布文化商城
	 * @param record BpProduct 商品信息
	 * @return String  操作成功为'success'、操作失败为'failure'
	 */
	@RequestMapping(value = "/publishProduct")
    @ResponseBody
    public String publishProduct(BpProduct record) {
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //插入操作
                count = bpProductService.addBpProduct(record, sysUser);
            } else {
                logger.error("当前登录用户不存在，添加商品处理终止!");
            }
        } catch (Exception e) {
            logger.error("添加商品信息时出错!", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
	
	/**
     * 逻辑删除操作(将PRODUCT_STATUS值设为2)
     * @param productId String 商品ID
     * @return String  操作成功为'success'、操作失败为'failure'
     */
    @RequestMapping(value = "/deleteProduct")
    @ResponseBody
    public String deleteProduct(String productId) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (StringUtils.isNotBlank(productId)) {
                    //执行商品信息表数据更新操作
                    count = bpProductService.deleteBpProduct(productId,sysUser);
                } else {
                    logger.error("商品ID为空，逻辑删除处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，逻辑删除处理终止!");
            }
        } catch (Exception e) {
            logger.error("逻辑删除商品信息时出错", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    /**
     * 商品上架,下架
     * @param productId 商品id
     * @param productStatus 商品状态 1:上架;2:删除;3:下架
     * @return String  操作成功为'success'、操作失败为'failure'
     */
    @RequestMapping(value = "/removeProduct")
    @ResponseBody
    public String removeProduct(String productId,String productStatus) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                if (StringUtils.isNotBlank(productId) && StringUtils.isNotBlank(productStatus)) {
                    //执行商品信息表数据更新操作
                    count = bpProductService.removeBpProduct(productId,productStatus,sysUser);
                } else {
                    logger.error("商品ID或状态为空，上/下架处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，上/下架处理终止!");
            }
        } catch (Exception e) {
            logger.error("上/下架商品时出错", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    /**
     * 跳转到修改商品信息的页面
     * @param productId 商品ID
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/preEditProduct")
    public ModelAndView preEditProduct(String productId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        BpProduct bpProduct = null;
        try {
            if (StringUtils.isNotBlank(productId)) {
                //根据馆藏ID查询馆藏信息
            	bpProduct = bpProductService.queryBpProductById(productId);
            } else {
                logger.error("商品ID为空，加载商品处理终止！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("跳转至商品修改页面时出错", e);
        }
        model.setViewName("admin/bpProduct/editProduct");
        model.addObject("record", bpProduct);
        return model;
    }
    /**
     * 修改商品信息
     * @param BpProduct record 
     * @return String  操作成功为'success'、操作失败为'failure'
     */
    @RequestMapping(value = "/editProduct")
    @ResponseBody
    public String editProduct(BpProduct record) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
            	if (record != null && StringUtils.isNotBlank(record.getProductId())) {
                    //执行商品信息表数据更新操作
                    count = bpProductService.editbpProduct(record, sysUser);
                } else {
                    logger.error("商品信息或商品ID为空，更新处理终止！");
                }
            } else {
                logger.error("当前登录用户不存在或没有登录，修改处理终止!");
            }
        } catch (Exception e) {
            logger.error("修改商品信息时出错", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    /**
     * 查看预约信息
     * @param productId 商品ID
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/orderIndex")
    public ModelAndView orderIndex(Pagination page,String productId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        List<BpProductOrder> orderList = new ArrayList<BpProductOrder>();
        try {
            if (StringUtils.isNotBlank(productId)) {
                //根据商品id查询预约信息
            	orderList = bpProductService.queryOrderByProductId(page,productId);
            } else {
                logger.error("商品ID为空！查看预约信息出错");
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("查看预约信息出错", e);
        }
        model.setViewName("admin/bpProduct/orderIndex");
        model.addObject("productId", productId);
        model.addObject("orderList", orderList);
        model.addObject("page", page);
        return model;
    } 
}
