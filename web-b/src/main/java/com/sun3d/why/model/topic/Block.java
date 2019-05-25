package com.sun3d.why.model.topic;

import java.util.List;

/**
 * Created by ct on 16/10/9.
 */
public class Block
{
    int id;
    int tid;
    String bname;
    List<BlockContent> content;//板块内容
    int aord; //显示次序
    int showname;//显示板块名称
    int templateid;
    int isvalid;
    String templateContainer;
    String templateContent;
    int fieldnum;
    String showContent;

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

    public String getBname() {
        return bname;
    }

    public void setBname(String bname) {
        this.bname = bname;
    }

    public List<BlockContent> getContent() {
        return content;
    }

    public void setContent(List<BlockContent> content) {
        this.content = content;
    }

    public int getAord() {
        return aord;
    }

    public void setAord(int aord) {
        this.aord = aord;
    }

    public int getShowname() {
        return showname;
    }

    public void setShowname(int showname) {
        this.showname = showname;
    }

    public int getTemplateid() {
        return templateid;
    }

    public void setTemplateid(int templateid) {
        this.templateid = templateid;
    }

    public int getIsvalid() {
        return isvalid;
    }

    public void setIsvalid(int isvalid) {
        this.isvalid = isvalid;
    }

    public String getTemplateContainer() {
        return templateContainer;
    }

    public void setTemplateContainer(String templateContainer) {
        this.templateContainer = templateContainer;
    }

    public String getTemplateContent() {
        return templateContent;
    }

    public void setTemplateContent(String templateContent) {
        this.templateContent = templateContent;
    }

    public int getFieldnum() {
        return fieldnum;
    }

    public void setFieldnum(int fieldnum) {
        this.fieldnum = fieldnum;
    }

    public String getShowContent() {
        return showContent;
    }

    public void setShowContent(String showContent) {
        this.showContent = showContent;
    }
}
