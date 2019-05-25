package com.sun3d.why.enumeration;

/**
 * 用户流程操作日志
 * 
 * @author zhangshun
 *
 */
public enum UserOperationEnum {

	CREATE(1,"创建订单"),
	CANCEL(2,"退订"),
	CHECK_TICKET(3,"验票"),
	DELETE(4,"删除"),
	TAKE_TICKET(5,"取票"),
	
	CHECK_PASS(6,"审核通过"),
	CHECK_NOT_PASS(7,"审核不通过"),
	
	AUTH_PASS(8,"认证通过"),
	AUTH_NOT_PASS(9,"认证不通过"),
	AUTH_SUBMIT(10,"提交认证"),
	AUTH_RE_SUBMIT(11,"再次提交认证"),
	
	TUSER_CREATE(12,"创建使用者"),
	
	EDIT_INFO(13,"编辑信息");
	
	private int type;
	private String remark;
	
	private UserOperationEnum(int type,String remark)
	{
		this.type=type;
		this.remark=remark;
	}

	public int getType() {
		return type;
	}

	public String getRemark() {
		return remark;
	}
	
	
}
