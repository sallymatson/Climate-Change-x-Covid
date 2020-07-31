# Climate Change and Covid-19
Through the American Institute of Math's Climate Research Network (AIM CRN) we participated in a summer school on modeling & the covid-19 epidemic. We researched the impact of the epidemic on NO2 emissions (often used as a proxy for CO2 due to their short lifetime in the atmosphere and daily availability.)

## Running the code
To quickly get up to speed with the code, clone the repository and then knit the `code_walkthrough.Rmd` file. This should explain how to run all of the data processing & analysis in a straightforward manner. 

## Data
We used [daily gridded NO2 data from OMI/Aura](https://disc.gsfc.nasa.gov/datasets/OMNO2d_003/summary?keywords=OMNO2d), accessed through GES-DISC. The data for Jan 1 2015 - July 18 2020 was ~ 28GB. If you want to simply use the aggregated info from Jan 1 2015 - July 18 2020, you can simply use the files we've included here and not worry about downloading the data youself. 

If you want to do different analysis (ex. include more countries) or include more up to date info, you will need to download the files and rerun the analysis (see `code_walkthrough.Rmd` for how to run the processing/aggregation.

### Download data from GES DISC
- Navigate to the correct [GES-DISC page](https://disc.gsfc.nasa.gov/datasets/OMNO2d_003/summary?keywords=OMNO2d) and click "Subset/Get Data." Then, choose what data you would like to download.
- Click "Get Data" at the bottom of the popup and click "Download Links List" on the next page. Save this wherever you want the data to live. 
- Follow the "Instructions for downloading" to the right of the "Download Links List" button. A few notes:
    - I recommend following the instructions for [curl](https://disc.gsfc.nasa.gov/data-access#mac_linux_curl)
    - For step 5 on these instructions, you are downloading multiple files so you need to skip this step and follow the directions in the next line for downloading multiple files. (`cat <LINKSLISTFILENAME.txt> | tr -d '\r' | xargs -n 1 curl -LJO -n -c ~/.urs_cookies -b ~/.urs_cookies`)
    - If it's not working, make sure that you are logged in to GES-DISC/Earthdata and the account is properly linked. 
    
### Setting up on a server
For the AIM summer school we used a GCP server in order to run the data aggregation. For easy setup, see [this tutorial](https://grantmcdermott.com/2017/05/30/rstudio-server-compute-engine/). Be super cognizant of the **persistent disk** size, which needs to be big enough to store all of the datafiles!! If you need to increase it retroactively follow [this](https://cloud.google.com/compute/docs/disks/add-persistent-disk#resize_pd) tutorial. 
