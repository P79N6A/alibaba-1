package com.sun3d.why.controller.wechat;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.BpProductService;

@RequestMapping("/wechatBpProduct")
@Controller
public class WechatBpProductController {
	private Logger logger = Logger.getLogger(WechatBpProductController.class);
	@Autowired
	BpProductService bpProductService;
	@Autowired
	private CacheService cacheService;
	/**
	 * 商城列表页
	 * @param venueId
	 * @return
	 */
	@RequestMapping("/preProductList")
	public ModelAndView preProductList(HttpServletRequest request){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("wechat/bpProduct/dpProductList");
		return mv;
	}
	/**
     * 商城列表数据
     *
     * @param pageIndex 首页下表
     * @param pageNum   显示条数
     * @return json 
     */
    @RequestMapping(value = "/productList")
    @ResponseBody
    public List<BpProduct> antiqueList(HttpServletResponse response, String startIndex, String pageSize, PaginationApp pageApp,String productModule) throws Exception {
    	List<BpProduct> productList = new ArrayList<BpProduct>();
    	pageApp.setFirstResult(Integer.valueOf(startIndex));
        pageApp.setRows(Integer.valueOf(pageSize));
        try {
        	productList = bpProductService.queryBpProductList(productModule,pageApp);
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query antiqueIndex error" + e.getMessage());
        }
        
        return productList;
    }
    /**
	 * 商品详情页
	 * @param productId
	 * @param type（fromComment：评论完跳转）
	 * @param showMenu (不显示菜单)
	 * @return
	 */
	@RequestMapping("/preProductDetail")
	public String preProductDetail(HttpServletRequest request,HttpSession session, String productId, String type, String showMenu) {
		CmsTerminalUser terminalUser =(CmsTerminalUser) session.getAttribute("terminalUser");
		String userId = null;
		if(terminalUser!=null){
			userId = terminalUser.getUserId();
		}
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		BpProduct bpProduct = bpProductService.queryBpProductById(productId,userId);
		request.setAttribute("sign", sign);
		request.setAttribute("productId", productId);
		request.setAttribute("bpProduct", bpProduct);
		request.setAttribute("type", type);
		request.setAttribute("showMenu", showMenu);
		return "wechat/bpProduct/bpProductDetail";
	}
	/**
	 * 提交商品预约信息
	 * @param record BpProductOrder 商品信息
	 * @return String  操作成功为'success'、操作失败为'failure'
	 */
	@RequestMapping(value = "/submitOrder")
    @ResponseBody
    public String submitOrder(BpProductOrder record,String productId) {
        int count = 0;
        if(StringUtils.isNotBlank(productId)){
        	record.setProductId(productId);
        }
        try {
              count = bpProductService.addBpProductOrder(record);
        } catch (Exception e) {
            logger.error("添加商品预约信息时出错!", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    
}
