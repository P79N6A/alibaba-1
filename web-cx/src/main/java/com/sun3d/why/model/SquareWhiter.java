package com.sun3d.why.model;

public class SquareWhiter {
    private String whiteUserId;

    private String type;

    public SquareWhiter() {
		super();
	}

	public SquareWhiter(String whiteUserId, String type) {
		super();
		this.whiteUserId = whiteUserId;
		this.type = type;
	}

	public String getWhiteUserId() {
        return whiteUserId;
    }

    public void setWhiteUserId(String whiteUserId) {
        this.whiteUserId = whiteUserId == null ? null : whiteUserId.trim();
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type == null ? null : type.trim();
    }
}