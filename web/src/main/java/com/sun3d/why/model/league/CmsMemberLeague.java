package com.sun3d.why.model.league;

public class CmsMemberLeague{
    private String leagueId;

    private String memberId;

    public String getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(String leagueId) {
        this.leagueId = leagueId == null ? null : leagueId.trim();
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }
}