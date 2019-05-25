package com.culturecloud.model.bean.common;


import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

import javax.persistence.Column;
import java.util.Date;
@Table(value="sys_user_integral_detail")
public class SysUserIntegralDetail implements BaseEntity {

    @Id
    @Column(name="INTEGRAL_DETAIL_ID")
    private String integralDetailId;

    @Column(name="INTEGRAL_ID")
    private String integralId;

    @Column(name="INTEGRAL_CHANGE")
    private Integer integralChange;

    @Column(name="CREATE_TIME")
    private Date createTime;

    @Column(name="CHANGE_TYPE")
    private Integer changeType;

    @Column(name="INTEGRAL_FROM")
    private String integralFrom;

    @Column(name="INTEGRAL_TYPE")
    private Integer integralType;

    @Column(name="INTEGRAL_NAME")
    private Integer integralName;

    @Column(name="INTEGRAL_DESCRIPTION")
    private Integer integralDescription;

    public String getIntegralDetailId() {
        return integralDetailId;
    }


    public void setIntegralDetailId(String integralDetailId) {
        this.integralDetailId = integralDetailId;
    }


    public String getIntegralId() {
        return integralId;
    }


    public void setIntegralId(String integralId) {
        this.integralId = integralId;
    }


    public Integer getIntegralChange() {
        return integralChange;
    }


    public void setIntegralChange(Integer integralChange) {
        this.integralChange = integralChange;
    }


    public Date getCreateTime() {
        return createTime;
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }


    public Integer getChangeType() {
        return changeType;
    }


    public void setChangeType(Integer changeType) {
        this.changeType = changeType;
    }


    public String getIntegralFrom() {
        return integralFrom;
    }


    public void setIntegralFrom(String integralFrom) {
        this.integralFrom = integralFrom;
    }


    public Integer getIntegralType() {
        return integralType;
    }


    public void setIntegralType(Integer integralType) {
        this.integralType = integralType;
    }

    public Integer getIntegralName() {
        return integralName;
    }

    public void setIntegralName(Integer integralName) {
        this.integralName = integralName;
    }

    public Integer getIntegralDescription() {
        return integralDescription;
    }

    public void setIntegralDescription(Integer integralDescription) {
        this.integralDescription = integralDescription;
    }
}
