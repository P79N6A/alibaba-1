package com.sun3d.why.publicWebservice.model;

import java.io.Serializable;

/**
 * httpRes 数据返回
 * Created by niubiao on 2016/4/5.
 */
public class HttpRes implements Serializable {

    private Integer code;

    private Object data;

    private String resDesc;


    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public String getResDesc() {
        return resDesc;
    }

    public void setResDesc(String resDesc) {
        this.resDesc = resDesc;
    }
}
