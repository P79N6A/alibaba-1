package com.sun3d.why.filter;

import com.sun3d.why.controller.SysModuleController;
import com.sun3d.why.model.SysModule;
import com.sun3d.why.model.SysUser;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.input.SAXBuilder;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

/**
 * Created by yujinbing on 2015/5/4.
 */
public class SecurityServlet implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        HttpSession session = request.getSession(false);
        SysUser user = null;
        if (session != null) {
            user = (SysUser) session.getAttribute("user");
        }
        String url = request.getRequestURI();
        String allUrl = request.getContextPath() + url;
        /*Map<String, String> map =initModule(request);

        if (user == null) {
            if (map.containsKey(allUrl)) {
                // response.sendRedirect(request.getContextPath() + "/login.do");
                request.getRequestDispatcher(request.getContextPath() + "/login.do").forward(request, response);

            }
        }*/
        filterChain.doFilter(request, response);

    }

    public boolean isFrontAction(String url) {
        List list = new ArrayList();
        String[] urls = {
                "/login.do", "/user/loginCheckSysUser.do", "/frontActivity/frontActivityIndex.do",
                "/index.do", "/frontActivity/frontActivityDetail.do"
        };
        Map<String, String> map = new HashMap<String, String>();
        for (String key : urls) {
            map.put(key, "1");
        }
        if (map.containsKey(url)) {
            return false;
        } else {
            return true;
        }
    }

    @Override
    public void destroy() {

    }


   /* public Map<String, String> initModule(HttpServletRequest request) {
        Map<String, String> map = new HashMap<String, String>();
        String flag = "初始化失败";
        SAXBuilder bui = new SAXBuilder();
        Document doc = null;
        try {
            doc = bui.build(SysModuleController.class.getResourceAsStream("/accessControl.xml"));
            Element element = null;
            Element root = doc.getRootElement();
            List<Element> list = root.getChildren();
            if (list.size() > 0) {
                SysModule module = null;
                Date date = new Date();
                //SysRoleModuleExample roleModuleExample = new SysRoleModuleExample();
               // SysModuleExample moduleExample = new SysModuleExample();
                for (int i = 0; i < list.size(); i++) {
                    element = list.get(i);
                    // 父节点
                    String name = element.getAttributeValue("name");
                    String url = element.getAttributeValue("url");
                    url = url.replaceAll("\\$" + "\\{path\\}", "");
                    map.put(request.getContextPath() + url, "true");
                    // 子节点
                    List<Element> son = element.getChildren();
                    for (int j = 0; j < son.size(); j++) {
                        Element e = son.get(j);
                        String url1 = e.getAttributeValue("url");
                        url1 = url1.replaceAll("\\$" + "\\{path\\}", "");
                        map.put(request.getContextPath() + url1, "true");
                    }
                }
            }
            map.put(request.getContextPath() + "/admin.do", "true");
            flag = "初始化成功！";
        } catch (Exception e) {
            flag = "初始化失败！";
            e.printStackTrace();
        }
        return map;
    }*/

}
