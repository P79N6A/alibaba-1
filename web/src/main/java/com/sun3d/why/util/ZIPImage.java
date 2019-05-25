package com.sun3d.why.util;

import java.io.File;

/**
 * Created by chenjie on 2016/3/7.
 */
public class ZIPImage {

    private File file = null;

    private String outPutFilePath;

    private String inPutFilePath;

    private String inPutFileName;

    private boolean autoBuildFileName;

    private String outPutFileName;

    private int outPutFileWidth = 100; // 默认输出图片宽

    private int outPutFileHeight = 100; // 默认输出图片高

    private boolean isScaleZoom = false; // 是否按比例缩放

    public ZIPImage() {
        outPutFilePath = "";
        inPutFilePath = "";
        inPutFileName = "";
        autoBuildFileName = true;
        outPutFileName = "";
    }

    public ZIPImage(String ipfp, String ipfn,boolean aBFN) {
        inPutFilePath = ipfp;
        inPutFileName = ipfn;
        autoBuildFileName = aBFN;
    }

    /**
     *
     * @param ipfp
     * 源文件夹路径
     * @param ipfn
     * 源文件名
     * @param opfp
     * 目标文件路径
     * @param opfn
     * 目标文件名
     */
    public ZIPImage(String ipfp, String ipfn, String opfp, String opfn) {
        outPutFilePath = opfp;
        inPutFilePath = ipfp;
        inPutFileName = ipfn;
        autoBuildFileName = true;
        outPutFileName = opfn;
    }

    /**
     *
     * @param ipfp
     * 源文件夹路径
     * @param ipfn
     * 源文件名
     * @param opfp
     * 目标文件路径
     * @param opfn
     * 目标文件名
     * @param aBFN
     * 是否自动生成目标文件名
     */
    public ZIPImage(String ipfp, String ipfn, String opfp, String opfn, boolean aBFN) {
        outPutFilePath = opfp;
        inPutFilePath = ipfp;
        inPutFileName = ipfn;
        autoBuildFileName = aBFN;
        outPutFileName = opfn;
    }

    public boolean isAutoBuildFileName() {
        return autoBuildFileName;
    }

    public void setAutoBuildFileName(boolean autoBuildFileName) {
        this.autoBuildFileName = autoBuildFileName;
    }

    public String getInPutFilePath() {
        return inPutFilePath;
    }

    public void setInPutFilePath(String inPutFilePath) {
        this.inPutFilePath = inPutFilePath;
    }

    public String getOutPutFileName() {
        return outPutFileName;
    }

    public void setOutPutFileName(String outPutFileName) {
        this.outPutFileName = outPutFileName;
    }

    public String getOutPutFilePath() {
        return outPutFilePath;
    }

    public void setOutPutFilePath(String outPutFilePath) {
        this.outPutFilePath = outPutFilePath;
    }

    public int getOutPutFileHeight() {
        return outPutFileHeight;
    }

    public void setOutPutFileHeight(int outPutFileHeight) {
        this.outPutFileHeight = outPutFileHeight;
    }

    public int getOutPutFileWidth() {
        return outPutFileWidth;
    }

    public void setOutPutFileWidth(int outPutFileWidth) {
        this.outPutFileWidth = outPutFileWidth;
    }

    public boolean isScaleZoom() {
        return isScaleZoom;
    }

    public void setScaleZoom(boolean isScaleZoom) {
        this.isScaleZoom = isScaleZoom;
    }

    public String getInPutFileName() {
        return inPutFileName;
    }

    public void setInPutFileName(String inPutFileName) {
        this.inPutFileName = inPutFileName;
    }
}
