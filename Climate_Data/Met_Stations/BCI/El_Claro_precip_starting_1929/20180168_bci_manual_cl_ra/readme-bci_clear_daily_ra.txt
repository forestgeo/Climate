Readme - bci_cl_ra_man.txt

Variable		Units		Description
Datetime					dd/mm/yyyy hh:mm
Ra				mm			Average Rainfall from all rain gauges (after QA and prorating [see discussion at bottom for a discussion on how the data are prorated])
Raw				mm			Original Average Rainfall from all rain gauges - no gap filling
Comment						Free text comments
CHK_NOTE						See description below*
CHK_FAIL						See description below*

CHK_NOTE indicates quality of record. Possible values are:
	"adjusted"		-> Value of datum adjusted or gap filled
	"bad"			-> Datum failed one or more test and should not be used
	"doubtful"		-> Datum suspect and should be used with caution
	"good"			-> Datum acceptible
	"missing"		-> Datum missing
	"nc"	  	    -> Datum not yet checked

CHK_FAIL indicates the reason that a datum failed or was adjusted. Possible values are:
	"Calibration"	-> Sensor calibration corrected
	"Persistence"	-> Variation of data below expected range
	"Prorated"		-> Prorated rainfall (see note* below for a discussion on how the data are prorated)
	"Range"			-> Datum outside of 99.9 percentile
	"Spike"			-> Short-term increase or decrease of data significantly outside normal variance range
	"Gap Fill"		-> Data estimated or supplied from another source
	
	
- The file bci_cl_ra_man.txt contains daily rainfall data collected by STRI at the BCI clearing station beginning in 1971.

- The file bci_acp_ra_1929_1971.txt contains daily rainfall data collected by the Panama Canal Authority at the BCI clearing station 
  from 1929 to 1971.

Regarding the STRI data...

- pr_ra is prorated (see the meaning below) daily rainfall total in millimeters (mm)
- man_ra is raw daily total rainfall collected with manual gauges in millimeters (mm)

Manual rainfall is collected with a National Weather Service standard type rain gauge and it is read by
a technician during most weekdays (except weekends and holidays) between 8:00 and 9:00 a.m. 
Electronically recorded tipping bucket data are made at the same location. 

At different times one, two and even three rain gauges have been used - on the late seventies an eighties there were
three rain gauges at the bci clearing. An average of the daily total rainfall from all available manual gauges is used as 
the value for manual daily rainfall.

*The tipping bucket rainfall data are used to proportionately distribute the manual rain gauge data for those days when readings were not made,
i.e. manual rainfall data is allocated according to the distribution of the tipping bucket rainfall during the same time intervals that 
the manual readings would have been made (i.e. from 9:05am on the previous day to 9:00am on the current day). 
The prorated rainfall is always exactly equal to the rainfall collected by the rain gauge.
