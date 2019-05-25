package com.culturecloud.model.bean.common;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

import javax.persistence.Column;
@Table(value="sys_user_integral")
public class SysUserIntegral implements BaseEntity {

    @Id
    @Column(name="INTEGRAL_ID")
    private String integralId;


    @Column(name="USER_ID")
    private String userId;


    @Column(name="INTEGRAL_NOW")
    private Integer integralNow;


    @Column(name="INTEGRAL_HIS")
    private Integer integralHis;


    public String getIntegralId() {
        return integralId;
    }


    public void setIntegralId(String integralId) {
        this.integralId = integralId;
    }

    public String getUserId() {
        return userId;
    }


    public void setUserId(String userId) {
        this.userId = userId;
    }


    public Integer getIntegralNow() {
        return integralNow;
    }


    public void setIntegralNow(Integer integralNow) {
        this.integralNow = integralNow;
    }


    public Integer getIntegralHis() {
        return integralHis;
    }


    public void setIntegralHis(Integer integralHis) {
        this.integralHis = integralHis;
    }
}