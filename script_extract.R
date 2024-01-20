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


if ('extract_data' %in% to_do) {
    
    data = read_tibble(filedir=tmppath,
                       filename=paste0("data_",
                                       data_dir_to_use, ".fst"))
    
    meta = read_tibble(filedir=tmppath,
                       filename=paste0("meta_",
                                       data_dir_to_use, ".fst"))
    
    for (i in 1:length(extract_data)) {
        
        extract = extract_data[[i]]

        CARD_management(CARD=CARD_path,
                        tmp=tmppath,
                        layout=c(extract$name, "[",
                                 extract$variables, "]"),
                        overwrite=TRUE)

        res = CARD_extraction(data,
                              CARD_path=CARD_path,
                              CARD_dir=extract$name,
                              CARD_tmp=tmppath,
                              period=periodAll,
                              simplify=extract$simplify,
                              suffix=extract$suffix,
                              expand_overwrite=extract$expand,
                              cancel_lim=extract$cancel_lim,
                              verbose=TRUE)

        dataEX = res$dataEX
        metaEX = res$metaEX

        trendEX = dplyr::tibble()
        
        for (i in 1:length(dataEX)) {
            trendEX_var = process_trend(
                dataEX[[i]],
                metaEX=metaEX,
                MK_level=level,
                take_not_signif_into_account=TRUE,
                period_trend=period_trend,
                period_change=period_change,
                exProb=exProb,
                verbose=TRUE)

            if (nrow(trendEX) == 0) {
                trendEX = trendEX_var
            } else {
                trendEX = dplyr::bind_rows(trendEX,
                                           trendEX_var)
            }
        }

        # if (simplify)
        # dataEX = purrr::reduce(dataEX, dplyr::full_join,
                               # by=c("Code", "Date"))
        
        write_tibble(dataEX,
                     filedir=tmppath,
                     filename=paste0("dataEX_",
                                     data_dir_to_use, "_",
                                     extract$name,
                                     ".fst"))
        write_tibble(metaEX,
                     filedir=tmppath,
                     filename=paste0("metaEX_",
                                     data_dir_to_use, "_",
                                     extract$name,
                                     ".fst"))

        if (!is.null(period_trend)) {
            trendEX$period = sapply(trendEX$period, paste0, collapse=" ")
        }
        if (!is.null(period_change)) {
            trendEX$period_change = sapply(trendEX$period_change,
                                           paste0, collapse=" ")
        }
        
        write_tibble(trendEX,
                     filedir=tmppath,
                     filename=paste0("trendEX_",
                                     data_dir_to_use, "_",
                                     extract$name,
                                     ".fst"))
    }
}
