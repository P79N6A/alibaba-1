package com.sun3d.why.enumeration.contest;

public enum CcpContestTopicIsLevelEnum {

	IS_LEVELUP_YES(1),
	IS_LEVELUP_NO(0);
	
	private int value;
	
	private CcpContestTopicIsLevelEnum(int value) {
		this.value=value;
	}

	public int getValue() {
		return value;
	}
	
	
}
