package com.culturecloud.utils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Collection;
import java.util.Iterator;
import java.util.UUID;



/**
 * �ַ�����
 * 
 * @see �ṩString�ĸ��ֲ���
 * @version 1.0
 * @author gaoyr
 */
public class StringUtils {

	/**
	 * ���UUID
	 * 
	 * @return java.lang.String uuid
	 */
	public static String getUUID() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}

	/**
	 * �����ַ�
	 * 
	 * @param strs
	 *            �����ӵ��ַ�
	 * @return java.lang.String �Ѿ����ӵ��ַ�
	 */
	public static String concat(Object... strs) {
		assert strs != null;

		StringBuilder builder = new StringBuilder();

		for (Object str : strs) {
			builder.append(str == null ? "null" : str.toString());
		}

		return builder.toString();
	}

	/**
	 * �����ַ�
	 * 
	 * @param sep
	 *            �ָ���
	 * @param strs
	 *            �����ӵ��ַ�
	 * @return java.lang.String ���Ӻõ��ַ�
	 */
	public static String concat(char sep, Object... strs) {
		assert strs != null;

		StringBuilder builder = new StringBuilder();

		for (int i = 0; i < strs.length; i++) {
			if (i > 0) {
				builder.append(sep);
			}
			builder.append(strs[i]);
		}

		return builder.toString();
	}

	/**
	 * �����ַ�
	 * 
	 * @param <T>
	 *            ��������
	 * @param strs
	 *            �����ӵ��ַ�
	 * @return java.lang.String �Ѿ����ӵ��ַ�
	 */
	public static <T extends Collection<?>> String concat(T strs) {
		assert strs != null;

		StringBuilder builder = new StringBuilder();

		for (Iterator<?> it = strs.iterator(); it.hasNext();) {
			builder.append(it.next());
		}

		return builder.toString();
	}

	/**
	 * �����ַ�
	 * 
	 * @param <T>
	 *            ��������
	 * @param sep
	 *            �ָ���
	 * @param strs
	 *            �����ӵ��ַ�
	 * @return java.lang.String �Ѿ����ӵ��ַ�
	 */
	public static <T extends Collection<?>> String concat(char sep, T strs) {
		assert strs != null;

		StringBuilder builder = new StringBuilder();

		int i = 0;
		for (Iterator<?> it = strs.iterator(); it.hasNext(); i++) {
			if (i > 0) {
				builder.append(sep);
			}
			builder.append(it.next());
		}

		return builder.toString();
	}

	/**
	 * �ж��Ƿ�Ϊ���ַ�
	 * 
	 * @param target
	 *            ���жϵ��ַ�
	 * @return boolean �жϽ��
	 */
	public static boolean isBlank(String target) {
		return target == null || target.trim().equals("");
	}

	/**
	 * �ж��Ƿ�Ϊ���ַ�
	 * 
	 * @param targets
	 *            ���жϵ��ַ�
	 * @return boolean �жϽ��
	 */
	public static boolean isBlank(String... targets) {
		int i = 0;

		for (String target : targets) {
			i = target == null || target.trim().equals("") ? i + 1 : i;
		}
		return i > 0;
	}

	/**
	 * �鿴�ַ�ĳ��� ����ַ�Ϊ���򷵻�-1 ���򷵻ؽ�ȥ�ַ����߿ո�ĳ���
	 * 
	 * @param str
	 *            �ַ�
	 * @return �ַ���
	 * 
	 */
	public static int length(String str) {
		return str == null ? -1 : str.trim().length();
	}

	/**
	 * ���һ���ַ����е��ֽڱ�ʾ
	 * 
	 * @param sequence
	 *            �ַ�����
	 * @param charset
	 *            �ַ�
	 * @return byte[] �ֽ�����
	 */
	public static byte[] getBytes(CharSequence sequence, String charset) {
		try {
			return sequence.toString().getBytes(charset);
		} catch (UnsupportedEncodingException e) {
		//	LOGGER.error("�ַ�����ת��Ϊ�ֽ�ʧ��", e);
			return null;
		}
	}

	/**
	 * ���һ���ַ����е��ֽڱ�ʾ
	 * 
	 * @param c
	 *            �����ַ�
	 * @param charset
	 *            �ַ�
	 * @return byte[] �ֽ�����
	 */
	public static byte[] getBytes(char c, String charset) {
		try {
			return String.valueOf(c).getBytes(charset);
		} catch (UnsupportedEncodingException e) {
			//LOGGER.error("�ַ�����ת��Ϊ�ֽ�ʧ��", e);
			return null;
		}
	}

	/**
	 * �鿴�ַ���ֽڳ��� ����ַ�Ϊ���򷵻�-1 ���򷵻ؽ�ȥ�ַ����߿ո�ĳ���
	 * 
	 * @param str
	 *            �ַ�
	 * @return �ַ���
	 */
	public static int getBytesLength(String str) {
		return str == null ? -1 : str.trim().getBytes().length;
	}

	/**
	 * ��ȡ�ַ�(����ṩ���ַ��ȡλ��)
	 * 
	 * @param target
	 *            ԭʼ�ַ�
	 * @param start
	 *            ��ʼ���ַ�
	 * @return java.lang.String ��ȡ����ַ�
	 */
	public static String substring(String target, String start) {
		assert !isBlank(target) && !isBlank(start);

		return substring(target, start, null);
	}

	/**
	 * ��ȡ�ַ�(����ṩ���ַ��ȡλ��)
	 * 
	 * @param target
	 *            ԭʼ�ַ�
	 * @param start
	 *            ��ʼ���ַ�
	 * @param end
	 *            ������ַ�
	 * @return java.lang.String ��ȡ����ַ�
	 */
	public static String substring(String target, String start, String end) {
		assert target != null && start != null;
		if (end == null) {
			return substring(target, target.indexOf(start) + start.length(), target.length());
		} else {
			return substring(target, target.indexOf(start) + start.length(), target.indexOf(end));
		}
	}

	/**
	 * ��ȡ�ַ�
	 * 
	 * @param target
	 *            ԭʼ�ַ�
	 * @param startIndex
	 *            ��ʼ����
	 * @param endIndex
	 *            ��������
	 * @return java.lang.String ��ȡ����ַ�
	 */
	public static String substring(String target, int startIndex, int endIndex) {
		return target.substring(startIndex, endIndex);
	}

	/**
	 * �����ַ���߿ո�
	 * 
	 * @param target
	 *            �ַ�
	 * @return java.lang.String �����Ľ��
	 */
	public static String trimLeft(String target) {
		return trimLeft(target, ' ');
	}

	/**
	 * �����ַ����ָ���ַ�
	 * 
	 * 
	 * @param target
	 *            �ַ�
	 * @param ignore
	 *            �����ӵ��ַ�
	 * @return java.lang.String �����Ľ��
	 */
	public static String trimLeft(String target, char ignore) {
		int len = target.length();
		int st = 0;
		int off = 0;
		char[] val = new char[target.length()];

		target.getChars(0, target.length(), val, 0);

		while ((st < len) && (val[off + st] == ignore)) {
			st++;
		}

		return ((st > 0) || (len < target.length())) ? target.substring(st, len) : target;
	}

	/**
	 * �����ַ��б�Ե��ָ���ַ�
	 * 
	 * 
	 * @param target
	 *            �ַ�
	 * @param ignore
	 *            �����ӵ��ַ�
	 * @return java.lang.String �����Ľ��
	 */
	public static String trim(String target, char ignore) {
		int len = target.length();
		int st = 0;
		int off = 0;
		char[] val = new char[target.length()];

		target.getChars(0, target.length(), val, 0);

		while ((st < len) && (val[off + st] == ignore)) {
			st++;
		}
		while ((st < len) && (val[off + len - 1] == ignore)) {
			len--;
		}
		return ((st > 0) || (len < target.length())) ? target.substring(st, len) : target;
	}

	/**
	 * �����ַ��ұ߿ո�
	 * 
	 * @param target
	 *            �ַ�
	 * @return java.lang.String �����Ľ��
	 */
	public static String trimRight(String target) {
		return trimRight(target, ' ');
	}

	/**
	 * �����ַ��ұ�ָ���ַ�
	 * 
	 * @param target
	 *            �ַ�
	 * @param ignore
	 *            �����ӵ��ַ�
	 * @return java.lang.String �����Ľ��
	 */
	public static String trimRight(String target, char ignore) {
		int len = target.length();
		int st = 0;
		int off = 0;
		char[] val = new char[target.length()];

		target.getChars(0, target.length(), val, 0);

		while ((st < len) && (val[off + len - 1] == ignore)) {
			len--;
		}
		return ((st > 0) || (len < target.length())) ? target.substring(st, len) : target;
	}

	/**
	 * �ж�ָ���ַ��Ƿ�Ϊ����
	 * 
	 * @param target
	 *            �ַ�
	 * @return boolean �жϽ��
	 */
	public static boolean isChineseCharacter(String target) {
		return target.length() != target.getBytes().length;
	}

	/**
	 * �� String ת��Ϊ application/x-www-form-urlencoded MIME
	 * 
	 * @param target
	 *            ��������ַ�
	 * @param charset
	 *            �ַ���ַ�
	 * @return java.lang.String �������ַ�
	 */
	public static String encode(String target, String charset) {
		try {
			return URLEncoder.encode(target, charset);
		} catch (UnsupportedEncodingException e) {
			//LOGGER.error("�� String ת��Ϊ application/x-www-form-urlencoded MIMEʧ��", e);
			return null;
		}
	}

	/**
	 * �� application/x-www-form-urlencoded MIME ת��Ϊ String
	 * 
	 * @param target
	 *            ��������ַ�
	 * @param charset
	 *            �ַ���ַ�
	 * @return java.lang.String �������ַ�
	 */
	public static String decode(String target, String charset) {
		try {
			return URLDecoder.decode(target, charset);
		} catch (UnsupportedEncodingException e) {
			//LOGGER.error("�� application/x-www-form-urlencoded MIME ת��Ϊ Stringʧ��", e);
			return null;
		}
	}

	/**
	 * �� String ת��Ϊ application/x-www-form-urlencoded MIME(�Զ��� ����)
	 * 
	 * @param target
	 *            ��������ַ�
	 * @param charset
	 *            �ַ���ַ�
	 * @return java.lang.String �������ַ�
	 * @throws UnsupportedEncodingException
	 *             ���ַ�ʧ��
	 */
	public static String customEncode(String target, String charset) throws UnsupportedEncodingException {
		assert !isBlank(target) && !isBlank(charset);

		StringBuilder mergrd = new StringBuilder();
		StringBuilder encoded = new StringBuilder();

		byte[] bytes = target.getBytes(charset);

		for (int i = 0; i < bytes.length; i++) {
			mergrd.append(NumberUtils.toBinaryString(bytes[i], true));
		}

		int groupCount = mergrd.length() / FIVE_BIT;// ��5��bitΪ��λ�������ֶܷ�����
		int lastCount = mergrd.length() % FIVE_BIT;// �������µ�λ��

		if (lastCount > 0) {// ���������� ������һ����
			groupCount += 1;
		}

		int loopNum = groupCount * FIVE_BIT;// ѭ�����������

		for (int i = 0; i < loopNum; i += FIVE_BIT) {// ÿ�ε���5λ����ȡ
			int end = i + FIVE_BIT;// �����
			boolean flag = false;// ����Ƿ����������һ��

			if (end > mergrd.length()) {
				end = (i + lastCount);
				flag = true;
			}

			int intFiveBit = Integer.parseInt(mergrd.substring(i, end), BINARY);// ��ȡ��Ӷ�����תΪʮ����

			if (flag) {
				intFiveBit <<= (FIVE_BIT - lastCount);
			}

			encoded.append(CODEC_TABLE[intFiveBit]);// ���ø�ʮ��������Ϊ���������ȡ��Ӧ���ַ�׷�ӵ�encoded
		}

		return encoded.toString();
	}

	/**
	 * �� application/x-www-form-urlencoded MIME ת��Ϊ String(�Զ��� ����)
	 * 
	 * @param target
	 *            ��������ַ�
	 * @param charset
	 *            �ַ���ַ�
	 * @return java.lang.String �������ַ�
	 * @throws UnsupportedEncodingException
	 *             ���ָ���ַ����´����ַ�ʧ��
	 */
	public static String customDecode(String target, String charset) throws UnsupportedEncodingException {
		assert !isBlank(target) && !isBlank(charset);

		StringBuilder binarys = new StringBuilder();

		int start = EIGHT_BIT - FIVE_BIT;
		for (int i = 0; i < target.length(); i++) {
			int index = -1;// ��������ȡ��Ӧ������

			for (int x = 0; x < CODEC_TABLE.length; x++) {
				if (target.charAt(i) == CODEC_TABLE[x]) {
					index = x;
					break;
				}
			}
			binarys.append(NumberUtils.toBinaryString((byte) index, true).substring(start));// ȥ�������0����׷�ӵ�binarys
		}

		byte[] bytes = new byte[binarys.length() / EIGHT_BIT];// ��8��bit���,ʣ�µ������ӵ�.�ӵ�����������(����/����)�ķָ�ʱ��,�ڷ�ʣ������ĺ��油��0

		for (int i = 0, j = 0; i < bytes.length; i++) {
			j += EIGHT_BIT;
			bytes[i] = Integer.valueOf(binarys.substring(j - EIGHT_BIT, j), BINARY).byteValue();
		}

		return new String(bytes, charset);
	}

	/**
	 * ת���ַ�
	 * 
	 * @param target
	 *            ��ת�����ַ�
	 * @param charset
	 *            ת������ַ�
	 * @return java.lang.String ת������ַ�
	 */
	public static String changeStringCharset(String target, String charset) {
		try {
			return new String(target.getBytes(charset), charset);
		} catch (UnsupportedEncodingException e) {
		//	LOGGER.error("ת���ַ�ʧ��", e);
			return null;
		}
	}

	/**
	 * ��ָ�����ַ���뵽ԭʼ�ַ���
	 * 
	 * @param target
	 *            ԭʼ�ַ�
	 * @param toAdd
	 *            ������ӵ��ַ�
	 * @param index
	 *            ��ӵ���λ��
	 * @return java.lang.String �����Ӻ���ַ�
	 */
	public static String insertStr(String target, String toAdd, int index) {
		assert target != null;
		assert toAdd != null;
		assert index >= 0 && index < target.length();

		char[] chars = new char[target.length() + toAdd.length()];

		toAdd.getChars(0, toAdd.length(), chars, index);
		target.getChars(0, index, chars, 0);
		target.getChars(index, target.length(), chars, index + toAdd.length());

		return new String(chars);
	}

	// ��������
	/** ��־���� */
	//public static final Logger LOGGER = LoggerFactory.getLogger(StringUtils.class);

	// URLEncode������ start
	/** ��� */
	private static final char[] CODEC_TABLE = new char[] { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
			'y', 'z', '2', '3', '4', '5', '6', '7' };

	/** ��ʾ5bit���ֽ� */
	public static final int FIVE_BIT = 5;

	/** ��ʾ8bit���ֽ� */
	public static final int EIGHT_BIT = 8;

	/** ��ʾ������ */
	public static final int BINARY = 2;

	// URLEncode������ end
}
