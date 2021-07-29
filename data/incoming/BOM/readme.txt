
st,009091,09  ,INNER DOLPHIN PYLON                     ,08/1999,       ,-31.9889, 115.8311,GPS            ,WA ,   0.0,      ,95620,    ,    ,   ,   ,   ,   ,   ,   ,#
st,009192,09  ,FREMANTLE                               ,01/1983,       ,-32.0533, 115.7647,GPS            ,WA ,  15.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,009887,09A ,MANDURAH                                ,01/1987,10/2001,-32.5211, 115.7500,GPS            ,WA ,  21.0,  22.0,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,009977,09A ,MANDURAH                                ,10/2001,       ,-32.5219, 115.7119,GPS            ,WA ,   3.0,   3.5,94605,    ,    ,   ,   ,   ,   ,   ,   ,#
st,023034,23A ,ADELAIDE AIRPORT                        ,02/1955,       ,-34.9524, 138.5196,GPS            ,SA ,   2.0,   8.2,94672,    ,    ,   ,   ,   ,   ,   ,   ,#
st,023131,23C ,HINDMARSH ISLAND (MUNDOO BARRAGE)       ,01/1987,       ,-35.5355, 138.9010,GPS            ,SA ,   4.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,023718,23C ,GOOLWA COUNCIL DEPOT                    ,01/1861,       ,-35.4984, 138.7657,GPS            ,SA ,   5.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,023754,23C ,YANKALILLA                              ,01/1892,       ,-35.4581, 138.3501,GPS            ,SA ,  45.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,023804,23C ,VICTOR HARBOR (ENCOUNTER BAY)           ,03/2001,       ,-35.5544, 138.5997,GPS            ,SA ,   8.0,      ,95811,    ,    ,   ,   ,   ,   ,   ,   ,#
st,023825,23C ,GOOLWA BARRAGE                          ,01/1964,       ,-35.5288, 138.8067,GPS            ,SA ,   1.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,023894,23C ,HINDMARSH ISLAND AWS                    ,01/2003,       ,-35.5194, 138.8177,GPS            ,SA ,  11.0,  11.5,94677,    ,    ,   ,   ,   ,   ,   ,   ,#
st,024518,24B ,MENINGIE                                ,01/1864,       ,-35.6902, 139.3375,GPS            ,SA ,   3.0,   4.0,95814,    ,    ,   ,   ,   ,   ,   ,   ,#
st,024539,24B ,NARRUNG (YALKURI)                       ,06/1920,       ,-35.5949, 139.1296,GPS            ,SA ,   9.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,024577,24B ,MENINGIE (EGRETTA)                      ,09/1989,       ,-35.7344, 139.2675,GPS            ,SA ,   5.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,024584,24B ,MURRAY BRIDGE (PALLAMANA AERODROME)     ,02/2006,       ,-35.0650, 139.2273,GPS            ,SA ,  45.0,  45.5,95818,    ,    ,   ,   ,   ,   ,   ,   ,#
st,025529,25B ,MENINGIE (MILL PARK)                    ,06/1958,       ,-35.8095, 139.4747,GPS            ,SA ,  10.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,025557,25B ,KEITH (MUNKORA)                         ,07/2001,       ,-36.1058, 140.3273,GPS            ,SA ,  27.0,  27.5,95815,    ,    ,   ,   ,   ,   ,   ,   ,#
st,026049,26  ,POLICEMAN POINT                         ,11/1968,10/2015,-36.0582, 139.5913,GPS            ,SA ,   4.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,026065,26  ,SALT CREEK (PITLOCHRY OUTSTATION 1)     ,11/1968,       ,-36.2789, 139.8426,GPS            ,SA ,  25.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,026083,26  ,SALT CREEK (PITLOCHRY HOMESTEAD)        ,01/1974,       ,-36.2333, 139.8491,GPS            ,SA ,  28.0,      ,     ,    ,    ,   ,   ,   ,   ,   ,   ,#
st,026095,26  ,CAPE JAFFA (THE LIMESTONE)              ,03/1991,       ,-36.9655, 139.7164,GPS            ,SA ,  17.0,  18.0,94813,    ,    ,   ,   ,   ,   ,   ,   ,#
st,026100,26  ,PADTHAWAY SOUTH                         ,05/2000,       ,-36.6539, 140.5212,GPS            ,SA ,  37.0,      ,95823,    ,    ,   ,   ,   ,   ,   ,   ,#



