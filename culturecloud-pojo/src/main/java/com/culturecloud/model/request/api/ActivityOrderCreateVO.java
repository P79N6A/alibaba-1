package com.culturecloud.model.request.api;

import com.culturecloud.bean.BaseRequest;

import java.util.List;

/**
 * 子平台上传活动VO
 */
public class ActivityOrderCreateVO extends BaseRequest {

  private List<ActivityOrderCreateApi> orderList;

    private String platSource;

    public String getPlatSource() {
        return platSource;
    }

    public void setPlatSource(String platSource) {
        this.platSource = platSource;
    }

    public List<ActivityOrderCreateApi> getOrderList() {
        return orderList;
    }

    public void setOrderList(List<ActivityOrderCreateApi> orderList) {
        this.orderList = orderList;
    }
}
