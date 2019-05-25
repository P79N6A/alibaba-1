package com.culturecloud.enumeration.contest;

public enum TopicIsLevelEnum {

	IS_LEVELUP_YES(1),
	IS_LEVELUP_NO(0);
	
	private int value;
	
	private TopicIsLevelEnum(int value) {
		this.value=value;
	}

	public int getValue() {
		return value;
	}
	
	
}