NOTES FOR DC02D COMPLETED ON 08/01/2021
____________________________________________________________________________________________
____________________________________________________________________________________________

DATA FILE



Byte Location , Byte Size  , Explanation
--------------------------------------------------------------------------------------------


1-2           ,2           , Record identifier - dc
4-9           ,6           , Bureau of Meteorology Station Number.
11-20         ,10          , Year month day in YYYY,MM,DD format.
22-26         ,5           , *--- Global Solar Exposure at location - derived from satellite data in MJ.m-2.
28            ,1           , * Quality of Global Solar Exposure - derived from satellite data value.
30-35         ,6           , Precipitation in the 24 hours before 9am (local time). In mm.
37            ,1           , * Quality of precipitation value.
39-40         ,2           , Number of days of rain within the days of accumulation.
42-43         ,2           , Accumulated number of days over which the precipitation was measured.
45-49         ,5           , Maximum temperature in 24 hours after 9am (local time). In Degrees C.
51            ,1           , * Quality of maximum temperature in 24 hours after 9am (local time).
53-54         ,2           , Days of accumulation of maximum temperature.
56-60         ,5           , Minimum temperature in 24 hours before 9am (local time). In Degrees C.
62            ,1           , * Quality of minimum temperature in 24 hours before 9am (local time).
64-65         ,2           , Days of accumulation of minimum temperature.
67-71         ,5           , Air temperature observation at 00 hours Local Time. In Degrees C.
73            ,1           , * Quality of air temperature observation at 00 hours Local Time.
75-79         ,5           , Air temperature observation at 03 hours Local Time. In Degrees C.
81            ,1           , * Quality of air temperature observation at 03 hours Local Time.
83-87         ,5           , Air temperature observation at 06 hours Local Time. In Degrees C.
89            ,1           , * Quality of air temperature observation at 06 hours Local Time.
91-95         ,5           , Air temperature observation at 09 hours Local Time. In Degrees C.
97            ,1           , * Quality of air temperature observation at 09 hours Local Time.
99-103        ,5           , Air temperature observation at 12 hours Local Time. In Degrees C.
105           ,1           , * Quality of air temperature observation at 12 hours Local Time.
107-111       ,5           , Air temperature observation at 15 hours Local Time. In Degrees C.
113           ,1           , * Quality of air temperature observation at 15 hours Local Time.
115-119       ,5           , Air temperature observation at 18 hours Local Time. In Degrees C.
121           ,1           , * Quality of air temperature observation at 18 hours Local Time.
123-127       ,5           , Air temperature observation at 21 hours Local Time. In Degrees C.
129           ,1           , * Quality of air temperature observation at 21 hours Local Time.
131-133       ,3           , -*- Relative humidity for observation at 00 hours Local Time. In percentage %.
135           ,1           , * Quality of relative humidity for observation at 00 hours Local Time.
137-139       ,3           , -*- Relative humidity for observation at 03 hours Local Time. In percentage %.
141           ,1           , * Quality of relative humidity for observation at 03 hours Local Time.
143-145       ,3           , -*- Relative humidity for observation at 06 hours Local Time. In percentage %.
147           ,1           , * Quality of relative humidity for observation at 06 hours Local Time.
149-151       ,3           , -*- Relative humidity for observation at 09 hours Local Time. In percentage %.
153           ,1           , * Quality of relative humidity for observation at 09 hours Local Time.
155-157       ,3           , -*- Relative humidity for observation at 12 hours Local Time. In percentage %.
159           ,1           , * Quality of relative humidity for observation at 12 hours Local Time.
161-163       ,3           , -*- Relative humidity for observation at 15 hours Local Time. In percentage %.
165           ,1           , * Quality of relative humidity for observation at 15 hours Local Time.
167-169       ,3           , -*- Relative humidity for observation at 18 hours Local Time. In percentage %.
171           ,1           , * Quality of relative humidity for observation at 18 hours Local Time.
173-175       ,3           , -*- Relative humidity for observation at 21 hours Local Time. In percentage %.
177           ,1           , * Quality of relative humidity for observation at 21 hours Local Time.
179-183       ,5           , ***- Speed of maximum wind gust in km/h.
185           ,1           , * Quality of maximum gust speed.
187-191       ,5           , ***- Direction of maximum wind gust in degrees.
193           ,1           , * Quality of maximum gust direction.
195-198       ,4           , ***- Time of maximum wind gust in HHMI 24 hour mode.
200           ,1           , * Quality of maximum wind gust time.
202-206       ,5           , ***- Wind speed at 00 hours Local Time, measured in km/h.
208           ,1           , * Quality of wind speed at 00 hours Local Time.
210-214       ,5           , ***- Wind speed at 03 hours Local Time, measured in km/h.
216           ,1           , * Quality of wind speed at 03 hours Local Time.
218-222       ,5           , ***- Wind speed at 06 hours Local Time, measured in km/h.
224           ,1           , * Quality of wind speed at 06 hours Local Time.
226-230       ,5           , ***- Wind speed at 09 hours Local Time, measured in km/h.
232           ,1           , * Quality of wind speed at 09 hours Local Time.
234-238       ,5           , ***- Wind speed at 12 hours Local Time, measured in km/h.
240           ,1           , * Quality of wind speed at 12 hours Local Time.
242-246       ,5           , ***- Wind speed at 15 hours Local Time, measured in km/h.
248           ,1           , * Quality of wind speed at 15 hours Local Time.
250-254       ,5           , ***- Wind speed at 18 hours Local Time, measured in km/h.
256           ,1           , * Quality of wind speed at 18 hours Local Time.
258-262       ,5           , ***- Wind speed at 21 hours Local Time, measured in km/h.
264           ,1           , * Quality of wind speed at 21 hours Local Time.
266-270       ,5           , ***- Wind direction at 00 hours Local Time, measured in degrees.
272           ,1           , * Quality of wind direction at 00 hours Local Time.
274-278       ,5           , ***- Wind direction at 03 hours Local Time, measured in degrees.
280           ,1           , * Quality of wind direction at 03 hours Local Time.
282-286       ,5           , ***- Wind direction at 06 hours Local Time, measured in degrees.
288           ,1           , * Quality of wind direction at 06 hours Local Time.
290-294       ,5           , ***- Wind direction at 09 hours Local Time, measured in degrees.
296           ,1           , * Quality of wind direction at 09 hours Local Time.
298-302       ,5           , ***- Wind direction at 12 hours Local Time, measured in degrees.
304           ,1           , * Quality of wind direction at 12 hours Local Time.
306-310       ,5           , ***- Wind direction at 15 hours Local Time, measured in degrees.
312           ,1           , * Quality of wind direction at 15 hours Local Time.
314-318       ,5           , ***- Wind direction at 18 hours Local Time, measured in degrees.
320           ,1           , * Quality of wind direction at 18 hours Local Time.
322-326       ,5           , ***- Wind direction at 21 hours Local Time, measured in degrees.
328           ,1           , * Quality of wind direction at 21 hours Local Time.
330           ,1           , Total cloud amount at 00 hours Local Time, in eighths.
332           ,1           , * Quality of total cloud amount at 00 hours Local Time.
334           ,1           , Total cloud amount at 03 hours Local Time, in eighths.
336           ,1           , * Quality of total cloud amount at 03 hours Local Time.
338           ,1           , Total cloud amount at 06 hours Local Time, in eighths.
340           ,1           , * Quality of total cloud amount at 06 hours Local Time.
342           ,1           , Total cloud amount at 09 hours Local Time, in eighths.
344           ,1           , * Quality of total cloud amount at 09 hours Local Time.
346           ,1           , Total cloud amount at 12 hours Local Time, in eighths.
348           ,1           , * Quality of total cloud amount at 12 hours Local Time.
350           ,1           , Total cloud amount at 15 hours Local Time, in eighths.
352           ,1           , * Quality of total cloud amount at 15 hours Local Time.
354           ,1           , Total cloud amount at 18 hours Local Time, in eighths.
356           ,1           , * Quality of total cloud amount at 18 hours Local Time.
358           ,1           , Total cloud amount at 21 hours Local Time, in eighths.
360           ,1           , * Quality of total cloud amount at 21 hours Local Time.
362           ,1           , # symbol, end of record indicator.




