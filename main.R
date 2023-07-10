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
# AEAG_toolbox path
lib_path =
    "./"

## 2. GENERAL PROCESSES ______________________________________________
# This to_do vector regroups all the different step you want to do.
# For example if you write 'create_data', a tibble of hydrological
# data will be created according to the info you provide in the ## 1.
# CREATE_DATA section of the STEPS part below. If you also add
# 'extract_data' in the vector, the extract will also be perfom
# following the creation of data. But if you only write, for example,
# 'plot_sheet', without having previously execute the code to have
# loading data to plot, it will results in a failure.
#
# Options are listed below with associated results after '>' :
#
# - 'delete_tmp' :
#     Delete temporary data in the tmpdir/.
#     > Permanently erase temporary data.
#
# - 'create_data' :
#     Creation of tibble of data that will be saved in tmpdir/. The
#     data will be saved in fst format which is a fast reading and
#     writting format. Each data tibble go with its meta tibble that
#     regroup info about the data. Those files are named with a '_'
#     followed by a capital letter that correspond to the first letter
#     of the hydrological station codes that are stored in it. A file
#     contain nCode4RAM stations, so each nCode4RAM stations a
#     different file is created with a digit in its name to specify
#     it. The selection of station code is done in the
#     codes_to_use variable of the ## 1. CREATE_DATA section of the
#     STEPS part below and the model used are selected in the
#     variable models_to_diag of that same previous section.
#     > tmpdir/data_K1.fst :
#        A fst file that contain the tibble of created data.
#     > tmpdir/meta_K1.fst :
#        An other fst file that contain info about the data file.
#
# - 'extract_data' :
#     Perfom the requested analysis on the created data contained in
#     the tmpdir/. Details about the analysis are given with the
#     extract_data variable in the ## 2. EXTRACT_DATA section of the
#     STEPS part below. This variable needs to be a path to a CARD
#     directory. See CARD toolbox for more info
#     https://github.com/super-lou/CARD.
#     > tmpdir/dataEXind_K1.fst : 
#        If the CARD directory contains 'indicator' this fst file
#        will be created.
#     > tmpdir/metaEXind_K1.fst :
#        Info about variables stored in dataEXind_K1.fst.
#     > tmpdir/dataEXserie_K1/ : 
#        If the CARD directory contains 'serie' this directory that
#        contains a fst file for each serie variable extracted
#        will be created.
#     > tmpdir/metaEXserie_K1.fst :
#        Info about variables stored in dataEXserie_K1.
#
# - 'save_extract' :
#     Saves all the data contained in the tmpdir/ to the resdir/. The
#     format used is specified in the saving_format variable of the 
#     ## 3. SAVE_EXTRACT section of the STEPS part.
#     > Moves all temporary data in tmpdir/ to the resdir/.
#
# - 'read_tmp' :
#     Loads in RAM all the data stored in fst files in the tmpdir/.
#     > For example, if there is a tmpdir/metaEXind_K1.fst file, a
#       data called metaEXind_K1 will be created in the current R
#       process that contained the data stored in the previous files.
#
# - 'read_saving' :
#     Loads in RAM all the data stored in the resdir/ which names are
#     based on var2search.
#     > Same as 'read_tmp' results but again from resdir/.
#
# - 'plot_sheet' :
#     Plots a set of datasheets specify by the plot_sheet variable
#     below. Different plotting options are mentioned in the ## 6.
#     PLOT_SHEET section of the STEPS part.
#     > Creates a pdf file in the figdir/ directory.
#
# - 'plot_doc' :
#     Plots a pre-define set of datasheets in document format specify
#     by the plot_doc variable below and the corresponding variables
#     define in ## 7. PLOT_DOC.
#     > Creates set of pdf files and a pdf document that regroup all
#       those individual file in a specific directory of the figdir/
#       directory.

mode =
    "hydrologie"
    # "climat"

