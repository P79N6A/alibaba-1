package com.culturecloud.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * ƴ��������
 * 
 * @see ���Խ�����ת��Ϊƴ��
 * @version 1.0
 * @author gaoyr
 */
public class PinyinUtils {
	/**
	 * ��õ������ֵ�ASCII
	 * 
	 * @param chinese
	 *            ����
	 * @param charset
	 *            �ַ�
	 * @return java.lang.String ���󷵻ؿ��ַ� ���򷵻�ASCII
	 */
	public static String getChineseAscii(char chinese, String charset) {
		byte[] bytes = StringUtils.getBytes(chinese, charset);

		if (bytes != null && bytes.length == CN_BYTES) {
			return (BYTE_MAX + bytes[0]) + "-" + (BYTE_MAX + bytes[1]);
		} else {
			return null;
		}
	}

	/**
	 * ���Ҷ�Ӧ��ƴ��
	 * 
	 * @param chinese
	 *            ���ҵĺ���
	 * @param charset
	 *            �ַ�
	 * @return java.lang.String ƴ��
	 */
	public static String getPinyinByAscii(char chinese, String charset) {
		String ascii = getChineseAscii(chinese, charset);

		if (ascii != null) {
			return (String) DICT.get(ascii);
		} else {
			return null;
		}
	}

	/** ƴ��������� */
	static final Map<String, String> DICT = new LinkedHashMap<String, String>(20901);

	/** �����ַ�� */
	static final int CN_BYTES = 2;

	/** �ֽ���ֵ���� */
	static final int BYTE_MAX = 256;

	static {
		InputStream in = Thread.currentThread().getContextClassLoader().getResourceAsStream("com/mapbar/mgisx/utils/pinyin.properties");
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new InputStreamReader(in));
			String line = null;
			while ((line = reader.readLine()) != null) {
				DICT.put(line.substring(0, line.indexOf("=")), StringUtils.substring(line, "="));
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
}