ACCUMULATED REPORTS
___________________

Daily elements are reported at 9am, however many Australian observers do
not report over a weekend or holiday. In this case they may accumulate rainfall
and other elements such as maximum temperature. Thus the rainfall total
reported on a Monday morning may be the total since the previous Friday, not
just for the last 24 hours. Similarly, the maximum temperature may be the
highest over a period of 2 or 3 days. Where this happens, the 'days of
accumulation' field gives the number of days involved.




-*- MOISTURE EQUATIONS
______________________

The following formulas have been used: 

Vapour pressure = exp (1.8096 + (17.269425 * Dew_Point)/(237.3 + Dew_Point))

Saturated Vapour pressure =  exp (1.8096 + (17.269425 * Air_Temperature)/(237.3 + Air_Temperature))

Relative Humidity = Vapour pressure / Saturated vapour pressure * 100

Relative humidity (RH) is obtained either from measurements by an electronic relative humidity sensor or derived 
via complex equations from wet and dry bulb temperature observations. There can be slight differences between RH 
values measured directly by a relative humidity sensor and those derived using equations. Typically these 
differences are less than 1%. The uncertainty associated with RH data increases at the extremes. That is, in 
very dry air as RH approaches 0%, and in very humid conditions as RH approaches 100%. There are some occasions 
when reported RH values may slightly exceed 100%. In these instances you should consider the value to be 100%.




