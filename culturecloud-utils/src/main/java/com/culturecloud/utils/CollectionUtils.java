package com.culturecloud.utils;

import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * ���Ϲ�����
 * 
 * @author zhangchenxi
 */
public class CollectionUtils {

	/**
	 * ����
	 * 
	 * @param <E>
	 *            ����Ԫ������
	 * @param list
	 *            ԭʼ�б����
	 */
	public static <E> void excludeDuplicates(List<E> list) {
		HashSet<E> set = new HashSet<E>();

		for (Iterator<E> it = list.iterator(); it.hasNext();) {
			E e = it.next();
			int size = set.size();
			set.add(e);

			if (size == set.size()) {
				it.remove();
			}
		}
	}

	/**
	 * �ϲ��������
	 * 
	 * @param <E>
	 *            Object
	 * @param <C>
	 *            Collection�ľ���ʵ��
	 * @param collectionType
	 *            ��������
	 * @param iterables
	 *            �������
	 * @return �ϲ���ļ���
	 */
	public static <E extends Object, C extends Collection<E>> C merge(Class<C> collectionType, Collection<E>... iterables) {
		assert iterables.length > 0 && !collectionType.isInterface();
		try {
			C result = collectionType.newInstance();

			for (Collection<E> iterable : iterables) {
				for (E e : iterable) {
					result.add(e);
				}
			}

			return result;
		} catch (InstantiationException e) {
			e.printStackTrace();
			return null;
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * ����ת��MAP
	 * 
	 * @param <K>
	 *            ����
	 * @param <V>
	 *            ֵ����
	 * @param keyName
	 *            �����
	 * @param keyType
	 *            ������
	 * @param collection
	 *            ����
	 * @return {@link Map}
	 */
	public static <K, V> Map<K, V> collectionCovertMap(String keyName, Class<K> keyType, Collection<V> collection) {
		// TODO ������ת��ΪMap
		return null;
	}
}
