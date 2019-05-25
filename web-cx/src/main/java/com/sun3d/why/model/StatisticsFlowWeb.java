package com.sun3d.why.model;

public class StatisticsFlowWeb {
    private String id;

    private String date;

    private Integer pv;

    private Integer uv;

    private Integer ip;

    private String uvstr;

    private String ipstr;
    
    public StatisticsFlowWeb() {
		super();
	}

	public StatisticsFlowWeb(String id, String date, Integer pv, Integer uv,
                             Integer ip, String uvstr, String ipstr) {
		super();
		this.id = id;
		this.date = date;
		this.pv = pv;
		this.uv = uv;
		this.ip = ip;
		this.uvstr = uvstr;
		this.ipstr = ipstr;
	}

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date == null ? null : date.trim();
    }

    public Integer getPv() {
        return pv;
    }

    public void setPv(Integer pv) {
        this.pv = pv;
    }

    public Integer getUv() {
        return uv;
    }

    public void setUv(Integer uv) {
        this.uv = uv;
    }

    public Integer getIp() {
        return ip;
    }

    public void setIp(Integer ip) {
        this.ip = ip;
    }

    public String getUvstr() {
        return uvstr;
    }

    public void setUvstr(String uvstr) {
        this.uvstr = uvstr == null ? null : uvstr.trim();
    }

    public String getIpstr() {
        return ipstr;
    }

    public void setIpstr(String ipstr) {
        this.ipstr = ipstr == null ? null : ipstr.trim();
    }
}