* QUALITY FLAG DESCRIPTIONS
___________________________

Y: quality controlled and acceptable
N: not quality controlled
W: quality controlled and considered wrong
S: quality controlled and considered suspect
I: quality controlled and inconsistent with other known information
X: no quality information available




***- WIND MEASUREMENTS
______________________

1. The Bureau's wind measurements are designed to satisfy weather and climate monitoring needs.
The Bureau's current uncertainty tolerances for wind speed measurements are +/- 10% of the 
wind speed for wind speeds greater than 10 m/s and +/- 1 m/s for wind speeds at or below 10 m/s.
As equipment is modernised at observing sites, the Bureau's continuous improvement requirement
is to ensure that no change in equipment or algorithm results in wind speed measurements with
a higher uncertainty, and where possible decreases uncertainty.
2. In 2010, with the incorporation of new monitoring equipment with improved algorithms to
convert raw outputs into wind speed, a step change downwards in the wind speed measurements
has occurred of the order of 0.5 m/s at some sites. Investigations have not lead to any evidence
that the wind speed measurements using the Telvent AWS are outside the Bureau's uncertainty
tolerance.  We are confident that the new measurements provide a better estimate of the true
wind speed, and may ultimately result in revised and improved uncertainty tolerances for Bureau
wind speed measurements of both the past and future. We are now investigating ways to apply this
knowledge to the past wind record.




*--- RADIATION
______________

Radiation quantities are generally expressed in terms of either irradiance or radiant
exposure. Irradiance is a measure of the rate of energy received per unit area, and has SI
units of Watts per square metre (W.m-2), where 1 Watt (W) is equal to 1 Joule (J) per second.
Radiant exposure is a time integral (or sum) of irradiance. Thus a 1-minute radiant exposure
is a measure of the energy received per square metre over a period of 1 minute. Therefore a 1
minute radiant exposure = mean irradiance (W.m-2) x 60 (s), and has units of Joules per
square metre (J.m-2). A half-hour radiant exposure would then be the sum of 30 one-minute (or
1800 one second) radiant exposures. For example: a mean irradiance of 500 W.m-2 over 1 minute
yields a radiant exposure of 30000 J.m-2 or 30 kJ.m-2.

