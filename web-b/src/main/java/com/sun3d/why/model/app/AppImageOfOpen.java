package com.sun3d.why.model.app;

import java.sql.Date;

/**
 * Created by ct on 2017/3/6.
 */
public class AppImageOfOpen
{
    int imageid;
    String city;
    String imageurl_retina;
    String imageurl_normal;
    int status;
    Date cdate;
    Date startDate;
    Date endDate;
    int  isDefaultImage;

    public int getImageid() {
        return imageid;
    }

    public void setImageid(int imageid) {
        this.imageid = imageid;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getImageurl_normal() {
        return imageurl_normal;
    }

    public void setImageurl_normal(String imageurl_normal) {
        this.imageurl_normal = imageurl_normal;
    }

    public String getImageurl_retina() {
        return imageurl_retina;
    }

    public void setImageurl_retina(String imageurl_retina) {
        this.imageurl_retina = imageurl_retina;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Date getCdate() {
        return cdate;
    }

    public void setCdate(Date cdate) {
        this.cdate = cdate;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getIsDefaultImage() {
        return isDefaultImage;
    }

    public void setIsDefaultImage(int isDefaultImage) {
        this.isDefaultImage = isDefaultImage;
    }
}
