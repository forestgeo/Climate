Variables: abbreviations, definitions, units
--------------------------------------------

<table>
<thead>
<tr class="header">
<th style="text-align: left;">Label</th>
<th style="text-align: center;">Variable</th>
<th style="text-align: left;">Units</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">cld</td>
<td style="text-align: center;">cloud cover</td>
<td style="text-align: left;">Percentage (%)</td>
</tr>
<tr class="even">
<td style="text-align: left;">dtr</td>
<td style="text-align: center;">diurnal temperature range</td>
<td style="text-align: left;">Degrees Celsius</td>
</tr>
<tr class="odd">
<td style="text-align: left;">frs</td>
<td style="text-align: center;">frost day frequency</td>
<td style="text-align: left;">Days</td>
</tr>
<tr class="even">
<td style="text-align: left;">pet</td>
<td style="text-align: center;">potential evapotranspiration</td>
<td style="text-align: left;">Millimetres per day</td>
</tr>
<tr class="odd">
<td style="text-align: left;">pre</td>
<td style="text-align: center;">precipitation</td>
<td style="text-align: left;">Millimetres per month</td>
</tr>
<tr class="even">
<td style="text-align: left;">rhm</td>
<td style="text-align: center;">relative humidity</td>
<td style="text-align: left;">Percentage (%)</td>
</tr>
<tr class="odd">
<td style="text-align: left;">ssh</td>
<td style="text-align: center;">sunshine duration</td>
<td style="text-align: left;">Hours</td>
</tr>
<tr class="even">
<td style="text-align: left;">tmp</td>
<td style="text-align: center;">daily mean temperature</td>
<td style="text-align: left;">Degrees Celsius</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tmn</td>
<td style="text-align: center;">monthly avg daily min temp</td>
<td style="text-align: left;">Degrees Celsius</td>
</tr>
<tr class="even">
<td style="text-align: left;">tmx</td>
<td style="text-align: center;">monthly avg daily max temp</td>
<td style="text-align: left;">Degrees Celsius</td>
</tr>
<tr class="odd">
<td style="text-align: left;">vap</td>
<td style="text-align: center;">vapour pressure</td>
<td style="text-align: left;">Hectopascals (hPa)</td>
</tr>
<tr class="even">
<td style="text-align: left;">wet</td>
<td style="text-align: center;">wet day frequency</td>
<td style="text-align: left;">Days</td>
</tr>
<tr class="odd">
<td style="text-align: left;">wnd</td>
<td style="text-align: center;">wind</td>
<td style="text-align: left;">Speed metres per second (m/s)</td>
</tr>
</tbody>
</table>

Background on Windows
---------------------

-   Time series data downloaded from
    <a href="http://data.ceda.ac.uk/badc/cru/data/cru_ts/" class="uri">http://data.ceda.ac.uk/badc/cru/data/cru_ts/</a>
    (you have to register for an account but the data is freely
    available)
-   CRU TS 4.03 (latest; downloaded by Bianca Gonzalez in May 2020)
-   0.5 x 0.5 degree grids
-   Monthly means from weather stations
-   1901-2018
-   Download easily using FTP transfer using File Explorer (Win 7 and
    above). Type ftp.ceda.ac.uk in the address bar in Windows Explorer,
    enter your badc account username and password, navigate to
    badc/cru/data/cru\_ts/\[etc.\] Then save the .gz files to a folder
    on your computer. (downloading nc.gz rather than .nc is much faster,
    but then needs to be decompressed, see below, so it might end up
    being the same time…). Pick the one file that has the longest span
    (1901-2016) for each variable.
-   .gz files saved in S:Maps Data.03
-   Create your own version folder in CRU to store most up to date data
    when using the brick\_CRU\_BG script  
-   Files must be decompressed from .gz to NetCDF (can be done in R or
    using 7zip – much faster in R)
-   See updated brick\_CRU\_BG script to decompress files

Example of CRU data of SCBI
---------------------------

