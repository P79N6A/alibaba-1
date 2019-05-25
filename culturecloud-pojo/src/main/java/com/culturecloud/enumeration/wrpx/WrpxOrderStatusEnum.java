package com.culturecloud.enumeration.wrpx;
/**
 * 课程订单状态
 * @author Administrator
 *
 */
public enum WrpxOrderStatusEnum {
	CONFIRED(1, "已确认"), UNDETERMINED(2, "待确认"), NO_PASS(3, "审核未通过"), QUIT_COURSE(4, "退课"), SIGN_IN(5, "已签到"), LIKED(6,
			"我想学");
	private Integer index;
	private String name;

	private WrpxOrderStatusEnum(Integer index, String name) {
		this.index = index;
		this.name = name;
	}

	public Integer getIndex() {
		return index;
	}

	public void setIndex(Integer index) {
		this.index = index;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	

	public static void main(String[] args) {
		WrpxOrderStatusEnum e=	WrpxOrderStatusEnum.valueOf("UNDETERMINED");
		System.out.println(e.getIndex());
		
		
	}
}
