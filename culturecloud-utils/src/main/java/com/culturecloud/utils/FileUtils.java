package com.culturecloud.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URL;
import java.nio.channels.FileChannel;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;


/**
 * �ļ�������
 * 
 * @see �ṩ�ļ�����ɾ�Ĳ��Լ�����Դ�ļ��ķ���<br/>
 *      �������з������ļ�·��ʹ�÷�ʽǿ��:<br/>
 *      ����Ǵ���Ŀ�е�classesĿ¼�в��� ���ļ�·���ĵ�һλӦ���� '!'
 *      �������classes�µ�example���е�1.properties ����!examples/1.properties Ҳ��������·��
 *      
 * @version 1.0
 * @author zhangchenxi
 */
public class FileUtils {

	/**
	 * ����ָ����properties�ļ�
	 * 
	 * @see ����ָ����properties�ļ�
	 * @param path
	 *            �ļ�����·��
	 * @return java.util.Properties ��Դ��Ϣ
	 */
	public static Properties load(String path) {
		assert path != null && !path.trim().equals("");

		Properties properties = new Properties();
		FileInputStream fin = null;
		path = getAbsolutePath(path);

		try {
			fin = new FileInputStream(path);
			properties.load(fin);

			return properties;
		} catch (IOException e) {
			//LOGGER.error("����properties�ļ�ʧ��", e);
			return null;
		} finally {
			try {
				if (fin != null) {
					fin.close();
				}
			} catch (IOException e) {
				//LOGGER.error("�ر�������ʧ��", e);
			}
		}
	}

	/**
	 * �����ļ�
	 * 
	 * @param from
	 *            Դ�ļ�
	 * @param to
	 *            ������ַ
	 * @return boolean �����Ƿ�ɹ�
	 */
	public static boolean copy(String from, String to) {
		assert from != null && !from.trim().equals("") && to != null && !to.trim().equals("");

		from = getAbsolutePath(from);
		to = getAbsolutePath(to);

		if (!isExists(from)) {
			return false;
		} else {
			FileChannel base = null;
			FileChannel copyto = null;
			try {
				base = new FileInputStream(from).getChannel();
				copyto = new FileOutputStream(to).getChannel();

				copyto.transferFrom(base, 0, base.size());

				base.close();
				copyto.close();
			} catch (IOException e) {
				//LOGGER.error("�����ļ�ʧ��", e);
				return false;
			} finally {
				if (base != null) {
					try {
						base.close();
					} catch (IOException e) {
						//LOGGER.error("�ر�������ʧ��", e);
					}
				}

				if (copyto != null) {
					try {
						copyto.close();
					} catch (IOException e) {
						//LOGGER.error("�ر������ʧ��", e);
					}
				}
			}
			return true;
		}
	}

	/**
	 * ����Ŀ¼
	 * 
	 * @param from
	 *            ԴĿ¼
	 * @param to
	 *            Ŀ��Ŀ¼
	 * @return boolean �����Ƿ�ɹ�
	 */
	public static boolean copyDir(String from, String to) {
		assert from != null && !from.trim().equals("") && to != null && !to.trim().equals("");

		from = getAbsolutePath(from);
		to = getAbsolutePath(to);

		if (!to.endsWith("/")) {
			to += "/";
		}

		if (!isExists(from)) {
			return false;
		} else {
			mkdir(to);
			File base = new File(from);

			if (base.isDirectory()) {
				File[] files = base.listFiles();
				for (File file : files) {
					if (file.isDirectory()) {
						copyDir(file.getAbsolutePath(), to + file.getName());
					} else {
						copy(file.getAbsolutePath(), to + file.getName());
					}
				}
				return true;
			} else {
				return copy(from, to);
			}
		}
	}

	/**
	 * ���ļ��ƶ���ָ��λ��(����renameToʵ�� ����ʹ��)
	 * 
	 * @param from
	 *            ԴĿ¼
	 * @param to
	 *            Ŀ��Ŀ¼
	 * @return boolean �ƶ��Ƿ�ɹ�
	 */
	public static boolean move(String from, String to) {
		assert from != null && !from.trim().equals("") && to != null && !to.trim().equals("");

		return copyDir(from, to) && delete(from);
	}

	/**
	 * ���ַ�����д��ָ���ļ���
	 * 
	 * @param sequence
	 *            �ַ�����
	 * @param to
	 *            ָ���ļ�
	 * @return boolean �Ƿ�����ɹ�
	 */
	public static boolean write(CharSequence sequence, String to) {
		return write(sequence, to, false);
	}

