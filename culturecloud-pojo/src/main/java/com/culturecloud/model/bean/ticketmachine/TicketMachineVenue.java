package com.culturecloud.model.bean.ticketmachine;

public class TicketMachineVenue {

	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ticket_machine_venue.machine_code
	 * @mbggenerated  Mon Jan 09 16:36:10 CST 2017
	 */
	private String machineCode;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ticket_machine_venue.venue_id
	 * @mbggenerated  Mon Jan 09 16:36:10 CST 2017
	 */
	private String venueId;

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ticket_machine_venue.machine_code
	 * @return  the value of ticket_machine_venue.machine_code
	 * @mbggenerated  Mon Jan 09 16:36:10 CST 2017
	 */
	public String getMachineCode() {
		return machineCode;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ticket_machine_venue.machine_code
	 * @param machineCode  the value for ticket_machine_venue.machine_code
	 * @mbggenerated  Mon Jan 09 16:36:10 CST 2017
	 */
	public void setMachineCode(String machineCode) {
		this.machineCode = machineCode;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ticket_machine_venue.venue_id
	 * @return  the value of ticket_machine_venue.venue_id
	 * @mbggenerated  Mon Jan 09 16:36:10 CST 2017
	 */
	public String getVenueId() {
		return venueId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ticket_machine_venue.venue_id
	 * @param venueId  the value for ticket_machine_venue.venue_id
	 * @mbggenerated  Mon Jan 09 16:36:10 CST 2017
	 */
	public void setVenueId(String venueId) {
		this.venueId = venueId;
	}
}