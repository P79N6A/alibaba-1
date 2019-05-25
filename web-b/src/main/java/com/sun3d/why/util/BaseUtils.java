package com.sun3d.why.util;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.util.Assert;
import org.springframework.web.multipart.MultipartFile;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

/**
 * @Description: 基础工具类
 * @author ChenXinjie
 * @date 2014年7月30日 下午2:06:31
 * 
 */
/**
  * @Description: TODO
  * @author chenxj
  * @date 2014年8月25日 下午2:11:34
  *
  */
public class BaseUtils {

	/**
	 * @Fields WXWSCPROPERTIES : 微信微商城配置文件
	 */
	public static Properties WEIXINPROPERTIES = new Properties();

	/**
	 * @Description: 获取键值
	 * @param @param key
	 * @param @return
	 * @return String
	 * @throws
	 */
	public static String getWeiXinByKey(String key) {
		try {
			return new String(WEIXINPROPERTIES.getProperty(key).getBytes("ISO8859-1"), "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return "";
	}

	/**
	 * @Description: BASE64 解密
	 * @param @param key
	 * @param @return
	 * @param @throws Exception
	 * @return String
	 * @throws
	 */
	public static String decryptBASE64(String key) throws Exception {
		return (new BASE64Decoder()).decodeBuffer(key).toString();
	}

	/**
	 * @Description: BASE64 加密
	 * @param @param key
	 * @param @return
	 * @param @throws Exception
	 * @return String
	 * @throws
	 */
	public static String encryptBASE64(String key) throws Exception {
		return encryptBASE64(key.getBytes());
	}
	
	public static String encryptBASE64(byte[] key) throws Exception {
		return (new BASE64Encoder()).encodeBuffer(key);
	}

	/**
	 * @Description: md5加密
	 * @param @param inputText
	 * @param @return
	 * @return String
	 * @throws
	 */
	public static String md5(String inputText) {
		return encrypt(inputText, "md5");
	}

	/**
	 * @Description: sha-1加密
	 * @param @param inputText
	 * @param @return
	 * @return String
	 * @throws
	 */
	public static String sha(String inputText) {
		return encrypt(inputText, "sha-1");
	}

	/**
	 * @Description: md5或者sha-1加密
	 * @param @param inputText 要加密的内容
	 * @param @param algorithmName 加密算法名称：md5或者sha-1，不区分大小写
	 * @param @return
	 * @return String
	 * @throws
	 */
	private static String encrypt(String inputText, String algorithmName) {
		if (inputText == null || "".equals(inputText.trim())) {
			throw new IllegalArgumentException("请输入要加密的内容");
		}
		if (algorithmName == null || "".equals(algorithmName.trim())) {
			algorithmName = "md5";
		}
		String encryptText = null;
		try {
			MessageDigest m = MessageDigest.getInstance(algorithmName);
			m.update(inputText.getBytes("UTF8"));
			byte s[] = m.digest();
			// m.digest(inputText.getBytes("UTF8"));
			return hex(s);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return encryptText;
	}

	/**
	 * @Description: 返回十六进制字符串
	 * @param @param arr
	 * @param @return
	 * @return String
	 * @throws
	 */
	private static String hex(byte[] arr) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < arr.length; ++i) {
			sb.append(Integer.toHexString((arr[i] & 0xFF) | 0x100).substring(1,
					3));
		}
		return sb.toString();
	}

	/**
	 * @Description: 数组排序（冒泡排序法）
	 * @param @param originalArray
	 * @param @return
	 * @return String[]
	 * @throws
	 */
	public static String[] bubbleSort(String[] array) {
		String temp;
		for (int i = 0; i < array.length; i++)
			for (int j = 0; j < array.length - 1 - i; j++)
				if (array[j + 1].compareTo(array[j]) < 0) {
					temp = array[j];
					array[j] = array[j + 1];
					array[j + 1] = temp;
				}
		return array;
	}

	/**
	 * @Title: list2ResultJson
	 * @Description: list 转换成 ResultJson
	 * @param @param list
	 * @param @param propertyNames
	 * @param @return
	 * @return List<Map<String,Object>>
	 * @throws
	 */
	public static List<Map<String, Object>> list2ResultJson(List<?> list,
			String... propertyNames) {
		List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
		for (Object o : list) {
			Map<String, Object> row = new HashMap<String, Object>();
			for (String propertyName : propertyNames) {
				Object val = getPropertyValueByCascadeName(o, propertyName);
				row.put(propertyName, val == null ? "" : val.toString());
			}
			rows.add(row);
		}
		return rows;
	}

	public static Object getPropertyValueByCascadeName(Object o,
			String cascadeName) {
		Assert.notNull(o);
		Assert.notNull(cascadeName);
		Object propertyValue = o;
		for (String simplePropertyName : cascadeName.split("\\.")) {
			propertyValue = getPropertyValueBySimpleName(propertyValue,
					simplePropertyName);
		}
		return propertyValue;
	}

	public static Object getPropertyValueBySimpleName(Object o,
			String propertyName) {
		try {
			if (o == null) {
				return null;
			}
			PropertyDescriptor[] propertyDescriptors = Introspector
					.getBeanInfo(o.getClass()).getPropertyDescriptors();
			if (propertyDescriptors == null) {
				return null;
			}
			for (PropertyDescriptor descriptor : propertyDescriptors) {
				if (!propertyName.equals(descriptor.getName())
						|| descriptor.getReadMethod() == null) {
					continue;
				}
				Method method = descriptor.getReadMethod();
				return method.invoke(o);
			}

		} catch (IntrospectionException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	  * @Description: 去除
	  * @param @param str
	  * @param @return  
	  * @return String  
	  * @throws
	  */
	public static String replaceBlank(String str) {
        String dest = "";
        if (str!=null) {
            Pattern p = Pattern.compile("\\s*|\t|\r|\n");
            Matcher m = p.matcher(str);
            dest = m.replaceAll("");
        }
        return dest;
    }
	
	/**
	  * @Description: 保存图片
	  * @param @param path 保存路径
	  * @param @param file 图片文件
	  * @param @return 图片名称
	  * @return String  
	  * @throws
	  */
	public static String saveImgs(String path, MultipartFile file) {
		try {
			if (!file.isEmpty()) {
				File pathFile = new File(path);
				if (!pathFile.exists())
					pathFile.mkdir();
				
				// TODO 生成文件名称
				String fileName = UUID.randomUUID().toString() + ".jpg";
				StringBuffer newPath = new StringBuffer();
				newPath.append(pathFile);
				newPath.append("/");
				newPath.append(fileName);
				File newFile = new File(newPath.toString()); 
				file.transferTo(newFile);
				return fileName;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * @throws Exception 
	 * @Description: main
	 * @param @param args
	 * @return void
	 * @throws
	 */
	public static void main(String[] args) throws Exception {
		System.out.println(replaceBlank(encryptBASE64("{\"areaCode\":\"0512\",\"olNbr\":\"null\",\"no\":\"null\",\"nbrNo\":\"null\",\"cardNo\":\"510623197701214511\",\"isNo\":2}")));
	}
}
