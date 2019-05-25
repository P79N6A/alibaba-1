package com.culturecloud.exception;

import java.io.Serializable;

/**
 * 定义一个UnChecked 用于业务逻辑抛出
 * 
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 */
public class BizException extends BaseException implements Serializable {
	private static final long serialVersionUID = 1L;
	private String message;
	private String exceptionCode;

	/**
	 * Constructors
	 * 
	 * @param cause
	 *            异常接口
	 * @param code
	 *            错误消息
	 */
	public BizException(Throwable cause, String code) {
		super(code, cause, code, null);
	}

	/**
	 * @param message
	 */
	protected BizException(String message) {
		super(message);
		this.message = message;
	}

	protected BizException(String code, String message) {
		super(message);
		this.message = message;
		this.exceptionCode = code;
	}

	public String getExceptionCode() {
		return exceptionCode;
	}

	public void setExceptionCode(String code) {
		this.exceptionCode = code;
	}

	@Override
	public String getMessage() {
		return message;
	}

	public static void Throw(String message) {
		throw new BizException(message);
	}

	public static void Throw(String code, String message) {
		throw new BizException(code, message);
	}

	public static void Throw(Throwable e) {
		if (e instanceof BizException)
			throw (BizException) e;
	}

	public static void ThrowNullReference() {
		throw new BizException("对象不允许为空");
	}
}