	/**
	 * ���ַ�����д��ָ���ļ���
	 * 
	 * @param sequence
	 *            �ַ�����
	 * @param to
	 *            ָ���ļ�
	 * @param append
	 *            �Ƿ�׷������
	 * @return boolean �Ƿ�����ɹ�
	 */
	public static boolean write(CharSequence sequence, String to, boolean append) {
		assert sequence != null && !sequence.toString().trim().equals("") && to != null && !to.trim().equals("");

		to = getAbsolutePath(to);
		BufferedWriter writer = null;
		try {
			writer = new BufferedWriter(new FileWriter(to, append));
			writer.write(sequence.toString());
			writer.flush();

			return true;
		} catch (Exception e) {
			//LOGGER.error("�ַ��������ʧ��", e);
			return false;
		} finally {
			if (writer != null) {
				try {
					writer.close();
				} catch (IOException e) {
					//LOGGER.error("�ر������ʧ��", e);
				}
			}
		}
	}

	/**
	 * ���ַ����м���д��ָ���ļ���
	 * 
	 * @param <T>
	 *            �κμ̳�java.util.Collection�������
	 * 
	 * @param sequences
	 *            �ַ����м���
	 * @param to
	 *            ָ���ļ�
	 * @return boolean �Ƿ�����ɹ�
	 */
	public static <T extends Collection<? extends CharSequence>> boolean write(T sequences, String to) {
		return write(sequences, to, false);
	}

	/**
	 * ���ַ����м���д��ָ���ļ���
	 * 
	 * @param <T>
	 *            �κμ̳�java.util.Collection�������
	 * 
	 * @param sequences
	 *            �ַ����м���
	 * @param to
	 *            ָ���ļ�
	 * @param append
	 *            �Ƿ�׷������
	 * @return boolean �Ƿ�����ɹ�
	 */
	public static <T extends Collection<? extends CharSequence>> boolean write(T sequences, String to, boolean append) {
		assert sequences != null;

		to = getAbsolutePath(to);
		BufferedWriter writer = null;

		try {
			writer = new BufferedWriter(new FileWriter(to, append));
			for (CharSequence sequence : sequences) {
				writer.write(sequence.toString());
				writer.write("\r\n");
			}
			writer.flush();
			return true;
		} catch (Exception e) {
			//LOGGER.error("�ַ��������ʧ��", e);
			return false;
		} finally {
			if (writer != null) {
				try {
					writer.close();
				} catch (IOException e) {
					//LOGGER.error("�ر������ʧ��", e);
				}
			}
		}
	}

	/**
	 * ��ȡָ���ļ��е��ֽ� ����޷��ҵ�ָ���ļ��򷵻�null
	 * 
	 * @param from
	 *            ָ���ļ�
	 * @return java.io.ByteArrayOutputStream Java�ڴ������
	 */
	public static ByteArrayOutputStream readBytes(String from) {
		assert from != null && !from.trim().equals("");

		from = getAbsolutePath(from);
		if (isExists(from)) {
			FileInputStream base = null;
			ByteArrayOutputStream out = null;

			try {
				base = new FileInputStream(from);
				out = new ByteArrayOutputStream();

				byte[] buffer = new byte[BUFFER_SIZE];
				int count = 0;

				while ((count = base.read(buffer)) != -1) {
					out.write(buffer, 0, count);
				}

				base.close();

				return out;
			} catch (IOException e) {
				//LOGGER.error("���ֽ����ж�ȡ����ʧ��", e);
				return null;
			} finally {
				if (base != null) {
					try {
						base.close();
					} catch (IOException e) {
						//LOGGER.error("�ر�������ʧ��", e);
					}
				}
			}
		} else {
			return null;
		}
	}

	/**
	 * ��ȡָ���ļ��е��ַ� ����޷��ҵ�ָ���ļ��򷵻�null
	 * 
	 * @param from
	 *            ָ���ļ�
	 * @return java.lang.String �ļ��ַ�
	 */
	public static String readString(String from) {
		assert from != null && !from.trim().equals("");

		from = getAbsolutePath(from);

		if (isExists(from)) {
			BufferedReader reader = null;
			StringBuilder builder = null;

			try {
				reader = new BufferedReader(new FileReader(from));
				builder = new StringBuilder();

				String line = null;
				boolean isStart = true;
				while ((line = reader.readLine()) != null) {
					if (!isStart) {
						builder.append("\r\n");
					} else {
						isStart = false;
					}
					builder.append(line);
				}

				return builder.toString();
			} catch (IOException e) {
			//	LOGGER.error("���ַ����ж�ȡ����ʧ��", e);
				return null;
			} finally {
				if (reader != null) {
					try {
						reader.close();
					} catch (IOException e) {
					//	LOGGER.error("�ر�������ʧ��", e);
					}
				}
			}
		} else {
			return null;
		}
	}

