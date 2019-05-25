package com.culturecloud.db;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.persistence.Column;

import org.apache.commons.lang.StringUtils;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

/**
 * MybatisSQL语句拼装类
 * 
 * zhangchenxi
 * 
 * 2015-06-03
 */
public class MyBatisSQLGenerator {

	private final static Map<Class<? extends BaseEntity>, Map<String, String>> FIELD_ID_MAP = new HashMap<Class<? extends BaseEntity>, Map<String, String>>();

	private final static Map<Class<? extends BaseEntity>, Map<String, String>> FIELD_COLUMN_MAP = new HashMap<Class<? extends BaseEntity>, Map<String, String>>();

	private final static Map<Class<? extends BaseEntity>, String> TABLENAME_MAP = new HashMap<Class<? extends BaseEntity>, String>();

	/** 新增SQl生成 */
	public static String insert(final BaseEntity model) throws Exception {
		Class<? extends BaseEntity> clazz = model.getClass();
		final Map<String, String> fieldcolumn = getFieldColumnFromModelClass(clazz);
		final Set<String> fieldcolumnKeySet = fieldcolumn.keySet();
		final String tableName = getTableNameFromModelClass(clazz);
		final String columns = getInsertColumns(fieldcolumn, fieldcolumnKeySet, model);
		final String values = getInsertValue(fieldcolumnKeySet, model);
		final String sql = "INSERT INTO " + tableName + columns + " VALUES" + values;
		return sql;
	}

	/**
	 * 通过ID获取对象SQL语句生成
	 */
	public static String getFindByIdSql(final String id, final Class<? extends BaseEntity> clazz) {
		final StringBuilder sqlBuilder = new StringBuilder();
		final String tableName = getTableNameFromModelClass(clazz);

		final Map<String, String> fieldIdMap = getFieldIdFromModelClass(clazz);

		String fieldId = null;

		for (String columnName : fieldIdMap.values()) {
			fieldId = columnName;
		}

		if (fieldId != null) {
			sqlBuilder.append("SELECT * FROM ").append(tableName).append(" WHERE ").append(fieldId).append("='")
					.append(id).append("'");
			return sqlBuilder.toString();
		} else
			return null;

	}

	/**
	 * 
	 * 通过model获取对象
	 * 
	 * @throws SecurityException
	 * @throws NoSuchMethodException
	 * @throws InvocationTargetException
	 * @throws IllegalArgumentException
	 * @throws IllegalAccessException
	 * 
	 * @throws Exception
	 */
	public static String getFindByModelSql(final BaseEntity model) {
		final Class<? extends BaseEntity> clazz = model.getClass();
		final String tableName = getTableNameFromModelClass(clazz);
		final String whereString = getFindWhere(model);
		return "SELECT * FROM " + tableName + " WHERE 1=1 " + whereString;
	}

	/** 查询SQL生成 */
	public static String getFind(final Class<? extends BaseEntity> clazz, String whereSql) {
		if (whereSql == null) {
			whereSql = "";
		}
		final String tableName = getTableNameFromModelClass(clazz);
		final String sql = "SELECT * FROM " + tableName + " " + whereSql;
		return sql;
	}

	/** 单表分页查询SQL生成 */
	public static String getFindByPage(final Class<? extends BaseEntity> clazz, String whereSql, Integer firstindex,
			Integer maxresult) {
		if (whereSql == null) {
			whereSql = "";
		}
		final String tableName = getTableNameFromModelClass(clazz);
		final String sql = "SELECT * FROM " + tableName + " " + whereSql + " limit " + firstindex + "," + maxresult;
		return sql;
	}

	/** 获取条数 */
	public static String getFindCount(final Class<? extends BaseEntity> clazz, String whereSql) {
		if (whereSql == null) {
			whereSql = "";
		}
		final String tableName = getTableNameFromModelClass(clazz);
		final String sql = "SELECT COUNT(*) FROM " + tableName + " " + whereSql;
		return sql;
	}

	/** 更新SQL生成 */
	public static String update(final BaseEntity model, String whereSql) throws Exception {
		if (whereSql == null) {
			whereSql = "";
		}
		Class<? extends BaseEntity> clazz = model.getClass();
		final Map<String, String> fieldcolumn = getFieldColumnFromModelClass(clazz);
		final String tableName = getTableNameFromModelClass(clazz);
		final StringBuilder setBuilder = new StringBuilder();
		final Set<String> fieldcolumnKeySet = fieldcolumn.keySet();
		final Map<String, String> fieldIdMap = getFieldIdFromModelClass(clazz);
		for (final String fieldName : fieldcolumnKeySet) {
			// 是主键就跳过
			if (fieldIdMap.get(fieldName) != null) {
				continue;
			}
			final String getMethodName = "get" + capitalize(fieldName);
			final Object value = clazz.getMethod(getMethodName).invoke(model);
			final String columnName = fieldcolumn.get(fieldName);
			// if (isNull) {
			// if (value == null) {
			// setBuilder.append(columnName + "=null");
			// }
			// else {
			// setBuilder.append(columnName + "=" +
			// MyBatisSQLGenerator.handleValue(value));
			// }
			// setBuilder.append(",");
			// }
			// else {
			if (value != null) {
				setBuilder.append(columnName + "=" + MyBatisSQLGenerator.handleValue(value));
				setBuilder.append(",");
				// }
			}
		}
		String setString = setBuilder.toString();

		if (StringUtils.isBlank(setString)) {
			// throw new NormStarRuntimeException("更新对象的属性中全部没有数据！");
		} else {
			setString = setString.substring(0, setString.length() - 1);
		}
		final String sql = "UPDATE " + tableName + " SET " + setString + " " + whereSql;
		 System.out.println("Update --- " + sql);
		return sql;
	}

