package com.sun3d.why.model.extmodel;

/**
 * Created by yujinbing on 2015/5/7.
 */
public class StaticServer {

    private String staticServerUrl;

    private String platformDataUrl;
    
    private String chinaServerUrl;
    
    private String chinaPlatformDataUrl;

    private String appVersionNo;

    private String appVersionDescription;

    private String appIosUrl;

    private String appAndroidUrl;

    private String sentinelPool;

    private String activeMqFailover;

    private String syncServerUrl;

    private boolean syncServerState;
    
    private String aliImgUrl;
    
    private String cityInfo;

    public String getAppIosUrl() {
        return appIosUrl;
    }

    public void setAppIosUrl(String appIosUrl) {
        this.appIosUrl = appIosUrl;
    }

    public String getAppAndroidUrl() {
        return appAndroidUrl;
    }

    public void setAppAndroidUrl(String appAndroidUrl) {
        this.appAndroidUrl = appAndroidUrl;
    }

    public String getAppVersionDescription() {
        return appVersionDescription;
    }

    public void setAppVersionDescription(String appVersionDescription) {
        this.appVersionDescription = appVersionDescription;
    }

    public String getAppVersionNo() {
        return appVersionNo;
    }

    public void setAppVersionNo(String appVersionNo) {
        this.appVersionNo = appVersionNo;
    }

    public String getActiveMqFailover() {
        return activeMqFailover;
    }

    public void setActiveMqFailover(String activeMqFailover) {
        this.activeMqFailover = activeMqFailover;
    }

    public String getSentinelPool() {
        return sentinelPool;
    }

    public void setSentinelPool(String sentinelPool) {
        this.sentinelPool = sentinelPool;
    }

    public String getStaticServerUrl() {
        return staticServerUrl;
    }

    public void setStaticServerUrl(String staticServerUrl) {
        this.staticServerUrl = staticServerUrl;
    }

    public String getSyncServerUrl() {
        return syncServerUrl;
    }

    public void setSyncServerUrl(String syncServerUrl) {
        this.syncServerUrl = syncServerUrl;
    }

    public boolean isSyncServerState() {
        return syncServerState;
    }

    public void setSyncServerState(boolean syncServerState) {
        this.syncServerState = syncServerState;
    }

	public String getPlatformDataUrl() {
		return platformDataUrl;
	}

	public void setPlatformDataUrl(String platformDataUrl) {
		this.platformDataUrl = platformDataUrl;
	}

	public String getAliImgUrl() {
		return aliImgUrl;
	}

	public void setAliImgUrl(String aliImgUrl) {
		this.aliImgUrl = aliImgUrl;
	}

	public String getCityInfo() {
		return cityInfo;
	}

	public void setCityInfo(String cityInfo) {
		this.cityInfo = cityInfo;
	}

	public String getChinaServerUrl() {
		return chinaServerUrl;
	}

	public void setChinaServerUrl(String chinaServerUrl) {
		this.chinaServerUrl = chinaServerUrl;
	}

	public String getChinaPlatformDataUrl() {
		return chinaPlatformDataUrl;
	}

	public void setChinaPlatformDataUrl(String chinaPlatformDataUrl) {
		this.chinaPlatformDataUrl = chinaPlatformDataUrl;
	}
    
}
