package com.sun3d.why.model.extmodel;


public class BasePath {
    private  String basePath;
    private  String baseUrl;
    private String audioBaseUrl;

    public BasePath(){  }

    public String getBasePath() {
        return basePath;
    }

    public void setBasePath(String basePath) {
        this.basePath = basePath;
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getAudioBaseUrl() {
        return audioBaseUrl;
    }

    public void setAudioBaseUrl(String audioBaseUrl) {
        this.audioBaseUrl = audioBaseUrl;
    }
}
