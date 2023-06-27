# Copyright 2021-2023 Louis Héraut (louis.heraut@inrae.fr)*1,
#                     Éric Sauquet (eric.sauquet@inrae.fr)*1
#
# *1   INRAE, France
#
# This file is part of AEAG_toolbox R toolbox.
#
# AEAG_toolbox R toolbox is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# AEAG_toolbox R toolbox is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with AEAG_toolbox R toolbox.
# If not, see <https://www.gnu.org/licenses/>.


# Main script that regroups all command lines needed to interact with
# this toolbox. Choose your parameters before executing all the script
# (RStudio : Ctrl+Alt+R) or line by line.


#  ___         __                         _    _                
# |_ _| _ _   / _| ___  _ _  _ __   __ _ | |_ (_) ___  _ _   ___
#  | | | ' \ |  _|/ _ \| '_|| '  \ / _` ||  _|| |/ _ \| ' \ (_-<
# |___||_||_||_|  \___/|_|  |_|_|_|\__,_| \__||_|\___/|_||_|/__/ _____
# If you want to contact the author of the code you need to contact
# first Louis Héraut who is the main developer. If it is not possible,
# Éric Sauquet is the main referent at INRAE to contact.
#
# Louis Héraut : <https://github.com/super-lou>
#                <louis.heraut@inrae.fr>
#                 
# Éric Sauquet : <eric.sauquet@inrae.fr>
#
# See the 'README.md' file for more information about the utilisation
# of this toolbox.


#  ___                            
# | _ \ _ _  ___  __  ___  ___ ___
# |  _/| '_|/ _ \/ _|/ -_)(_-<(_-<
# |_|  |_|  \___/\__|\___|/__//__/ ___________________________________
## 1. REQUIREMENTS ___________________________________________________
# Explore2_toolbox path
lib_path =
    "./"

## 2. DATA DIRECTORY _________________________________________________
# Directory of Banque HYDRO data you want to use in ash\\data\\ to
# extract stations flow data. If '' is use, data will be search in
# ash\\data\\.
filedir =
    # ''
    'AEAG_selection'
    # 'RRSE'

# Name of the files that will be analysed from the data directory
# (if 'all', all the file of the directory will be chosen)
filename =
    # ''
    'all'
    c(
        # 'X0500010_HYDRO_QJM.txt'
        # 'Q0214010_HYDRO_QJM.txt',
        # 'H7833520_HYDRO_QJM.txt',
        # 'O0384010_HYDRO_QJM.txt',
        # 'O3314010_HYDRO_QJM.txt',
        # 'S2235610_HYDRO_QJM.txt',
        # 'O1484320_HYDRO_QJM.txt'
        # 'O0362510_HYDRO_QJM.txt'
        # 'A3301010_HYDRO_QJM.txt',
        # 'A4050620_HYDRO_QJM.txt'
        # '^[A]'
    )

## 3. WHAT YOU WANT TO DO ____________________________________________
# This vector regroups all the different step you want to do. For
# example if you write 'extraction', the extraction of the
# data for the station will be done. If you add also
# 'analyse', the extraction and then the trend analyse will be
# done. But if you only write, for example, 'plot', without
# having previously execute the code with 'extraction' and
# 'analyse', it will results in a failure.
#
# Options are listed below with associated results after '>' :
#
# - 'extraction' : Extraction of data and meta data tibbles
#                          about stations
#                          > 'data' 
#                          > 'df_meta'
#
# - 'climate_extraction' : Extraction of data and metadata tibbles
#                          about climate data
#                          > 'data' 
#                          > 'df_meta'
#
# - 'trend_analyse' : Trend analyses of stations data
#                             > 'df_XEx' : tibble of extracted data
#                             > 'df_Xtrend' : tibble of trend results
#
# - 'break_analyse' : Brief analysis of break data
#                             > 'df_break' : tibble of break results
#
# - 'climate_trend_analyse' : Trend analyses of the climate data
#                             > 'df_XEx' : tibble of extracted data
#                             > 'df_Xtrend' : tibble of trend results
#
# - 'serie_plot' : Plotting of flow series for stations
# - 'trend_plot' : Plotting of trend analyses of stations
# - 'break_plot' : Plotting of the break analysis
# - 'climate_trend_plot' : Plotting of trend analyses of climate data
to_do =
    c(
        # 'delete_tmp',
        # 'create_data',
        # 'extract_data'
        # 'trend_plot'
        'climate_trend_plot'
    )

