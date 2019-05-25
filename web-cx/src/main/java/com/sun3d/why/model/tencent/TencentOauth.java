package com.sun3d.why.model.tencent;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;

import com.qq.connect.QQConnectException;
import com.qq.connect.oauth.Oauth;
import com.qq.connect.utils.QQConnectConfig;
import com.qq.connect.utils.RandomStatusGenerator;

/**
 * Created by yujinbing on 2015/12/23.
 */
public class TencentOauth extends Oauth {

    public String getAuthorizeURL(HttpServletRequest request) throws QQConnectException {
        String state = RandomStatusGenerator.getUniqueState();
        ((HttpServletRequest)request).getSession().setAttribute("qq_connect_state", state);
        String scope = QQConnectConfig.getValue("scope");
        String callback = request.getParameter("callback");
        if (StringUtils.isBlank(callback)) {
            return scope != null && !scope.equals("")?this.getAuthorizeURL("code", state, scope):QQConnectConfig.getValue("authorizeURL").trim() + "?client_id=" + QQConnectConfig.getValue("app_ID").trim() + "&redirect_uri=" + QQConnectConfig.getValue("redirect_URI").trim() + "&response_type=" + "code" + "&state=" + state;
        } else {
            return scope != null && !scope.equals("")?this.getAuthorizeURL("code", state, scope,callback):QQConnectConfig.getValue("authorizeURL").trim() + "?client_id=" + QQConnectConfig.getValue("app_ID").trim() + "&redirect_uri=" + QQConnectConfig.getValue("redirect_URI").trim() + "?callback=" + callback + "&response_type=" + "code" + "&state=" + state;
        }
    }

    /** @deprecated */
    public String getAuthorizeURL(String response_type, String state, String scope,String callback) throws QQConnectException {
        try {
			return QQConnectConfig.getValue("authorizeURL").trim() + "?client_id=" + QQConnectConfig.getValue("app_ID").trim() + "&redirect_uri=" + URLEncoder.encode(QQConnectConfig.getValue("redirect_URI").trim()+ "?callback=" + callback,"UTF-8") +  "&response_type=" + response_type + "&state=" + state + "&scope=" + scope;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return QQConnectConfig.getValue("authorizeURL").trim() + "?client_id=" + QQConnectConfig.getValue("app_ID").trim() + "&redirect_uri=" + QQConnectConfig.getValue("redirect_URI").trim()+ "?callback=" + callback +  "&response_type=" + response_type + "&state=" + state + "&scope=" + scope;
		}
    }
}
