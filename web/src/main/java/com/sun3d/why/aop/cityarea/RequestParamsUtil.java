package com.sun3d.why.aop.cityarea;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

public class RequestParamsUtil {

	
	public static String getRequestParams(HttpServletRequest request)
	{
		Map map = new HashMap();
		Enumeration paramNames = request.getParameterNames();
		while (paramNames.hasMoreElements()) {
			String paramName = (String) paramNames.nextElement();

			String[] paramValues = request.getParameterValues(paramName);
			if (paramValues.length == 1) {
				String paramValue = paramValues[0];
				if (paramValue.length() != 0) {
					map.put(paramName, paramValue);
				}
			}
		}
		String str = "";
		Set<Map.Entry<String, String>> set = map.entrySet();

		for (Map.Entry entry : set) {
			str += entry.getKey() + ":" + entry.getValue() + ",";
			// System.out.println(entry.getKey() + ":" + entry.getValue());
		}
		if (str != null && str.length() > 0) {
			str = str.substring(0, str.length() - 1);

		}
		return str;
	}
}