<img src="https://github.com/forestgeo/Climate/blob/master/Gridded_Data_Products/Historical%20Climate%20Data/CRU_v4_04/CRU_all_sites_figures/TMP_CRU_plot_Smithsonian_Conservation_Biology_Institute_590.png">

Background on Mac
-----------------

-   register for an account as indicated above
    <a href="http://data.ceda.ac.uk/badc/cru/data/cru_ts/" class="uri">http://data.ceda.ac.uk/badc/cru/data/cru_ts/</a>
-   install homebrew
    <a href="https://brew.sh/" class="uri">https://brew.sh/</a>
-   to get ftp connection on mac in terminal type: brew install tnftpn
    <a href="https://osxdaily.com/2018/08/07/get-install-ftp-mac-os/" class="uri">https://osxdaily.com/2018/08/07/get-install-ftp-mac-os/</a>
-   the rest of instructions are all typed in terminal
-   type ftp in terminal to start ftp connection
-   type open ftp.ceda.ac.uk
-   when it prompts for name, write your username you used to register
    and password
-   use ls to list all directories
-   cd into badc: `cd badc`
-   cd into cru: `cd cru`
-   cd into data folder: `cd data`  
-   cd into the relevant folder: `cd cru_ts`
-   cd to most recent cru: `cd cru_ts_4.03`
-   cd into data again: `cd data`
-   cd to the directory you’re interested in of below variables: ie
    `cd cld`
-   use the ls command to list the files in the directory, ie: `ls`
-   open binary connection for file transfer by just typing `binary` in
    terminal
-   use the get command to get the file that has longest year range and
    .nc.gz end ie: `get cru_ts4.03.1901.2018.dtr.dat.nc.gz`
-   do this for all variables (finding the longest yr range)
-   .gz files saved in S:Maps Data.03
-   Create your own version folder in CRU to store most up to date data
    when using the brick\_CRU\_BG script  
-   Files must be decompressed from .gz to NetCDF (can be done in R or
    using 7zip – much faster in R)
-   See updated brick\_CRU\_BG script to decompress + process files
    other ftp commands here commands here:
    <a href="https://www.dummies.com/software/how-to-use-ftp-from-terminal-to-transfer-mac-files/" class="uri">https://www.dummies.com/software/how-to-use-ftp-from-terminal-to-transfer-mac-files/</a>

Current Scripts and Process
---------------------------

-   brickCRU\_BG.R extracts data from the .nc files at lat/long points
-   Input a .csv file containing the lat/long coordinates
-   Found in github at:
    <a href="https://github.com/forestgeo/Site-Data/blob/master/ForestGEO_site_data.csv" class="uri">https://github.com/forestgeo/Site-Data/blob/master/ForestGEO_site_data.csv</a>
-   click on “raw” on above webpage , wait for the new page to load,
    copy the address link and paste in the Rscript to load the data like
    that: read.csv(“paste\_link\_here”) (basically replace the path to
    the file by the URL)
-   brickCRU\_BG.R is original R code by Amy Bennett, updated by
    Valentine Hermann, Maria Wang, and Bianca Gonzalez
-   Output is labelled monthly means for bioclimatic variables
-   Also contains code to calculate monthly averages across all years
-   If there are missing data, open the coordinates and .nc files in
    ArcMap (use the function ‘Make NetCDF Raster Layer’ in ArcMap).
    Locate the coordinates of the nearest point with data (if you mouse
    over the point, you can see the coordinates in the toolbar on the
    lower right). Then put those coordinates back in R to extract data.

To visualize CRU data:
----------------------

-   see scripts folder here
    <a href="https://github.com/forestgeo/Climate/tree/master/scripts" class="uri">https://github.com/forestgeo/Climate/tree/master/scripts</a>
    Visualization scripts to create plots!
-   viz\_tool\_CRU\_ALL\_sites.R
    -   viz\_tool\_CRU\_ALL\_sites.R script to produce plots for CRU
        variables for ALL forest geo sites
-   viz\_tool\_CRU\_single\_site.R
    -   viz\_tool\_CRU\_single\_site.R script to produce plots for CRU
        variables for a single site

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