Measurements of surface-based radiation are made according to Solar Time. Solar time is different to local time
and is based on the idea that when the sun reaches its highest point in the sky,
it is noon.(http://en.wikipedia.org/wiki/Solar_time). Current data are 
measured according to True Solar Time (according to the actual motion of the Sun), while 
historic data used Mean Solar Time (an approximation of the motion of the Sun that can vary as 
much as 16 minutes).

A solar position calculator can be found at http://www.ga.gov.au/geodesy/astro/smpos.jsp

Solar radiation definitions can be found at http://www.bom.gov.au/sat/glossary.shtml

Uncertainties are used instead of quality flags with the exception of satellite derived data.
When using data that is a combination of network and satellite data ignore quality flags where
uncertainties exist. Uncertainties are in the same units as the data values.

GLOBAL SOLAR EXPOSURE
Global solar exposure is the total amount of solar energy falling on a horizontal surface of 
unit area. The daily global solar exposure is the total solar energy for a day. Typical 
values for daily global solar exposure range 1 to 35 MJ/m2 (megajoules per square metre).
The values are usually highest in clear sky conditions during the summer, and 
lowest during winter or very cloudy days.

Combination refers to satellite derived data being used where ground network data is not available.
If ground network data is available then this is provided, otherwise where possible satellite
derived data is given instead.

SATELLITE DERIVED SOLAR EXPOSURE DATA
Global solar exposure data is not measured at the site. Instead, it is derived from satellite
data for the co-ordinates at which the station is currently located.Solar exposure data have been 
derived from satellite imagery processed by the Bureau of Meteorology from the Geostationary Meteorological
Satellites GMS-4, GMS-5, and MTSAT-1R of the Japan Meteorological Agency, and the USA's National
Oceanic & Atmospheric Administration (NOAA) GOES-9 satellite.

Accuracies of Satellite Estimates:
The Bureau of Meteorology has recently completed upgrading the process of estimating daily 
global solar exposure from satellite imagery. The historical data have been reprocessed and,
compared to the data they replaced, generally provide improved accuracy, fewer missing values,
and finer spatial resolution. The data from the ground network of solar exposure monitoring sites
are used to tune the output of the model. Each month a linear regression is performed on the satellite
and surface data, generating a mean country-wide bias as a linear function of exposure which is used to
adjust model output. For all data combined, the mean absolute value of the satellite-surface difference
cycles from about 0.8 MJ.m-2 in winter to about 1.5 MJ.m-2 in summer.

The satellite method of determining radiant exposure from visible images from GMS5 was tested
using pyranometer data from 9 network sites from July and August 1997. On average the model
agreed with the measurements to within 0.17% (around 40 kJ.m-2 on a typical clear day) and
the majority of measurements agreed within 6% (around 1500 kJ.m-2 on a typical clear day).
The satellite method tends to over estimate the radiant exposure in wet, cloudy conditions
and to under estimate it in dry conditions. To put these numbers into perspective, we can
imagine using the measured global solar radiant exposure at a pyranometer location to
estimate the global solar radiant exposure at a point some distance away. The accuracy of the
estimation will decrease as we move away from the radiation station. The further we go, the
less reliable the estimate will be. In a typical agricultural area such as that around Wagga
Wagga, the satellite becomes more accurate than using surface station values at a distance
typically 40 km from a pyranometer.


DIFFUSE SOLAR EXPOSURE
Diffuse solar exposure is the total amount of solar energy falling on a horizontal surface
from all parts of the sky apart from the direct sun. The daily diffuse solar exposure is the
total diffuse solar energy for this period. Typical values for daily diffuse solar exposure
range from 1000 to 20000 kJ.m-2 (kilo-Joule per metres squared). The values are usually
highest during cloudy conditions, and lowest during clear sky days. The diffuse exposure is
always less than or equal to the global exposures for the same period.

DIRECT SOLAR EXPOSURE
Direct solar exposure is the total amount of solar energy arriving at the Earth's surface from
the Sun's direct beam, on a plane perpendicular to the beam, and is usually measured by
pyrheliometer mounted on a solar tracker. The tracker ensures that the Sun's beam is always
directed into the instruments field of view during the day. The pyrheliometer has a field of
view of 5. In order to use this measurement for comparison with global and diffuse global
exposures irradiances, it is necessary to obtain the horizontal component of the direct solar
exposure irradiance. This is achieved by multiplying the direct solar exposure irradiance by
the cosine of the Sun's zenith angle.

DOWNWARD INFRA-RED (TERRESTRIAL) IRRADIANCE
All matter with a temperature greater than 0 K (Kelvin) emits electromagnetic energy; the
amount of energy and wavelengths at which the energy is emitted are dependent on the
temperature of the body. The higher the temperature of the body, the greater the magnitude of
the energy radiated and the shorter the wavelengths at which that peak energy is radiated. A
body will radiate energy over a range of wavelengths, called the body's radiation spectrum (a
subset of the complete electromagnetic spectrum). Most of the Sun's spectrum lies in the
wavelength range of 0.25 - 4.0  m, the so-called short wave range. Downward infrared
irradiance is a measurement of the irradiance arriving on a horizontal plane at the Earth's
surface, for wavelengths in the range 4 - 100  m (the wavelength emitted by atmospheric
gasses and aerosols). It is related to a representative (or effective radiative)
temperature of the Earth's atmosphere by the Stefan-Boltzmann Law:

