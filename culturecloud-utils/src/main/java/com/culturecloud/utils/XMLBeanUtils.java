package com.culturecloud.utils;

import java.io.InputStream;
import java.util.Iterator;
import java.util.Map;

import com.google.gson.Gson;
import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.Dom4JDriver;

@SuppressWarnings({ "rawtypes", "unchecked" })
public final class XMLBeanUtils {
	/**
	 * ��Beanת��ΪXML
	 * 
	 * @param clazzMap
	 *            ����-����ӳ��Map
	 * @param bean
	 *            Ҫת��Ϊxml��bean����
	 * @return XML�ַ�
	 */
	public static String bean2xml(Map<String, Class> clazzMap, Object bean) {
		XStream xstream = new XStream();
		for (Iterator it = clazzMap.entrySet().iterator(); it.hasNext();) {

			Map.Entry<String, Class> m = (Map.Entry<String, Class>) it.next();
			xstream.alias(m.getKey(), m.getValue());
		}
		String xml = xstream.toXML(bean).replace("__", "_");
		return xml;
	}

	/**
	 * ��XMLת��ΪBean
	 * 
	 * @param clazzMap
	 *            ����-����ӳ��Map
	 * @param xml
	 *            Ҫת��Ϊbean�����xml�ַ�
	 * @return Java Bean����
	 */

	public static Object xml2Bean(Map<String, Class> clazzMap, String xml) {
		XStream xstream = new XStream();
		for (Iterator it = clazzMap.entrySet().iterator(); it.hasNext();) {
			Map.Entry<String, Class> m = (Map.Entry<String, Class>) it.next();
			xstream.alias(m.getKey(), m.getValue());
		}
		Object bean = xstream.fromXML(xml);
		return bean;
	}

	/**
	 * ��ȡXStream����
	 * 
	 * @param clazzMap
	 *            ����-����ӳ��Map
	 * @return XStream����
	 */
	public static XStream getXStreamObject(Map<String, Class> clazzMap) {
		XStream xstream = new XStream();
		for (Iterator it = clazzMap.entrySet().iterator(); it.hasNext();) {
			Map.Entry<String, Class> m = (Map.Entry<String, Class>) it.next();
			xstream.alias(m.getKey(), m.getValue());
		}
		return xstream;
	}

	/**
	 * xml ת��Json
	 * 
	 * @param xml
	 * @param clazz
	 * @return
	 */
	public static String xmlToJson(InputStream in, Class<?> clazz) {
		XStream xstream = new XStream(new Dom4JDriver());
		xstream.setMode(XStream.NO_REFERENCES);
		xstream.alias("xml", clazz);
		return new Gson().toJson((xstream.fromXML(in)));
	}

}
