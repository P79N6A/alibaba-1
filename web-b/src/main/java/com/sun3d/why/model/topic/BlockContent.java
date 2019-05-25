package com.sun3d.why.model.topic;

/**
 * Created by ct on 16/10/9.
 */
public class BlockContent
{
    int id;
    int bid;
    int tid;
    String attr;
    int cord;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBid() {
        return bid;
    }

    public void setBid(int bid) {
        this.bid = bid;
    }

    public int getTid() {
        return tid;
    }

    public void setTid(int tid) {
        this.tid = tid;
    }

    public String getAttr() {
        return attr;
    }

    public void setAttr(String attr) {
        this.attr = attr;
    }

    public int getCord() {
        return cord;
    }

    public void setCord(int cord) {
        this.cord = cord;
    }
}