	/** 删除SQL */
	public static String delete(final Class<? extends BaseEntity> clazz, String whereSql) {
		if (whereSql == null) {
			whereSql = "";
		}
		final String tableName = getTableNameFromModelClass(clazz);
		final String sql = "DELETE  FROM " + tableName + " " + whereSql;
		return sql;
	}

	/** 获取字段名及列名 */
	private static Map<String, String> getFieldColumnFromModelClass(Class clazz) {
		Map<String, String> fieldColumn = new HashMap<String, String>();
		Field[] fields = clazz.getDeclaredFields();
		// List<Field> list=Arrays.asList(fields);
		for (final Field field : fields) {
			final Column column = field.getAnnotation(Column.class);
			if (column == null) {
				continue;
			}
			String columnName = column.name();

			if (StringUtils.isBlank(columnName)) {
				columnName = field.getName();
			}

			final String columnFieldName = field.getName();
			fieldColumn.put(columnFieldName, columnName);
		}

		return fieldColumn;
	}

	/** 获取表名称 */
	private static String getTableNameFromModelClass(Class clazz) {
		Table table = (Table) clazz.getAnnotation(Table.class);
		String tableName = table.value();
		return tableName;
	}

	/** 获取需要插入列 */
	public static String getInsertColumns(final Map<String, String> fieldcolumn, final Set<String> fieldcolumnKeySet,
			final BaseEntity model) throws Exception {
		final Class<? extends BaseEntity> clazz = model.getClass();
		final StringBuilder columnsBuilder = new StringBuilder();
		for (final String fieldName : fieldcolumnKeySet) {
			final String getMethodName = "get" + capitalize(fieldName);
			final Object value = clazz.getMethod(getMethodName).invoke(model);
			if (value != null) {
				columnsBuilder.append(",").append(fieldcolumn.get(fieldName));
			}
		}
		return "(" + columnsBuilder.toString().substring(1, columnsBuilder.toString().length()) + ")";
	}

	/** 获取插入值 */
	public static String getInsertValue(final Set<String> fieldcolumnKeySet, final BaseEntity model) throws Exception {
		final Class<? extends BaseEntity> clazz = model.getClass();
		final StringBuilder valuesBuilder = new StringBuilder();
		for (final String fieldName : fieldcolumnKeySet) {
			final String getMethodName = "get" + capitalize(fieldName);
			final Object value = clazz.getMethod(getMethodName).invoke(model);
			if (value != null) {
				valuesBuilder.append(",").append(handleValue(value));
			}
		}
		return "(" + valuesBuilder.toString().substring(1, valuesBuilder.toString().length()) + ")";
	}

	/** 值转换 */
	private static Object handleValue(Object value) {
		if (value instanceof String) {
			value = "'" + value + "'";
		} else if (value instanceof Date) {
			final Date date = (Date) value;
			final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

			value = "'" + Timestamp.valueOf(simpleDateFormat.format(date)) + "'";
		} else if (value instanceof Boolean) {
			final Boolean v = (Boolean) value;
			value = v ? 1 : 0;
		} else if ((null == value)) {
			value = "''";
		}
		return value;
	}

	private static Map<String, String> getFieldIdFromModelClass(final Class<? extends BaseEntity> clazz) {
		Map<String, String> fieldColumn = MyBatisSQLGenerator.FIELD_ID_MAP.get(clazz);
		if (fieldColumn != null) {
			return fieldColumn;
		}
		fieldColumn = new HashMap<String, String>();

		Field[] fields = clazz.getDeclaredFields();
		// final List<Field> fields=Arrays.asList(fields);
		// final List<Field> fields = SXReflectionUtils.getAllFields(clazz);
		for (final Field field : fields) {
			final Id idFiled = field.getAnnotation(Id.class);
			if (idFiled == null) {
				continue;
			}

			String columnName = idFiled.name();
			if (columnName != null) {
				final Column column = field.getAnnotation(Column.class);
				columnName = column.name();
			}
			final String columnFieldName = field.getName();
			if (StringUtils.isBlank(columnName)) {
				columnName = columnFieldName;
			}
			fieldColumn.put(columnFieldName, columnName);
		}
		MyBatisSQLGenerator.FIELD_ID_MAP.put(clazz, fieldColumn); // 放入缓存FIELD_ID_MAP中
		return fieldColumn;
	}

	private static String getFindWhere(final BaseEntity model) {
		final StringBuilder setBuilder = new StringBuilder("");

		final Class<? extends BaseEntity> clazz = model.getClass();
		final Map<String, String> fieldcolumn = getFieldColumnFromModelClass(clazz);
		final Set<String> fieldcolumnKeySet = fieldcolumn.keySet();
		for (final String fieldName : fieldcolumnKeySet) {
			final String getMethodName = "get" + capitalize(fieldName);
			Object value = null;
			try {
				value = clazz.getMethod(getMethodName).invoke(model);
			} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException
					| NoSuchMethodException | SecurityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			final String columnName = fieldcolumn.get(fieldName);

			if ((value != null) && !"".equals(value)) {
				setBuilder.append(" AND " + columnName + "=" + handleValue(value));
			}
		}
		return setBuilder.toString();
	}

	public static String capitalize(String e) {
		return e.substring(0, 1).toUpperCase() + e.substring(1, e.length());
	}

}
