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


# Script that manages the call to the right process in order to
# realise analyses.


## 1. STATION TREND ANALYSIS _________________________________________
if ('trend_analyse' %in% to_do) {

    script_to_analyse_dirpath = file.path(CARD_dir, var_to_analyse_dir)
    
    script_to_analyse = list.files(script_to_analyse_dirpath,
                                   pattern=".R$",
                                   recursive=TRUE,
                                   include.dirs=FALSE,
                                   full.names=FALSE)

    script_to_analyse = script_to_analyse[!grepl("default.R",
                                                 script_to_analyse)]

    event_to_analyse = list.dirs(script_to_analyse_dirpath,
                                 recursive=TRUE, full.names=FALSE)
    event_to_analyse = event_to_analyse[event_to_analyse != ""]
    event_to_analyse = gsub('.*_', '', event_to_analyse)

    structure = replicate(length(event_to_analyse), c())
    names(structure) = event_to_analyse
    
    var_analysed = c()
    PLOT = list()
    
    ### 1.3. Trend analyses ______________________________________________
    for (script in script_to_analyse) {

        print(script)

        list_path = list.files(file.path(CARD_dir,
                                         init_tools_dir),
                               pattern='*.R$',
                               full.names=TRUE)
        for (path in list_path) {
            source(path, encoding='UTF-8')    
        }

        Process_default = sourceProcess(
            file.path(CARD_dir,init_var_file))
        
        Process = sourceProcess(
            file.path(script_to_analyse_dirpath, script),
            default=Process_default)

        principal = Process$P
        principal_names = names(principal)
        for (i in 1:length(principal)) {
            assign(principal_names[i], principal[[i]])
        }

        split_script = split_path(script)
        
        if (length(split_script) == 1) {
            if (!('None' %in% names(structure))) {
                structure = append(list(None=c()), structure)
            }
            structure[['None']] = c(structure[['None']], var)
        } else if (length(split_script) == 2) {
            dir = split_script[2]
            dir = gsub('.*_', '', dir)
            structure[[dir]] = c(structure[[dir]], var)
        }
        
        
        if (samplePeriod_mode == 'optimale') {
            if (identical(samplePeriod_opti[[event]], "min")) {
                minQM = paste0(formatC(df_meta$minQM,
                                       width=2,
                                       flag="0"),
                               '-01')
                samplePeriodMod = tibble(Code=df_meta$Code,
                                         sp=minQM)
            } else if (identical(samplePeriod_opti[[event]], "max")) {
                maxQM = paste0(formatC(df_meta$maxQM,
                                       width=2,
                                       flag="0"),
                               '-01')
                samplePeriodMod = tibble(Code=df_meta$Code,
                                         sp=maxQM)
            } else {
                samplePeriodMod = samplePeriod_opti[[event]]
            }
            
        } else {
            samplePeriodMod = NULL
        }

        if (!is.null(samplePeriodMod)) {
            nProcess = length(Process)
            for (i in 1:nProcess) {
                if (!is.null(Process[[i]]$samplePeriod)) {
                    Process[[i]]$samplePeriod = samplePeriodMod
                    samplePeriod = Process[[i]]$samplePeriod
                }
            }
        }

        # monthSamplePeriod = substr(samplePeriod[1], 1, 2)

        if (var %in% var_analysed) {
            next
        }

        res = get_trend(data=data,
                        period=trend_period,
                        level=level,
                        flag=flag,
                        Process)

        XdataMod = res$data
        Xmod = res$mod
        # Gets the extracted data for the variable
        dataEx = res$dataEx
        # Gets the trend results for the variable
        trend = res$trend

        if ('dataMod' %in% to_assign_out) {
            assign(paste0(var, 'dataMod'), XdataMod)
            assign(paste0(var, 'mod'), Xmod)
        }
        if ('dataEx' %in% to_assign_out) {
            assign(paste0(var, 'dataEx'), dataEx)
        }
        if ('trend' %in% to_assign_out) {
            assign(paste0(var, 'trend'), trend)
        }

        var_analysed = c(var_analysed, var)
        if ('trend_plot' %in% to_do | TRUE) {
            
            Plot = list(var=var,
                        unit=unit,
                        glose=glose,
                        event=event,
                        samplePeriod=samplePeriod,
                        dataEx=dataEx,
                        trend=trend)

            PLOT = append(PLOT, list(Plot))
        }

        

        ### 1.3. Saving ______________________________________________________
        # if ('modified_data' %in% saving & !read_results) {
        #     # Writes modified data
        #     write_data(df_Xdata, df_Xmod, resdir,
        #                filedir=file.path(modified_data_dir,
        #                                  var, monthSamplePeriod))
        
        #     if (fast_format) {
        #         write_dataFST(df_Xdata, resdir,
        #                       filedir='fst',
        #                       filename=paste0('data_', var,
        #                                       '_', monthSamplePeriod,
        #                                       '.fst'))
        #     }
        # }

        # if ('analyse' %in% saving) {                
        #     # Writes trend analysis results
        #     write_analyse(res_Xanalyse, resdir,
        #                   filedir=file.path(trend_dir,
        #                                     var, monthSamplePeriod))
        
        #     if (fast_format) {
        #         write_dataFST(dataEx,
        #                       resdir,
        #                       filedir='fst',
        #                       filename=paste0(var, 'Ex_',
        #                                       monthSamplePeriod,
        #                                       '.fst'))
        #     }
        # }
    }
}

