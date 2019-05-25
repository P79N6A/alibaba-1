package com.culturecloud.utils;

import java.security.MessageDigest;



/**
 * ���ܹ�����
 * 
 * @see ���ܹ���
 * @version 1.0
 * @author gaoyr
 */
public class ShaUtils {

	/**
	 * �����ַ�
	 * 
	 * @param source
	 * @return
	 */
	public static String encryptByMD5(String source) {

		return ShaUtils.encryptByMD5(source, null);
	}

	/**
	 * �����ַ�
	 * 
	 * @param source
	 *            ԭʼ����
	 * @param charset
	 *            �ַ����
	 * @return java.lang.String ���ܺ���ַ�
	 */
	public static String encryptByMD5(String source, String charset) {
		try {
			MessageDigest d = MessageDigest.getInstance("MD5");

			if (charset != null)

				d.update(source.getBytes(charset));

			else
				d.update(source.getBytes());

			byte[] enc = d.digest();
			char[] chars = new char[ENCRYPTED_LENGTH];

			int k = 0;
			for (int i = 0; i < enc.length; i++) {
				chars[k++] = HEX_DIGITS[enc[i] >>> H_BIT_LENGTH & HEX_DIGITS.length - 1];
				chars[k++] = HEX_DIGITS[enc[i] & HEX_DIGITS.length - 1];
			}
			return new String(chars);
		} catch (Exception e) {
			//LOGGER.error("�����ַ�ʧ��", e);
			return null;
		}
	}

	/**
	 * �����ֽ�
	 * 
	 * @param source
	 *            ԭʼ����
	 * @return byte[] ���ܺ������
	 */
	public static byte[] encryptByMD5(byte[] source) {
		try {
			MessageDigest d = MessageDigest.getInstance("MD5");
			d.update(source);

			return d.digest(); // MD5 �ļ�������һ�� 128 λ�ĳ�����
		} catch (Exception e) {
			//LOGGER.error("�����ַ�ʧ��", e);
			return null;
		}
	}

	// ��������

	/** ��־���� */
	//public static final Logger LOGGER = LoggerFactory.getLogger(ShaUtils.class);

	/** �������ֽ�ת���� 16 ���Ʊ�ʾ���ַ� */
	public static final char[] HEX_DIGITS = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e',
			'f' };

	/** ���ܺ���ַ��� */
	public static final int ENCRYPTED_LENGTH = 32;

	/** ���ֽ�λ�� */
	public static final int H_BIT_LENGTH = 4;
}