mode =
    # "hydro"
    "climat"

climat_data_dir = "climat"

extract_data =
    c(
        # 'WIP'
        'AEAG_climat'
    )

AEAG_climat = 
    list(name='AEAG_climat',
         variables=c("PA", "TA", "ETPA"),
         suffix=NULL,
         expand=FALSE,
         cancel_lim=FALSE,
         simplify=FALSE)

extract_data_tmp = lapply(extract_data, get)
names(extract_data_tmp) = extract_data
extract_data = extract_data_tmp

verbose = TRUE
subverbose = FALSE

river_length =
    # NULL
    300000


## 4. ANALYSIS PARAMETERS ____________________________________________
# Periods of time to perform the trend analyses. More precisely :
# - 'periodAll' tends to represent the maximal accessible period of
#    flow data hence the start in 1800
# - 'periodSub' tends to represent the period with the most accessible
#    flow data
periodAll =
    # c('1968-01-01', '2020-12-31')
    c('1900-01-01', '2020-12-31')
periodSub =
    # NULL
    c('1968-01-01', '2020-12-31')

# Periods of time to average. More precisely :
# - 'periodRef' tends to represent the reference period of the climate
# - 'periodCur' tends to represent the current period
#    flow data
periodRef =
    # NULL
    c('1968-01-01', '1988-12-31')
periodCur =
    # NULL
    c('2000-01-01', '2020-12-31')


#    _       _                               _ 
#   /_\   __| |__ __ __ _  _ _   __  ___  __| |
#  / _ \ / _` |\ V // _` || ' \ / _|/ -_)/ _` |
# /_/ \_\\__,_| \_/ \__,_||_||_|\__|\___|\__,_| ______________________
## You still can modify this part without major risk but it can be ##
## less intuitive ##                                          

## 2. STATION SELECTION BY LIST ______________________________________
### 2.1. Selection with '.docx' file _________________________________
# Path to a '.docx' list file of station that will be analysed
DOCXlistdir = 
    ''

DOCXlistname = 
    ''
    # 'Liste-station_RRSE.docx' 

### 2.2. Selection with '.txt' file __________________________________
# Path to the '.txt' list file of station that will be analysed
# It can be generated with :
# create_selection(computer_data_path, 'dirname', 'selection.txt')
TXTlistdir =
    ''

TXTlistname = 
    ''
    # 'selection.txt'


## 3. DATA CORRECTION ________________________________________________
# Local corrections of the data
flag = data.frame(
    Code=c('O3141010',
           'O7635010',
           'O7635010',
           'O7635010',
           'O7635010'
           ),
    Date=c('1974-07-04',
           '1948-09-06',
           '1949-02-08',
           '1950-07-20',
           '1953-07-22'
           ),
    newQ=c(9.5,
               4,
               3,
               1,
               3) # /!\ Unit
)

# Name of the subdirectory in 'CARD_dir' that includes variables to
# analyse. If no subdirectory is selected, all variable files will be
# used in 'CARD_dir' (which is may be too much).
# This subdirectory can follows some rules :
# - Variable files can be rename to began with a number followed by an
#   underscore '_' to create an order in variables. For example,
#   '2_QA.R' will be analysed and plotted after '1_QMNA.R'.
# - Directory of variable files can also be created in order to make a
#   group of variable of similar event. Names should be chosen between
#   'Crue'/'Crue Nivale'/'Moyennes Eaux' and 'Étiage'. A directory can
#   also be named 'Resume' in order to not include variables in an
#   event group.
var_to_analyse_dir =
    # ''
    # 'AEAG'
    # 'MAKAHO'
    'WIP'

### 4.2. Climate variables ___________________________________________
to_analyse_climate = c(
    'PA',
    'TA',
    'ETPA'
)


## 5. STATISTICAL OPTIONS ____________________________________________
# The risk of the Mann-Kendall trend detection test
level = 0.1

# # Mode of selection of the hydrological period. Options are : 
# # - 'every' : Each month will be use one by one as a start of the
# #             hydrological year
# # - 'fixed' : Hydrological year is selected with the hydrological year
# #             noted in the variable file in 'CARD_dir'
# # - 'optimale' : Hydrological period is determined for each station by
# #                following rules listed in the next variable.
# samplePeriod_mode =
#     # 'every'
#     # 'fixed'
#     'optimale'


