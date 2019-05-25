package com.sun3d.why.model.extmodel;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class AppSysDict implements Serializable {
    private String dictId;

    private String dictName;

    private String dictCode;

    private List<DictExt> dictList;

    public String getDictId() {
        return dictId;
    }

    public void setDictId(String dictId) {
        this.dictId = dictId == null ? null : dictId.trim();
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName == null ? null : dictName.trim();
    }

    public String getDictCode() {
        return dictCode;
    }

    public void setDictCode(String dictCode) {
        this.dictCode = dictCode == null ? null : dictCode.trim();
    }

    public List<DictExt> getDictList() {
        return dictList;
    }

    public void setDictList(List<DictExt> dictList) {
        this.dictList = dictList;
    }
}