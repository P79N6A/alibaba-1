package com.sun3d.why.util;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * properties配置文件读取工具类
 * @author liaofy
 *
 */
public class PropertiesReadUtils {
	private static final Logger logger = LogManager.getLogger(PropertiesReadUtils.class);

    private static volatile InputStream inputStream = null;

    private static Properties prop = null;
    
    private static  PropertiesReadUtils read = new PropertiesReadUtils();

    private PropertiesReadUtils() {

    }

    public static PropertiesReadUtils getInstance(){
    	if (inputStream == null) {
    		synchronized (read) {
    			if (inputStream == null) {
	    			inputStream = read.getClass().getResourceAsStream("/pro.properties");
	    	        try {
	    	            logger.info("开始加载properties文件");
	    	            prop = new Properties();
	    	            prop.load(inputStream);
	    	            logger.info("properties文件加载结束！");
	    	        } catch (FileNotFoundException e) {
	    	            logger.error("Properties加载异常！",e);
	    	        } catch (IOException e) {
	    	            logger.error("Properties加载异常！",e);
	    	        }
    			}
			}
	        
    	}
        return read;
    }

    public String getPropValueByKey(String key,String defaultValue) {
        logger.info("根据key获取properties value , key=" + key + "  defaultValue" + defaultValue);
        return prop.getProperty(key, defaultValue);
    }
    public String getPropValueByKey(String key) {
        logger.info("根据key获取properties value , key=" + key);
        return prop.getProperty(key);
    }

    /**
     * 测试工具的用法
     * @param args
     */
    public static void main(String[] args) {
    	PropertiesReadUtils readTest = PropertiesReadUtils.getInstance();
        //无默认值的情况
        String value = readTest.getPropValueByKey("sign_in_task_on_time");
        //有默认值的情况
        String value2 = readTest.getPropValueByKey("test_key", "这是默认值");
        System.out.println("读取的值 value=" + value + " value2 = " + value2);
    }
}