if ('meta' %in% saving) {
    if (fast_format) {
        write_metaFST(df_meta, resdir,
                      filedir=file.path('fst'))
    }
}


## 2. STATION BREAK ANALYSIS _________________________________________
if ('break_analyse' %in% to_do) {
    DF_BREAK = list()
    # For all the variable
    for (v in var) {
        # Gets the trend results for the variable
        res_trend = get(paste('res_', v, 'trend', sep=''))
        # Performs the break analyses for some hydrological variables
        df_break = get_break(res_trend$data, df_meta, level=0.1)
        DF_BREAK = append(DF_BREAK, list(df_break))
    }
    names(DF_BREAK) = var
}


## 3. CLIMATE TREND ANALYSIS _________________________________________
if ('climate_trend_analyse' %in% to_do) {
    ### 3.1. Info about analysis _________________________________________
    var_all_climate = list(
        'PA',
        'TA',
        'ETPA'
    )
    glose_all_climate = list(
        '',
        '',
        ''
    )

    ### 3.2. Selection of variables ______________________________________
    var_climate = c()
    glose_climate = c()
    for (OkVar in to_analyse_climate) {
        Ok = var_all_climate == OkVar
        var_climate = c(var_climate, var_all_climate[Ok])
        glose_climate = c(glose_climate, glose_all_climate[Ok])
    } 
    
    ### 3.3. Formatting of climate dataframe _____________________________
    # For precipitation
    data_P = bind_cols(Date=df_climate_data$Date,
                       Q=df_climate_data$PRCP_mm,
                       code=df_climate_data$Code)
    # For temperature
    data_T = bind_cols(Date=df_climate_data$Date,
                       Q=df_climate_data$T_degC,
                       code=df_climate_data$Code)
    # For evapotranspiration
    data_ETP = bind_cols(Date=df_climate_data$Date,
                         Q=df_climate_data$PET_mm,
                         code=df_climate_data$Code)
    ### 3.4. Trend analyses ______________________________________________
    # TA trend
    res = get_trend(data_P, df_climate_meta,
                     period=trend_period,
                     hydroYear='09-01',
                     level=level,
                     dayLac_lim=dayLac_lim,
                     yearNA_lim=yearNA_lim,
                     flag=flag,
                     funct=sum)
    df_PAdata = res$data
    df_PAmod = res$mod
    res_PAtrend = res$analyse
    
    # PA trend
    res = get_trend(data_T, df_climate_meta,
                     period=trend_period,
                     hydroYear='09-01',
                     level=level,
                     dayLac_lim=dayLac_lim,
                     yearNA_lim=yearNA_lim,
                     flag=flag,
                     funct=mean,
                     na.rm=TRUE)
    df_TAdata = res$data
    df_TAmod = res$mod
    res_TAtrend = res$analyse

    # ETPA trend
    res = get_trend(data_ETP, df_climate_meta,
                      period=trend_period,
                      hydroYear='09-01',
                      level=level,
                      dayLac_lim=dayLac_lim,
                      yearNA_lim=yearNA_lim,
                      flag=flag,
                      funct=sum)
    df_ETPAdata = res$data
    df_ETPAmod = res$mod
    res_ETPAtrend = res$analyse
}
