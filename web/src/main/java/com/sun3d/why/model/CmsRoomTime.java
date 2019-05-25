package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsRoomTime extends Pagination implements Serializable{
    private String roomTimeId;

    private String timePeriod;

    private Integer isOpen;

    private String roomId;

    private Date updateTime;

    private String updateUser;

    private Integer timeSort;

    private Integer roomDay;
    private  Integer  roomDayMonday;
    private Integer roomDayTuesday;
    private Integer roomDayWednesday;
    private  Integer roomDayThursday;
    private Integer roomDayFriday;
    private Integer roomDaySaturday;
    private Integer roomDaySunday;
    private  String times;

    public Integer getRoomIsDel() {
        return roomIsDel;
    }

    public void setRoomIsDel(Integer roomIsDel) {
        this.roomIsDel = roomIsDel;
    }

    private Integer roomIsDel;
    public String getTimes() {
        return times;
    }

    public void setTimes(String times) {
        this.times = times;
    }

    public Integer getRoomDayMonday() {
        return roomDayMonday;
    }

    public void setRoomDayMonday(Integer roomDayMonday) {
        this.roomDayMonday = roomDayMonday;
    }

    public Integer getRoomDaySunday() {
        return roomDaySunday;
    }

    public void setRoomDaySunday(Integer roomDaySunday) {
        this.roomDaySunday = roomDaySunday;
    }

    public Integer getRoomDayFriday() {
        return roomDayFriday;
    }

    public void setRoomDayFriday(Integer roomDayFriday) {
        this.roomDayFriday = roomDayFriday;
    }

    public Integer getRoomDaySaturday() {
        return roomDaySaturday;
    }

    public void setRoomDaySaturday(Integer roomDaySaturday) {
        this.roomDaySaturday = roomDaySaturday;
    }

    public Integer getRoomDayThursday() {
        return roomDayThursday;
    }

    public void setRoomDayThursday(Integer roomDayThursday) {
        this.roomDayThursday = roomDayThursday;
    }

    public Integer getRoomDayWednesday() {
        return roomDayWednesday;
    }

    public void setRoomDayWednesday(Integer roomDayWednesday) {
        this.roomDayWednesday = roomDayWednesday;
    }

    public Integer getRoomDayTuesday() {
        return roomDayTuesday;
    }

    public void setRoomDayTuesday(Integer roomDayTuesday) {
        this.roomDayTuesday = roomDayTuesday;
    }

    public String getRoomTimeId() {
        return roomTimeId;
    }

    public void setRoomTimeId(String roomTimeId) {
        this.roomTimeId = roomTimeId == null ? null : roomTimeId.trim();
    }

    public String getTimePeriod() {
        return timePeriod;
    }

    public void setTimePeriod(String timePeriod) {
        this.timePeriod = timePeriod == null ? null : timePeriod.trim();
    }

    public Integer getIsOpen() {
        return isOpen;
    }

    public void setIsOpen(Integer isOpen) {
        this.isOpen = isOpen;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId == null ? null : roomId.trim();
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Integer getTimeSort() {
        return timeSort;
    }

    public void setTimeSort(Integer timeSort) {
        this.timeSort = timeSort;
    }

    public Integer getRoomDay() {
        return roomDay;
    }

    public void setRoomDay(Integer roomDay) {
        this.roomDay = roomDay;
    }
}