## 6. READING AND WRITING OF RESULTS _________________________________
### 6.1. Reading _____________________________________________________
# If you want to read results that have already been saved
read_results = FALSE

### 6.2. Writing data on RAM _________________________________________
# If you want to save on RAM all the results or not. If no option is
# selected, only the last results will be stored on RAM (because
# results are overwrites each time in order  to save place).
# Variable names stored will be :
# - 'df_Xdata' : Modified flow data for every station
# - 'df_Xmod' : Historic of modification of flow data
# - 'df_XEx' : Extracted data
# - 'df_Xtrend' : Trend results
# - 'res_Xanalyse' : List of 'df_XEx' and 'df_Xtrend'
# Otherwise, if you select 'modified_data', only 'df_Xdata' and
# 'df_Xmod' will be save under the same name with 'X'replaced by the
# corresponding variable name. And similarly, if 'analyse' is
# selected, only 'df_XEx', 'df_Xtrend' and 'res_Xanalyse' are saved
# for each variable.
to_assign_out = c(
    # 'modified_data',
    # 'analyse'
)

### 6.3. Writing data on disc ________________________________________
# It is possible to save the data under txt files.
# Options are :
# - 'meta' : saves 'df_meta' the data frame of meta informations
# - 'modified_data' : saves modified 'data' data frame that take
#   corrections into account
# - 'analyse' : saves results of the trend analyse
saving = c(
    # 'meta',
    # 'modified_data',
    # 'analyse'
)

# If TRUE, data will be saved in 'fst' which is a fast format otherwise the default format is 'txt'
fast_format = TRUE

### 6.4. Writing figure ______________________________________________
# How the pdf will be constructed. If you choose 'by_code', a pdf will
# be save for each station. Otherwise, if you choose 'all', every
# figure will be saved as one pdf.
pdf_chunk =
    'by_code'
    # 'all'


## 7. PLOTTING PARAMETERS ____________________________________________
### 7.1. What do you want to plot ____________________________________
# What you want to be plotted for station analyses. For example if 'datasheet' is wrote, datasheet about each stations will be drawn.
# All the option are :
#    'datasheet' : datasheet of trend analyses for each stations
#        'table' : summarizing table about trend analyses
#          'map' : map about trend analyses
to_plot_station =
    c(
        # 'summary',
        'datasheet'
        # 'table'
        # 'map'
        # 'map_regime'
        # 'map_trend'
        # 'map_mean'
    )

### 7.2. What do you want to show ____________________________________
# Do you want to show small insert of color based on the studied
# event in the upper left corner of datasheet
show_colorEvent = TRUE

# Which part of the globe do you want to show in the datasheet
# mini map
zone_to_show =
    'France'
    # 'Adour-Garonne'

# If the hydrological network needs to be plot
river_selection =
    # 'none'
    c('La Seine$', "'Yonne$", 'La Marne$', 'La Meuse', 'La Moselle$', '^La Loire$', '^la Loire$', '^le cher$', '^La Creuse$', '^la Creuse$', '^La Vienne$', '^la Vienne$', 'La Garonne$', 'Le Tarn$', 'Le Rhône$', 'La Saône$')
    # 'all'

# Which logo do you want to show in the footnote
logo_to_show =
    c(
        'PR'='logo_Prefet_bassin.png',
        'FR'='Republique_Francaise_RVB.png',
        'INRAE'='Logo-INRAE_Transparent.png',
        'AEAG'='agence-de-leau-adour-garonne_logo.png'
    )


### 7.3. Other _______________________________________________________
# Tolerance of the simplification algorithm for shapefile in sf
toleranceRel =
    # 1000 # normal map
    10000 # mini map
    
# Graphical selection of period for a zoom
axis_xlim =
    NULL
# c('1982-01-01', '1983-01-01')

# Probability used to define the min and max quantile needed for
# colorbar extremes. For example, if set to 0.01, quartile 1 and
# quantile 99 will be used as the minimum and maximum values to assign
# to minmimal maximum colors.
exProb = 0.01


#  ___              ___             _   
# |   \  ___ __ __ | _ \ __ _  _ _ | |_ 
# | |) |/ -_)\ V / |  _// _` || '_||  _|
# |___/ \___| \_/  |_|  \__,_||_|   \__| _____________________________
## /!\ Do not touch if you are not aware ##

