package com.sun3d.why.model.topic;

/**
 * Created by ct on 16/10/9.
 */
public class Activity
{
    int id;
    int tid;
    String activityid;
    String activity_memo;


    int ACTIVITY_IS_RESERVATION;
    int AVAILABLE_COUNT;
    int actvityCanBooking;

    //标签文字
    String hname;
    String title;
    String addr;
    String duration;
    String image;
    String stime;



    int aord;
    int isExpired;
    String linktitle;
    int linkisblue;


    int  SPIKE_TYPE;//1秒杀
    String spike_time;//秒杀时间
    String activity_start_time;
    String activity_end_time;

    public String getSpike_time()
    {
        return spike_time;
    }

    public void setSpike_time(String spike_time)
    {
        this.spike_time = spike_time;
    }



    public String getActivity_end_time()
    {
        return activity_end_time;
    }

    public void setActivity_end_time(String activity_end_time)
    {
        this.activity_end_time = activity_end_time;
    }

    public String getActivity_start_time()
    {
        return activity_start_time;
    }

    public void setActivity_start_time(String activity_start_time)
    {
        this.activity_start_time = activity_start_time;
    }

    public int getSPIKE_TYPE()
    {
        return SPIKE_TYPE;
    }

    public void setSPIKE_TYPE(int SPIKE_TYPE)
    {
        this.SPIKE_TYPE = SPIKE_TYPE;
    }



    public String getLinktitle() {
        return linktitle;
    }

    public void setLinktitle(String linktitle) {
        this.linktitle = linktitle;
    }

    public int getLinkisblue() {
        return linkisblue;
    }

    public void setLinkisblue(int linkisblue) {
        this.linkisblue = linkisblue;
    }


    public int getIsExpired() {
        return isExpired;
    }

    public void setIsExpired(int isExpired) {
        this.isExpired = isExpired;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getTid() {
        return tid;
    }

    public void setTid(int tid) {
        this.tid = tid;
    }

    public String getActivityid() {
        return activityid;
    }

    public void setActivityid(String activityid) {
        this.activityid = activityid;
    }

    public String getActivity_memo() {
        return activity_memo;
    }

    public void setActivity_memo(String activity_memo) {
        this.activity_memo = activity_memo;
    }

    public int getACTIVITY_IS_RESERVATION() {
        return ACTIVITY_IS_RESERVATION;
    }

    public void setACTIVITY_IS_RESERVATION(int ACTIVITY_IS_RESERVATION) {
        this.ACTIVITY_IS_RESERVATION = ACTIVITY_IS_RESERVATION;
    }

    public int getAVAILABLE_COUNT() {
        return AVAILABLE_COUNT;
    }

    public void setAVAILABLE_COUNT(int AVAILABLE_COUNT) {
        this.AVAILABLE_COUNT = AVAILABLE_COUNT;
    }

    public int getActvityCanBooking() {
        return actvityCanBooking;
    }

    public void setActvityCanBooking(int actvityCanBooking) {
        this.actvityCanBooking = actvityCanBooking;
    }

    public String getHname() {
        return hname;
    }

    public void setHname(String hname) {
        this.hname = hname;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAddr() {
        return addr;
    }

    public void setAddr(String addr) {
        this.addr = addr;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStime() {
        return stime;
    }

    public void setStime(String stime) {
        this.stime = stime;
    }

    public int getAord() {
        return aord;
    }

    public void setAord(int aord) {
        this.aord = aord;
    }
}