	/**
	 * ��ȡָ���ļ��е��ַ� ����޷��ҵ�ָ���ļ��򷵻�null
	 * 
	 * @param from
	 *            ָ���ļ�
	 * @param checker
	 *            �������У����
	 * @return java.lang.String �ļ��ַ�
	 */
	public static List<String> readString(String from, LineChecker checker) {
		assert from != null && !from.trim().equals("");

		from = getAbsolutePath(from);
		if (isExists(from)) {
			BufferedReader reader = null;
			List<String> result = null;

			try {
				reader = new BufferedReader(new FileReader(from));
				result = new LinkedList<String>();

				String line = null;

				if (checker == null) {
					while ((line = reader.readLine()) != null) {
						result.add(line);
					}
				} else {
					while ((line = reader.readLine()) != null) {
						if (checker.check(line)) {
							result.add(checker.format(line));
						}
					}
				}

				return result;
			} catch (IOException e) {
				//LOGGER.error("���ַ����ж�ȡ����ʧ��", e);
				return null;
			} finally {
				if (reader != null) {
					try {
						reader.close();
					} catch (IOException e) {
						//LOGGER.error("�ر�������ʧ��", e);
					}
				}
			}
		} else {
			return null;
		}
	}

	/**
	 * ����Ŀ¼
	 * 
	 * @param path
	 *            ָ��Ŀ¼
	 * @return boolean ����Ŀ¼�Ƿ�ɹ�
	 */
	public static boolean mkdir(String path) {
		assert path != null && !path.trim().equals("");

		return new File(getAbsolutePath(path)).mkdirs();
	}

	/**
	 * ɾ��ָ���ļ�
	 * 
	 * @param path
	 *            ·��
	 * @return �Ƿ�ɾ��
	 */
	public static boolean delete(String path) {
		if (isExists(path)) {
			File toDel = new File(getAbsolutePath(path));
			if (toDel.isDirectory()) {
				File[] files = toDel.listFiles();
				for (File f : files) {
					delete(f.getAbsolutePath());
				}
			}
			return toDel.delete();
		} else {
			return false;
		}
	}

	/**
	 * �ж�ָ���ļ��Ƿ����
	 * 
	 * @param path
	 *            �ļ�����·��
	 * 
	 * @return boolean �жϽ��
	 */
	public static boolean isExists(String path) {
		assert path != null && !path.trim().equals("");

		return new File(getAbsolutePath(path)).exists();
	}

	/**
	 * ��þ��·��
	 * 
	 * @param path
	 *            ·��
	 * @return ���·��
	 */
	public static String getAbsolutePath(String path) {
		if (path.startsWith("!")) {
			URL u = Thread.currentThread().getContextClassLoader().getResource(EMPTY_STR);
			if (u != null) {
				path = u.getPath() + path.substring(1);
			} else {
				return null;
			}
		}

		return path;
	}

	/**
	 * ����ļ���׺���
	 * 
	 * @param file
	 *            ָ���ļ�
	 * @return {@link String}
	 */
	public static String getFileSuffix(File file) {
		String fileName = file.getAbsolutePath();
		int lastIndex = fileName.lastIndexOf(".");

		if (lastIndex == -1) {
			return "";
		} else {
			return fileName.substring(lastIndex + 1);
		}
	}

	/**
	 * �Զ�����ַ�����
	 * 
	 * @author zhaojp
	 */
	public abstract static class LineChecker {
		/**
		 * ���ָ�������Ƿ���Ҫ�� �����Ҫ�������Ϊ���� ���������ӵ�����б���
		 * 
		 * @param line
		 *            ����
		 * @return boolean У����
		 */
		public boolean check(String line) {
			return true;
		}

		/**
		 * ��ԭʼ���ݴ���
		 * 
		 * @param line
		 *            ����
		 * @return java.lang.String ����������
		 */
		public String format(String line) {
			return line;
		}
	}

	// ��������

	/** ��־���� */
	//private static final Logger LOGGER = LoggerFactory.getLogger(FileUtils.class);

	/** ���ַ� */
	private static final String EMPTY_STR = "";

	/** �����С */
	private static final int BUFFER_SIZE = 2048;
}
