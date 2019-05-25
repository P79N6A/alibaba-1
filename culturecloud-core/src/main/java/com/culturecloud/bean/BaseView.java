package com.culturecloud.bean;

import java.io.Serializable;

import javax.ws.rs.core.Response.Status;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * 该类主要封装业务逻辑以及java内部返回给客户端的数据。 该类是所有返回给客户端数据类型对象的抽象父类。
 * 
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 * 
 */
@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class BaseView implements Serializable {

	private static final long serialVersionUID = 6650484010109787534L;
	/** 保存服务调用传输状态，例如：0代表操作异常；1代表操作成功。 */
	private String status;
	/** 保存需要告诉客户端成功还是发生异常。 */
	private MsgObject msg;
	/** 保存服务调用返回的非分页数据。 */
	private Object data;

	public BaseView() {
		super();
	}

	public BaseView(String status, String msg, Object data, Status statusCode) {
		super();
		this.status = status;
		this.data = data;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public MsgObject getMsg() {
		return msg;
	}

	public void setMsg(MsgObject msg) {
		this.msg = msg;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	
	 public MsgObject getInnerMsg() { 
	        return new MsgObject(); 
	 }
	 
	 public MsgObject getInnerMsg(String code,String msg) { 
	        return new MsgObject(code,msg); 
	 } 

	public class MsgObject{
		/**
		 * code =1  可显示错误 code =-1参数验证异常 code=-2 系统异常
		 */
		private String errcode="0";
		private String errmsg;

		public MsgObject(String code,String msg){
			errcode = code;
			errmsg = msg;
		}
		public MsgObject(){
			
		}
		public String getErrcode() {
			return errcode;
		}
		public void setErrcode(String errcode) {
			this.errcode = errcode;
		}
		public String getErrmsg() {
			return errmsg;
		}
		public void setErrmsg(String errmsg) {
			this.errmsg = errmsg;
		}
		
		
	
	}

}
