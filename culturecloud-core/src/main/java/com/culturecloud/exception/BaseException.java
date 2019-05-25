package com.culturecloud.exception;

/**
 * 异常基类，各个模块的运行期异常均继承与该类; 这个类定义了项目异常类的基本模板，其他异常继承与它
 * 
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 * 
 */
public class BaseException extends RuntimeException {

	/**
	 * the serialVersionUID
	 */
	private static final long serialVersionUID = 1381325479896057076L;

	/**
	 * message key
	 */
	private String code;

	/**
	 * message params
	 */
	private Object[] values;

	/**
	 * @return the code
	 */
	public String getCode() {
		return code;
	}

	/**
	 * @param code
	 *            the code to set
	 */
	public void setCode(String code) {
		this.code = code;
	}

	/**
	 * @return the values
	 */
	public Object[] getValues() {
		return values;
	}

	/**
	 * @param values
	 *            the values to set
	 */
	public void setValues(Object[] values) {
		this.values = values;
	}
	
	

	public BaseException() {
		super();
	}

	public BaseException(String message, Throwable cause,
			boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

	public BaseException(String message, Throwable cause) {
		super(message, cause);
	}

	public BaseException(Throwable cause) {
		super(cause);
	}

	public BaseException(String code) {
		super(code);
		this.code = code;
	}

	public BaseException(String message, Throwable cause, String code,
			Object[] values) {
		super(message, cause);
		this.code = code;
		this.values = values;
	}
}
