package com.sun3d.why.exception;

/**
 * 异常信息作为用户提示信息封装
 * 
 * @author zengjin
 *
 */
public class UserReadableException extends RuntimeException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4756645844115898806L;
	private String message;

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public UserReadableException(String message) {
		super();
		this.message = message;
	}

}
