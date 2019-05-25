package com.sun3d.why.enumeration.contest;

/**
 * 文化竞赛 主题状态
 * @author zhangshun
 *
 */
public enum CcpContestTopicStatusEnum {

	TOPIC_STATUS_DOWN(0,"下架"),
	TOPIC_STATUS_UP(1,"上架");
	
	private int value;
	private String text;
	private CcpContestTopicStatusEnum(int value, String text) {
		this.value = value;
		this.text = text;
	}
	
	public int getValue() {
		return value;
	}
	
	/**
	 * 根据状态获取名称
	 * @param value
	 * @return
	 */
	public static String getStatusText(int value)
	{
		for (CcpContestTopicStatusEnum e : CcpContestTopicStatusEnum.values()) {
            if (e.getValue()==value) {
                return e.text;
            }
        }
        return null;
	}
	
	
}