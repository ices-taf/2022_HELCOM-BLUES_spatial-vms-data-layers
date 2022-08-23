# Request


## Anonimity considerations

In order to protect the anonimity of fishing vessels the values of certain attributes are not provided
directly in the case there are less than 3 fishing vessels present in that cell, and are instead given
an value 'NA'.  In order to allow time series and maps to be created for these sensitive attributes three
other values are provided for all cells, these are:

* x_cat: a character description of a range in which the attribute value falls into
* x_cat_low: the numeric lower bound of this category
* x_cat_high: the numeric upper bound of this category

where 'x' is the name of the attribute. The categories are calculated per year and are consistent accross years and quarters. THis
can be thought of as provideding the colour grouping of a cell if plotted on a map, where the map scale is
consistent accross years and quarters but with a seperate scale for each gear and attribute.  The scales
or categories are calculated simply by splitting the range of the attribute values into 10 equally spaced
bins, for example if the range of the data is from 5 to 25, the bins would be (5-7, 7-9, 9-11, ..., 23-25).

The attributes considered sensitive are:

* Total Weight
* Total value
* Kw Fishing Hours
* Fishing hour


## a. All gear types: effort, especially need information on static gears to be included, i.e. FYK, GTR, GNS, LLS, FPO per month or quarter (minimum) of 2016-2022

### Temporal resolution:

* year (2016-2021)
* quarter

### spatial resolution:

* c-square

### Gear groups, e.g. (following level 3 of EU-MAP 2021/1167 table 5):

* Dredges (DRB),
* Bottom trawls (OTB, OTT, PTB, TBN, TBS),
* Pelagic trawls (OTM, PTM),
* Longlines (LL, LLS, LLD, LX),
* Traps (FPO, FYK, FPN)
* Nets (GNS, GTR, GND, GTN)
* Demersal seines (SDN, SSC)

### Dataset

* Effort in kW Fishinghours

### Anonimity

kW Fishinghours are subject to anonimity considerations.

## b.i. Intensity of mobile bottom contacting gears

### Temporal resolution:

* year (2016-2021)
* quarter

### spatial resolution:

* c-square

### Gear groups, only mobile bottom contacting gears:

* Total
* Dredge (DRB)
* Demersal seine (SDN, SSC)
* Otter trawl (OTB, OTT, PTB, TBN, TBS)

Benthis Metiers
* OT_CRU
* OT_DMF
* OT_MIX
* OT_MIX_CRU
* OT_MIX_DMF_BEN
* OT_MIX_DMF_PEL
* OT_MIX_CRU_DMF
* OT_SPF
* TBB_CRU
* TBB_DMF
* DRB_MOL
* SDN_DMF

### Dataset:

* Surface area in km2 (swept area)
* Surface SAR
* Subsurface area in km2 (swept area)
* Subsurface SAR
* Total weight
* Total value
* kW fishing hours
* Fishing hours

### Anonimity

Surface and subsurface area impacted, surface and subsurface SAR are not subject to anonimity constraints.

Total weight, Total value, kW fishing hours and Fishing hours are subject to anonimity considerations.


## b. Iii Provide the footprint of the grid cells that contain 90% of the highest fishing intensity of total fishing effort in the region. The resulting area or footprint can be defined as the core fishing grounds (or the smallest area that comprises 90% of the total swept area).

### Temporal resolution:

* year (2016-2021)
* quarter

### spatial resolution:

* c-square

### Gear groups, only mobile bottom contacting gears:

* All mobile bottom contacting gears.

### Dataset:

None, only c-squares in the footprint are provided.

### Anonymity:

No issues with anonymity

## b.iv The areal fraction per grid cell where 100% of the swept area occurs (alternatively fraction per grid cell without trawling)

### Temporal resolution:

* year (2016-2021)
* quarter

### spatial resolution:

* c-square

### Gear groups, only mobile bottom contacting gears:

* All mobile bottom contacting gears.

### Layers:

max_fraction_fished

### Anonymity:

max_fraction_fished is not subject to anonimity considerations.

### details

As data is provided to ICES at the c-square level, it is not possible to provide information at the sub c-sqaure level
therefore only the maximum fraction fished can be provided.

There are methods for modelling the fraction fished investigated by the ICES WGSFD. In addition, plans are being developed to request the fraction of substrate trawled by csquare in future data calls.

## Notes on shapefile feild names

since shape files have a restriction that feild names can only be 10 characters long, the following appreviations have been made:

 * sur = surface
 * subsur = subsurface
 * sur_sar = surface_sar
 * subsur_sar = subsurface_sar

 * kwfhr = kw_fishinghours
 * kwfhr_c = kw_fishinghours_cat
 * kwfhr_cl = kw_fishinghours_cat_low
 * kwfhr_ch = kw_fishinghours_cat_high

 * fhr = fishing_hours
 * fhr_c = fishing_hours_cat
 * fhr_cl = fishing_hours_cat_low
 * fhr_ch = fishing_hours_cat_high

 * totwt = totweight
 * totwt_c = totweight_cat
 * totwt_cl = totweight_cat_low
 * totwt_ch = totweight_cat_high

 * totval = totvalue
 * totval_c = totvalue_cat
 * totval_cl = totvalue_cat_low
 * totval_ch = totvalue_cat_high

 * max_frac = max_fraction_trawled