E = s T^4 

Where: E = irradiance measured. [Wm^-2]
s = Stefan-Boltzmann constant. [5.67 x 10^-8 Wm^-2deg^-4 ] 
T = representative atmospheric temperature. [K]

Consequently, this quantity will continue to have a positive value, even at night time. It can
be measured using an Eppley PIR pyrgeometer. As in the case of diffuse solar irradiance
measurement, it is required that this instrument is shaded from the direct beam of the Sun
during the day, since the Sun's beam can heat the pyrgeometer dome and contribute to error in
the measurement. Accordingly, the pyrgeometer is mounted on a tracker. The representative
temperature is dependent on a number of factors, but typically larger values are recorded
when middle to low level clouds cover the sky than those recorded during clear sky episodes.

Time base used : Solar





GAPS AND MISSING DATA
_____________________

Very few sites have a complete unbroken record of climate information. A site
may have been closed, reopened, upgraded to a full weather site or downgraded
to a rainfall only site during its existence causing breaks in the record for
some or all elements. Some gaps may be for one element due to a damaged
instrument, others may be for all elements due to the absence or illness of
an observer.




INSTUMENTS AND OBSERVATIONAL PRACTICES
______________________________________

Historically a nearby site (within about 1 mile in earlier days) may have used the same 
site number.  There may have been changes in instrumentation and/or observing practices
over the period included in a dataset, which may have an effect on the long-term record.
In recent years many sites have had observers replaced by Automatic Weather Stations,
either completely or at certain times of the day.  




TIME
____

For a part of the year some Australian States adopt Daylight Savings Time (DST), and
observers continue to take observations according to the local clock.  Times provided 
with this data are Local Time, unless otherwise noted. 

Care needs to be taken when comparing values from year to year or month to month, because for
some elements the effect of one hour can be marked, for example air temperature often rises 
sharply between 8am and 9am.

Daylight Savings has been used in many Australian states since 1973. The
changeovers occur almost always in October and March, but exact dates vary
from State to State and year to year. More information can be found at:
http://www.bom.gov.au/climate/averages/tables/daysavtm.shtml




ROUNDING
________

The primary way of sending current weather information around the world is via a coded message 
known as a SYNOP.  This message only allows some measurements to be sent as rounded values.  
Once manuscript records have been sent in many of these values are typed in with greater 
precision (normally to one decimal place). This usually occurs within a few months.

