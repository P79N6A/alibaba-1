package com.sun3d.why.model.topic;

import java.util.List;

/**
 * Created by ct on 16/9/27.
 */
public class ActivityTopic
{


    int id;
    String title;
    String headimg;
    String stime;
    String etime;
    String remark;
    int isvalid;
    String ctime;
    String cuserid;
    String sharetitle;
    String shareimg;
    String sharedesc;

    private List<Activity>  activytList;
    private List<Block>     blockList;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getHeadimg() {
        return headimg;
    }

    public void setHeadimg(String headimg) {
        this.headimg = headimg;
    }

    public String getStime() {
        return stime;
    }

    public void setStime(String stime) {
        this.stime = stime;
    }

    public String getEtime() {
        return etime;
    }

    public void setEtime(String etime) {
        this.etime = etime;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public int getIsvalid() {
        return isvalid;
    }

    public void setIsvalid(int isvalid) {
        this.isvalid = isvalid;
    }

    public String getCtime() {
        return ctime;
    }

    public void setCtime(String ctime) {
        this.ctime = ctime;
    }

    public String getCuserid() {
        return cuserid;
    }

    public void setCuserid(String cuserid) {
        this.cuserid = cuserid;
    }

    public List<Activity> getActivytList() {
        return activytList;
    }

    public void setActivytList(List<Activity> activytList) {
        this.activytList = activytList;
    }

    public List<Block> getBlockList() {
        return blockList;
    }

    public void setBlockList(List<Block> blockList) {
        this.blockList = blockList;
    }

    public String getSharetitle() {
        return sharetitle;
    }

    public void setSharetitle(String sharetitle) {
        this.sharetitle = sharetitle;
    }

    public String getShareimg() {
        return shareimg;
    }

    public void setShareimg(String shareimg) {
        this.shareimg = shareimg;
    }

    public String getSharedesc() {
        return sharedesc;
    }

    public void setSharedesc(String sharedesc) {
        this.sharedesc = sharedesc;
    }
}
