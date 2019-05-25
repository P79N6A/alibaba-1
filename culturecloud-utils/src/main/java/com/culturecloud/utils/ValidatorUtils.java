package com.culturecloud.utils;

import java.util.regex.Pattern;

/**
 * У�鹤��
 * 
 * @see У�鲻ͬ������ݵĸ�ʽ�Ƿ�Ϸ�
 * @version 1.0
 * @author gaoyr
 */
public class ValidatorUtils {
	/**
	 * �Ƿ�Ϊ����
	 * 
	 * @param str
	 *            ����֤���ַ�
	 * @return boolean ��֤���
	 */
	public static boolean isInt(String str) {
		return (!StringUtils.isBlank(str) && Pattern.matches(CHECK_INT_R, str));
	}

	/**
	 * �Ƿ�Ϊ����
	 * 
	 * @param str
	 *            ����֤���ַ�
	 * @return boolean ��֤���
	 */
	public static boolean isNumber(String str) {
		return (!StringUtils.isBlank(str) && Pattern.matches(CHECK_NUMBER_R, str));
	}

	/**
	 * �Ƿ�ΪIP
	 * 
	 * @param str
	 *            ����֤���ַ�
	 * @return boolean ��֤���
	 */
	public static boolean isIP(String str) {
		return (!StringUtils.isBlank(str) && Pattern.matches(CHECK_IP_R, str));
	}

	/**
	 * �Ƿ��ڶ˿ںŷ�Χ��
	 * 
	 * @param port
	 *            �˿ں�
	 * @return boolean ��֤���
	 */
	public static boolean isPort(Integer port) {
		return port != null && port >= PORT_MIN && port <= PORT_MAX;
	}

	/**
	 * �Ƿ�Ϊ�ֻ��
	 * 
	 * @param number
	 *            �ֻ��
	 * @return boolean ��֤���
	 */
	public static boolean isMobilePhoneNumber(String number) {
		return (!StringUtils.isBlank(number) && Pattern.matches(CHECK_MOBILE_NUMBER_R, number));
	}

	/**
	 * �Ƿ��ǺϷ������֤����
	 * 
	 * @param cardNo
	 *            ֤������
	 * @return boolean ��֤���
	 */
	public static boolean isIDCard(String cardNo) {
		if (StringUtils.isBlank(cardNo) || StringUtils.length(cardNo) != CARD_NO_LENGTH
				|| DateUtils.DateFormatUnit.SHORT_DATE.getDateByStr(StringUtils.substring(cardNo, BIRTHDAY_CODE_START, BIRTHDAY_CODE_END)) == null) {
			return false;
		} else {
			int sum = 0;
			for (int i = 0; i < VERIFY_CODE_INDEX; i++) {
				sum += MASK[i] * (cardNo.charAt(i) - '0');
			}
			return VERIFY[sum % VERIFY.length] == cardNo.charAt(VERIFY_CODE_INDEX);
		}
	}

	/**
	 * �Ƿ�Ϊ����
	 * 
	 * @param str
	 *            ����֤���ַ�
	 * @return boolean ��֤���
	 */
	public static boolean isEmail(String str) {
		return (!StringUtils.isBlank(str) && Pattern.matches(CHECK_EMAIL_R, str));
	}

	/** �����Ƿ�Ϊ��������� */
	public static final String CHECK_INT_R = "^(\\-?[1-9]\\d*)|[0]$";

	/** �����Ƿ�Ϊ���ֵ����� */
	public static final String CHECK_NUMBER_R = "^(0(\\.0+)?|[-]?0\\.\\d*[1-9]\\d*|[-]?([1-9]\\d*)?(\\.\\d+)?)$";

	/** У���Ƿ�ΪIP������ */
	public static final String CHECK_IP_R = "^(((2([0-4]\\d|5[0-5]))|(1?\\d{1,2}))\\.){3}((2([0-4]\\d|5[0-5]))|(1?\\d{1,2}))$";

	/** �����Ƿ�Ϊ��������� */
	public static final String CHECK_EMAIL_R = "^(\\w|\\_|\\-|\\.)+\\@(((\\w|\\-|)+)|(((2([0-4]\\d|5[0-5]))|(1?\\d{1,2}))\\.){3}((2([0-4]\\d|5[0-5]))|(1?\\d{1,2})))\\.(com|cn|org|net|gov|edu)$";

	/** �����Ƿ�Ϊ�ֻ�ŵ����� */
	public static final String CHECK_MOBILE_NUMBER_R = "^1[358]{1}\\d{9}$";

	// �˿���֤��������start
	/** ���˿ں� */
	public static final int PORT_MAX = 65535;

	/** ��С�˿ں� */
	public static final int PORT_MIN = 0;
	// �˿���֤��������end
	
	// ���֤��֤�������� start
	/** ���� */
	public static final int[] MASK = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1 };

	/** ��֤�� */
	public static final char[] VERIFY = { '1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2' };

	/** ���ų��� */
	public static final int CARD_NO_LENGTH = 18;

	/** ��֤��λ�� */
	public static final int VERIFY_CODE_INDEX = CARD_NO_LENGTH - 1;

	/** �����볤�� */
	public static final int BIRTHDAY_CODE_LENGTH = 8;

	/** �����뿪ʼλ�� */
	public static final int BIRTHDAY_CODE_START = 6;

	/** ���������λ�� */
	public static final int BIRTHDAY_CODE_END = BIRTHDAY_CODE_START + BIRTHDAY_CODE_LENGTH;
	// ���֤��֤�������� end
}
