package com.sun3d.why.controller.wechat;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sun3d.why.model.BpAntique;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.BpAntiqueService;

@RequestMapping("/wechatBpAntique")
@Controller
public class WechatBpAntiqueController {
	private Logger logger = Logger.getLogger(WechatBpAntiqueController.class);
	@Autowired
	BpAntiqueService bpAntiqueService;
	@Autowired
	private CacheService cacheService;
	/**
     * wechat获取文物列表
     *
     * @param pageIndex 首页下表
     * @param pageNum   显示条数
     * @return json 
     */
    @RequestMapping(value = "/antiqueList")
    public String antiqueList(HttpServletResponse response, String pageIndex, String pageNum, PaginationApp pageApp) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
             json = bpAntiqueService.queryBpAntiqueList(pageApp);
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
     * 文物列表页
     * @param venueId
     * @return
     */
    @RequestMapping("/preAntiqueList")
    public String preAntiqueList(HttpServletRequest request){
        //微信权限验证配置
        return "wechat/bpAntique/bpAntiqueList";
    }
    /**
	 * 文物详情页
	 * @param antiqueId
	 * @param type（fromComment：评论完跳转）
	 * @param showMenu (不显示菜单)
	 * @return
	 */
	@RequestMapping("/preAntiqueDetail")
	public String preAntiqueDetail(HttpServletRequest request,HttpSession session, String antiqueId, String type, String showMenu) {
		CmsTerminalUser terminalUser =(CmsTerminalUser) session.getAttribute("terminalUser");
		String userId = null;
		if(terminalUser!=null){
			userId = terminalUser.getUserId();
		}
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		BpAntique bpAntique = bpAntiqueService.queryBpAntiqueById(antiqueId,userId);
		request.setAttribute("sign", sign);
		request.setAttribute("antiqueId", antiqueId);
		request.setAttribute("bpAntique", bpAntique);
		request.setAttribute("type", type);
		request.setAttribute("showMenu", showMenu);
		return "wechat/bpAntique/bpAntiqueDetail";
	}
	
}
