package com.sun3d.why.model;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class StatData {
    private Integer id;

    private String datatype;

    private String city;

    private String ctype;

    private String carea;

    private String clevel;

    private String vname;

    private Integer val1;

    private Integer val2;

    private Integer val3;

    private Integer val4;

    private Integer val5;
    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date cdate;

    private Integer week;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDatatype() {
        return datatype;
    }

    public void setDatatype(String datatype) {
        this.datatype = datatype;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCtype() {
        return ctype;
    }

    public void setCtype(String ctype) {
        this.ctype = ctype;
    }

    public String getCarea() {
        return carea;
    }

    public void setCarea(String carea) {
        this.carea = carea;
    }

    public String getClevel() {
        return clevel;
    }

    public void setClevel(String clevel) {
        this.clevel = clevel;
    }

    public String getVname() {
        return vname;
    }

    public void setVname(String vname) {
        this.vname = vname;
    }

    public Integer getVal1() {
        return val1;
    }

    public void setVal1(Integer val1) {
        this.val1 = val1;
    }

    public Integer getVal2() {
        return val2;
    }

    public void setVal2(Integer val2) {
        this.val2 = val2;
    }

    public Integer getVal3() {
        return val3;
    }

    public void setVal3(Integer val3) {
        this.val3 = val3;
    }

    public Integer getVal4() {
        return val4;
    }

    public void setVal4(Integer val4) {
        this.val4 = val4;
    }

    public Integer getVal5() {
        return val5;
    }

    public void setVal5(Integer val5) {
        this.val5 = val5;
    }

    public Date getCdate() {
        return cdate;
    }

    public void setCdate(Date cdate) {
        this.cdate = cdate;
    }

    public Integer getWeek() {
        return week;
    }

    public void setWeek(Integer week) {
        this.week = week;
    }
}