package com.sun3d.why.model.topic;

/**
 * Created by ct on 16/10/9.
 */
public class Template
{

    int id;
    String container;
    String content;
    String fields;
    int fieldnum;
    String image;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getContainer() {
        return container;
    }

    public void setContainer(String container) {
        this.container = container;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getFields() {
        return fields;
    }

    public void setFields(String fields) {
        this.fields = fields;
    }

    public int getFieldnum() {
        return fieldnum;
    }

    public void setFieldnum(int fieldnum) {
        this.fieldnum = fieldnum;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
