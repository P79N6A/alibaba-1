package com.culturecloud.model.request.advert;


import com.culturecloud.bean.BaseRequest;

import javax.validation.constraints.NotNull;

public class GetAdvertVO extends BaseRequest {
    @NotNull(message = "运营位置不可以为空")
    private Integer advertPostion;

    private String advertType;

    private Integer advertSort;

    public Integer getAdvertPostion() {
        return advertPostion;
    }

    public void setAdvertPostion(Integer advertPostion) {
        this.advertPostion = advertPostion;
    }

    public String getAdvertType() {
		return advertType;
	}

	public void setAdvertType(String advertType) {
		this.advertType = advertType;
	}

	public Integer getAdvertSort() {
        return advertSort;
    }

    public void setAdvertSort(Integer advertSort) {
        this.advertSort = advertSort;
    }
}
