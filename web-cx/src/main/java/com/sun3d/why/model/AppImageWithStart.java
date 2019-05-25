package com.sun3d.why.model;

import java.util.Date;

public class AppImageWithStart {
    private Integer imageid;

    private String city;

    private String imageurlRetina;

    private String imageurlNormal;

    private Integer status;

    private Date cdate;

    private Date startdate;

    private Date enddate;

    private Integer isdefaultimage;

    public Integer getImageid() {
        return imageid;
    }

    public void setImageid(Integer imageid) {
        this.imageid = imageid;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city == null ? null : city.trim();
    }

    public String getImageurlRetina() {
        return imageurlRetina;
    }

    public void setImageurlRetina(String imageurlRetina) {
        this.imageurlRetina = imageurlRetina == null ? null : imageurlRetina.trim();
    }

    public String getImageurlNormal() {
        return imageurlNormal;
    }

    public void setImageurlNormal(String imageurlNormal) {
        this.imageurlNormal = imageurlNormal == null ? null : imageurlNormal.trim();
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getCdate() {
        return cdate;
    }

    public void setCdate(Date cdate) {
        this.cdate = cdate;
    }

    public Date getStartdate() {
        return startdate;
    }

    public void setStartdate(Date startdate) {
        this.startdate = startdate;
    }

    public Date getEnddate() {
        return enddate;
    }

    public void setEnddate(Date enddate) {
        this.enddate = enddate;
    }

    public Integer getIsdefaultimage() {
        return isdefaultimage;
    }

    public void setIsdefaultimage(Integer isdefaultimage) {
        this.isdefaultimage = isdefaultimage;
    }
}