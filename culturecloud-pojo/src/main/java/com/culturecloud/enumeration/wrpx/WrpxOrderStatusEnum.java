package com.culturecloud.enumeration.wrpx;
/**
 * �γ̶���״̬
 * @author Administrator
 *
 */
public enum WrpxOrderStatusEnum {
	CONFIRED(1, "��ȷ��"), UNDETERMINED(2, "��ȷ��"), NO_PASS(3, "���δͨ��"), QUIT_COURSE(4, "�˿�"), SIGN_IN(5, "��ǩ��"), LIKED(6,
			"����ѧ");
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