to_do =
    c(
        # 'delete_tmp',
        'create_data',
        'extract_data',
        'save_data'
        # 'read_tmp'
        # 'read_saving'
        
        # 'trend_plot'
        # 'climate_trend_plot'
    )

extract_data =
    c(
        # 'WIP'
        # 'AEAG_climat'
        'AEAG_hydrologie'
    )


## 3. PLOTTING PROCESSES _____________________________________________
### 3.1. Sheet _______________________________________________________
# The use of this plot_sheet vector is quite similar to the to_do
# vector. It regroups all the different datasheet you want to plot
# individually. For example if you write 'diagnostic_station', the
# data previously extractd saved and read will be use to plot the
# diagnostic datasheet for specific stations.  

plot_sheet =
    c(
        #
    )

### 3.2. Document ____________________________________________________
plot_doc =
    c(
        #
    )


## 4. OTHER __________________________________________________________
# Display information along process
verbose =
    # FALSE
    TRUE


#  ___  _                  
# / __|| |_  ___  _ __  ___
# \__ \|  _|/ -_)| '_ \(_-<
# |___/ \__|\___|| .__//__/ __________________________________________
## 1. CREATE_DATA|_| _________________________________________________ 
data_dir_to_use =
    # ''
    # 'AEAG_selection'
    'RRSE'
    # "climat"

codes_to_use =
    c(
        # "all"
        'X0500010'
        # '^A'
    )

# Periods of time to perform the trend analyses. More precisely :
# - 'periodAll' tends to represent the maximal accessible period of
#    flow data hence the start in 1800
# - 'periodSub' tends to represent the period with the most accessible
#    flow data
periodAll =
    # c('1968-01-01', '2020-12-31')
    c(NA, '2020-12-31')
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


# # Local corrections of the data
# flag = data.frame(
#     Code=c('O3141010',
#            'O7635010',
#            'O7635010',
#            'O7635010',
#            'O7635010'
#            ),
#     Date=c('1974-07-04',
#            '1948-09-06',
#            '1949-02-08',
#            '1950-07-20',
#            '1953-07-22'
#            ),
#     newQ=c(9.5,
#                4,
#                3,
#                1,
#                3) # /!\ Unit
# )


## 2. EXTRACT_DATA ___________________________________________________
# Name of the subdirectory in 'CARD_dir' that includes variables to
# extract. If no subdirectory is selected, all variable files will be
# used in 'CARD_dir' (which is may be too much).
# This subdirectory can follows some rules :
# - Variable files can be rename to began with a number followed by an
#   underscore '_' to create an order in variables. For example,
#   '2_QA.R' will be extractd and plotted after '1_QMNA.R'.
# - Directory of variable files can also be created in order to make a
#   group of variable of similar topic. Names should be chosen between
#   'Crue'/'Crue Nivale'/'Moyennes Eaux' and 'Étiage'. A directory can
#   also be named 'Resume' in order to not include variables in an
#   topic group.

AEAG_hydrologie = 
    list(name='AEAG_hydrologie',
         variables=c("QMNA", "VCN10"),
         suffix=NULL,
         expand=FALSE,
         cancel_lim=FALSE,
         simplify=FALSE)

AEAG_climat = 
    list(name='AEAG_climat',
         variables=c("PA", "TA", "ETPA"),
         suffix=NULL,
         expand=FALSE,
         cancel_lim=FALSE,
         simplify=FALSE)

# The risk of the Mann-Kendall trend detection test
level = 0.1


## 3. SAVE_EXTRACT ___________________________________________________
var2save =
    c(
        'meta',
        'data',
        'dataEX',
        'metaEX',
        'trendEX'
    )

# Saving format to use to save extract data
saving_format =
    "fst"
    # c('Rdata', 'txt')


## 4. READ_SAVING ____________________________________________________
read_saving =
    # "results/my_dir"
    today

var2search =
    c(
        'meta[.]',
        'data[_]',
        'dataEX',
        'metaEX',
        'trendEX'
    )