If consecutive values all have a zero in the decimal place, then it is almost certain that
rounding was used earlier.  A new type of message format is progressively being introduced to
overcome this situation.




COPYRIGHT
_________

The copyright for any data is held in the Commonwealth of Australia and the purchaser
shall give acknowledgement of the source in reference to the data.  Apart from dealings
under the copyright Act, 1968, the purchaser shall not reproduce, modify or supply (by
sale or otherwise) these data without written permission.  Enquiries should be made
to the Bureau of Meteorology, PO Box 1289K, Melbourne 3001, marked to the attention of SRDS.




LIABILITY
_________

While every effort is made to supply the best data available this may not be possible
in all cases.  We do not give any warranty, nor accept any liability in relation
to the information given, except that liability (if any), that is required by law.





IF DATA IS NOT AS REQUESTED
___________________________

If the data provided are not as requested, the data will be repeated at no extra cost, 
provided that:
a) the Bureau is notified within 60 days.
b) the printout/disc/data file is returned to the Bureau for checking.
c) there has been a fault or error in providing the data.

Where there has been no fault or error of provision, the cost involved in
requested corrective action such as resending the data or providing alternative
sites will be charged for as necessary.




____________________________________________________________________________________________
____________________________________________________________________________________________

SITE DETAILS FILE

This file contains the details for the current site or are those which applied when the site
was closed.  Many sites have been moved, downgraded, upgraded etc over the years.

Byte Location , Byte Size  , Explanation
--------------------------------------------------------------------------------------------


1-2           ,2           , Record identifier - st
4-9           ,6           , Bureau of Meteorology Station Number.
11-14         ,4           , Rainfall district code
16-55         ,40          , Station Name.
57-63         ,7           , Month/Year site opened. (MM/YYYY)
65-71         ,7           , Month/Year site closed. (MM/YYYY)
73-80         ,8           , Latitude to 4 decimal places, in decimal degrees.
82-90         ,9           , Longitude to 4 decimal places, in decimal degrees.
92-106        ,15          , Method by which latitude/longitude was derived.
108-110       ,3           , State.
112-117       ,6           , Height of station above mean sea level in metres.
119-124       ,6           , Height of barometer above mean sea level in metres.
126-130       ,5           , WMO (World Meteorological Organisation) Index Number.
132-135       ,4           , First year of data supplied in data file.
137-140       ,4           , Last year of data supplied in data file.
142-144       ,3           , Percentage complete between first and last records.
146-148       ,3           , Percentage of values with quality flag 'Y'.
150-152       ,3           , Percentage of values with quality flag 'N'.
154-156       ,3           , Percentage of values with quality flag 'W'.
158-160       ,3           , Percentage of values with quality flag 'S'.
162-164       ,3           , Percentage of values with quality flag 'I'.
166           ,1           , # symbol, end of record indicator.




LATITUDES AND LONGITUDES
________________________

Latitudes and longitudes are given to 4 decimal places, but in many cases will not be
accurate to 4 decimal places.  This is because in the early days the positions of stations
were estimated from maps. Gradually the network of open stations is being checked (and
if necessary corrected) using GPS (Global Positioning System). The method used is given
in the site details file.




WMO INDEX NUMBER
________________

This is the number assigned to a site that makes international weather reports every day.
The number is not actively used in the climate archive, and only a few hundred such 
numbers are assigned at any time.  These are not perpetual but may be reassigned 
where a site no longer makes the international reports (synops); thus a particular
number cannot be regarded as unique and exclusive to any particular site.




PERCENTAGE INFORMATION
______________________

In some cases the percentage completeness will be overestimated. This will occur if the
database has incomplete information about the element being selected. In cases where several
elements are selected, rows with a least one of the elements available are considered
complete. Where only a limited amount of data is available and the percentage completeness
is less than 0.5%, an "*" has been used.

An "*" is also used if the percentage of values with a particular quality flag is non zero
and less than 0.5%.
