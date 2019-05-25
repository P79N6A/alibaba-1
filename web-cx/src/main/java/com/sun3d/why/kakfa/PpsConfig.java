package com.sun3d.why.kakfa;

import java.io.IOException;
import java.util.Properties;

public class PpsConfig {
	
	private static Properties properties = new Properties();
	//�����ļ����
	private static final String conifgName = "/pro.properties";
	private static PpsConfig instance;

	/**
	 * ���췽�� ���������ļ�
	 */
	private PpsConfig() {
		try {
			properties.load(getClass().getResourceAsStream(conifgName));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * ��ȡ�������
	 * @return EmpConfig
	 */
	private synchronized static PpsConfig getInstance() {
		if (null == instance) {
			instance = new PpsConfig();
		}
		return instance;
	}
	
	/**
	 * ������ֵ��ȡΪint��
	 * @param str ������
	 * @return
	 */
	public static int getint( String str){
		try {
			if (null == instance) {
				getInstance();
			}
			return Integer.parseInt(properties.getProperty( str ));
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	/**
	 * ������ֵ��ȡΪlong��
	 * @param str ������
	 * @return
	 */
	public static long getlong( String str){
		try {
			if (null == instance) {
				getInstance();
			}
			return Long.parseLong( properties.getProperty( str ) );
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	/**
	 * ������ֵ��ȡΪdouble��
	 * @param str ������
	 * @return
	 */
	public static double getdouble( String str){
		try {
			if (null == instance) {
				getInstance();
			}
			return Double.parseDouble(properties.getProperty( str ));
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	/**
	 * ������ֵ��ȡΪString��
	 * @param str ������
	 * @return
	 */
	public static String getString( String str){
		try {
			if (null == instance) {
				getInstance();
			}
			return properties.getProperty( str );
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * ������ֵ��ȡΪboolean��
	 * @param str ������
	 * @return
	 */
	public static boolean getBoolean( String str){
		try {
			if (null == instance) {
				getInstance();
			}
			return Boolean.parseBoolean( properties.getProperty( str ));
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