## 5. PLOT_SHEET _____________________________________________________
# If the hydrological network needs to be plot
river_selection =
    NULL
    # c('La Seine$', "'Yonne$", 'La Marne$', 'La Meuse', 'La Moselle$',
    #   '^La Loire$', '^la Loire$', '^le cher$', '^La Creuse$',
    #   '^la Creuse$', '^La Vienne$', '^la Vienne$', 'La Garonne$',
    #   'Le Tarn$', 'Le Rhône$', 'La Saône$')

river_length =
    # NULL
    300000
    
# Tolerance of the simplification algorithm for shapefile in sf
toleranceRel =
    1000 # normal map
    # 9000 # mini map

# Which logo do you want to show in the footnote
logo_to_show =
    c(
        'PR'='logo_Prefet_bassin.png',
        'FR'='Republique_Francaise_RVB.png',
        'INRAE'='Logo-INRAE_Transparent.png',
        'AEAG'='agence-de-leau-adour-garonne_logo.png'
    )

# Probability used to define the min and max quantile needed for
# colorbar extremes. For example, if set to 0.01, quartile 1 and
# quantile 99 will be used as the minimum and maximum values to assign
# to minmimal maximum colors.
exXprob = 0.01

# Graphical selection of period for a zoom
axis_xlim =
    NULL
# c('1982-01-01', '1983-01-01')



#  ___        _  _    _        _  _            _    _            
# |_ _| _ _  (_)| |_ (_) __ _ | |(_) ___ __ _ | |_ (_) ___  _ _  
#  | | | ' \ | ||  _|| |/ _` || || |(_-</ _` ||  _|| |/ _ \| ' \ 
# |___||_||_||_| \__||_|\__,_||_||_|/__/\__,_| \__||_|\___/|_||_| ____
##### /!\ Do not touch if you are not aware #####
## 0. LIBRARIES ______________________________________________________
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

library(dplyr)
library(stringr)

if (any(grepl("plot", to_do))) {
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
    library(sf)
}

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


if (all(codes_to_use == "all")) {
    CodeALL_filename = list.files(file.path(computer_data_path,
                                            filedir),
                                  pattern=paste0(obs_hydro_format, "$"))
    CodeALL = gsub(obs_hydro_format, "", CodeALL_filename, fixed=TRUE)
} else {
    CodeALL = convert_regexp(computer_data_path,
                             filedir,
                             codes_to_use,
                             obs_hydro_format)
    CodeALL_filename = paste0(CodeALL, obs_hydro_format)
}


delete_tmp = FALSE
read_tmp = FALSE

extract_data_tmp = lapply(extract_data, get)
names(extract_data_tmp) = extract_data
extract_data = extract_data_tmp

tmppath = file.path(computer_work_path, tmpdir)

if ("delete_tmp" %in% to_do) {
    delete_tmp = TRUE
    to_do = to_do[to_do != "delete_tmp"]
    print("## MANAGING DATA")
    source(file.path(lib_path, 'script_management.R'),
           encoding='UTF-8')
}

if (!(file.exists(tmppath))) {
    dir.create(tmppath, recursive=TRUE)
}


## 1. EXTRACTION _____________________________________________________
if ('create_data' %in% to_do) {
    print('CREATING DATA')
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

if (any(c('save_data') %in% to_do)) {
    print("## MANAGING DATA")
    source(file.path(lib_path, 'script_management.R'),
           encoding='UTF-8')
}

if (any(c('read_saving') %in% to_do)) {
    print("## MANAGING DATA")
    source(file.path(lib_path, 'script_management.R'),
           encoding='UTF-8')
}

if ("read_tmp" %in% to_do) {
    read_tmp = TRUE
    to_do = to_do[to_do != "read_tmp"]
    print("## MANAGING DATA")
    source(file.path(lib_path, 'script_management.R'),
           encoding='UTF-8')
}
