package com.culturecloud.utils;

import java.util.Arrays;

/**
 * ���ֹ�����
 * 
 * @see �����ֵĽ�ȡ��ת������
 * @version 1.0
 * @author gaoyr
 */
public class NumberUtils {
	/**
	 * �������뵽ָ��λ��
	 * 
	 * @param source
	 *            ������
	 * @param decimalDigits
	 *            С��λ��
	 * @return double ��ȡ���
	 */
	public static double round(double source, int decimalDigits) {
		assert decimalDigits >= 0;
		int multiple = (int) Math.pow(ACCURACY_BY_ROUND, decimalDigits);
		return (double) Math.round(source * multiple) / multiple;
	}

	/**
	 * ���ֽ�ת��Ϊ������
	 * 
	 * @param source
	 *            �����ֽ�
	 * @param isFormat
	 *            �Ƿ���и�ʽ�� ��֤ÿ��ת�����Ȼ�᷵��һ����λ�ֽ� ����������������λ
	 * 
	 * @return java.lang.String �����Ʊ��
	 */
	public static String toBinaryString(byte source, boolean isFormat) {
		if (isFormat) {
			String result = Integer.toBinaryString(source);

			if (source < 0) {
				return result.substring(INT_BIT_LENGTH - BYTE_BIT_LENGTH, result.length());
			} else {
				if (result.length() == BYTE_BIT_LENGTH) {
					return result;
				} else {
					char[] chars = new char[BYTE_BIT_LENGTH - result.length()];
					Arrays.fill(chars, '0');

					return new String(chars) + result;
				}
			}
		} else {
			return Integer.toBinaryString(source);
		}
	}

	/**
	 * ������ת��Ϊ����
	 * 
	 * @param number
	 *            ��ת��������
	 * @return java.lang.String ת����ĺ���
	 */
	public static String transformChineseNumber(int number) {
		return transformChineseNumber(new Long(number).longValue(), 0);
	}

	/**
	 * ������ת��Ϊ����
	 * 
	 * @param number
	 *            ��ת��������
	 * @param depth
	 *            ���ֵ�λ(Ϊ0�Ļ�û�е�λ 1Ϊ�� 2Ϊ��)
	 * @return java.lang.String ת����ĺ���
	 */
	public static String transformChineseNumber(long number, int depth) {
		assert depth >= 0;

		String chinese = "";
		String src = String.valueOf(number);

		if (src.endsWith("L") || src.endsWith("l")) {
			src = src.substring(0, src.length() - 1);
		}

		if (src.length() > N_RANGE) {
			chinese = transformChineseNumber(Integer.parseInt(src.substring(0, src.length() - N_RANGE)), depth + 1);
			chinese += transformChineseNumber(Integer.parseInt(src.substring(src.length() - N_RANGE, src.length())), depth - 1);
		} else {
			char prv = 0;
			for (int i = 0; i < src.length(); i++) {
				switch (src.charAt(i)) {
				case '0':
					if (prv != '0') {
						chinese += "��";
					}
					break;
				case '1':
					chinese += "Ҽ";
					break;
				case '2':
					chinese += "��";
					break;
				case '3':
					chinese += "��";
					break;
				case '4':
					chinese += "��";
					break;
				case '5':
					chinese += "��";
					break;
				case '6':
					chinese += "½";
					break;
				case '7':
					chinese += "��";
					break;
				case '8':
					chinese += "��";
					break;
				case '9':
					chinese += "��";
					break;
				}
				prv = src.charAt(i);

				if (prv != '0') {
					switch (src.length() - 1 - i) {
					case N_UNIT_TEN:
						chinese = chinese + "ʰ";
						break;
					case N_UNIT_HUNDRED:
						chinese = chinese + "��";
						break;
					case N_UNIT_THOUSAND:
						chinese = chinese + "Ǫ";
						break;
					}
				}
			}
		}
		while ((chinese.length() > 0) && (chinese.lastIndexOf("��") == chinese.length() - 1)) {
			chinese = chinese.substring(0, chinese.length() - 1);
		}

		switch (depth) {
		case N_UNIT_WAN:
			chinese += "��";
			break;
		case N_UNIT_BILLION:
			chinese += "��";
			break;
		}

		return chinese;
	}

	// ��������

	/** ��������ʱ�õ��ĳ��� */
	private static final int ACCURACY_BY_ROUND = 10;

	/** �ֽ��д��ڵ�λ�� */
	private static final int BYTE_BIT_LENGTH = 8;

	/** �����д��ڵ�λ�� */
	private static final int INT_BIT_LENGTH = 32;

	/** ������䷶Χ */
	private static final int N_RANGE = 4;

	/** ���ֵ�λ����(ʮ) */
	private static final int N_UNIT_TEN = 1;

	/** ���ֵ�λ����(��) */
	private static final int N_UNIT_HUNDRED = 2;

	/** ���ֵ�λ����(ǧ) */
	private static final int N_UNIT_THOUSAND = 3;

	/** ���ֵ�λ����(��) */
	private static final int N_UNIT_WAN = 1;

	/** ���ֵ�λ����(��) */
	private static final int N_UNIT_BILLION = 2;

	// ���ֳ��� ����ħ�����ֵ�Ե�� ͨ����Щ������ϵ�һ�������ǰ�����泣��..
	/** ���ֳ���0 */
	public static final int INT_0 = 0;

	/** ���ֳ���1 */
	public static final int INT_1 = 1;

	/** ���ֳ���2 */
	public static final int INT_2 = 2;

	/** ���ֳ���3 */
	public static final int INT_3 = 3;

	/** ���ֳ���4 */
	public static final int INT_4 = 4;

	/** ���ֳ���5 */
	public static final int INT_5 = 5;

	/** ���ֳ���6 */
	public static final int INT_6 = 6;

	/** ���ֳ���7 */
	public static final int INT_7 = 7;

	/** ���ֳ���8 */
	public static final int INT_8 = 8;

	/** ���ֳ���9 */
	public static final int INT_9 = 9;

	/** ���ֳ���10 */
	public static final int INT_10 = 10;
}