## 0. INITIALISATION _________________________________________________
# Computer
computer = Sys.info()["nodename"]
print(paste0("Computer ", computer))
computer_file_list = list.files(path=lib_path,
                                pattern="computer[_].*[.]R")
computer_list = gsub("(computer[_])|([.]R)", "", computer_file_list)
computer_file = computer_file_list[sapply(computer_list,
                                          grepl, computer)]
computer_path = file.path(lib_path, computer_file)
print(paste0("So reading file ", computer_path))
source(computer_path, encoding='UTF-8')

# Sets working directory
setwd(computer_work_path)

# Import EXstat
dev_path = file.path(dev_lib_path,
                     c('', 'EXstat_project'), 'EXstat', 'R')
if (any(file.exists(dev_path))) {
    print('Loading EXstat from local directory')
    list_path = list.files(dev_path, pattern='*.R$', full.names=TRUE)
    for (path in list_path) {
        source(path, encoding='UTF-8')    
    }
} else {
    print('Loading EXstat from package')
    library(EXstat)
}

# Import ASHE
dev_path = file.path(dev_lib_path,
                     c('', 'ASHE_project'), 'ASHE', 'R')
if (any(file.exists(dev_path))) {
    print('Loading ASHE from local directory')
    list_path = list.files(dev_path, pattern='*.R$', full.names=TRUE)
    for (path in list_path) {
        source(path, encoding='UTF-8')    
    }
} else {
    print('Loading ASHE from package')
    library(ASHE)
}


# Import dataSHEEP
dev_path = file.path(dev_lib_path,
                     c('', 'dataSHEEP_project'), 'dataSHEEP',
                     "R")
if (any(file.exists(dev_path))) {
    print('Loading dataSHEEP')
    list_path = list.files(dev_path, pattern='*.R$', full.names=TRUE,
                           recursive=TRUE)
    for (path in list_path) {
        source(path, encoding='UTF-8')    
    }
}

# Import SHEEPfold
dev_path = file.path(dev_lib_path,
                     c('', 'SHEEPfold_project'), 'SHEEPfold',
                     "__SHEEP__")
if (any(file.exists(dev_path))) {
    print('Loading SHEEPfold')
    list_path = list.files(dev_path, pattern='*.R$', full.names=TRUE,
                           recursive=TRUE)
    for (path in list_path) {
        source(path, encoding='UTF-8')    
    }
}

# Import other library
library(dplyr)
library(ggplot2)
library(scales)
library(qpdf)
library(gridExtra)
library(gridtext)
library(grid)
library(ggh4x)
library(RColorBrewer)
library(rgdal)
library(shadowtext)
library(png)
library(ggrepel)
library(latex2exp)
library(StatsAnalysisTrend)
library(officer)
library(sf)
library(stringr)
# already ::
# library(rgeos)
# library(lubridate)
# library(Hmisc)
# library(accelerometry)
# library(CircStats)
# library(tools)
# library(sp)
# potentialy useless
# library(trend)


tmppath = file.path(computer_work_path, tmpdir)

if ('delete_tmp' %in% to_do) {
    unlink(tmppath, recursive=TRUE)
}

# Creates list of period for trend analysis
period_trend = NULL
if (!is.null(periodAll)) {
    period_trend = append(period_trend, list(periodAll))
}
if (!is.null(periodSub)) {
    period_trend = append(period_trend, list(periodSub))
}
if (!is.null(period_trend)) {
    period_trend = lapply(period_trend, as.Date)
}
# Creates list of period for average analysis
period_change = NULL
if (!is.null(periodRef)) {
    period_change = append(period_change, list(periodRef))
}
if (!is.null(periodCur)) {
    period_change = append(period_change, list(periodCur))
}
if (!is.null(period_change)) {
    period_change = lapply(period_change, as.Date)
}

input_period_trend = sapply(period_trend, paste, collapse='/')


## 1. EXTRACTION _____________________________________________________
if ('create_data' %in% to_do) {
    print('EXTRACTION')
    source('script_create.R', encoding='UTF-8')
}

## 2. ANALYSES _______________________________________________________
if ('extract_data' %in% to_do) {
    print('EXTRACTION')
    source('script_extract.R', encoding='UTF-8')
}

## 3. PLOTTING _______________________________________________________
if ('serie_plot' %in% to_do | 'trend_plot' %in% to_do | 'break_plot' %in% to_do | 'climate_trend_plot' %in% to_do) {
    print('PLOTTING')
    source('script_layout.R', encoding='UTF-8')
}
