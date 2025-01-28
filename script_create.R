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
# realise extraction of data.


if ('create_data' %in% to_do) {

    if (mode == "hydrologie") {
        meta = create_meta_HYDRO(computer_data_path,
                                 data_dir_to_use,
                                 CodeALL_filename,
                                 verbose=TRUE)
        
        data = create_data_HYDRO(computer_data_path,
                                 data_dir_to_use,
                                 CodeALL_filename,
                                 variable_to_load="Qm3s", 
                                 verbose=TRUE)
        
    } else if (mode == "climat") {
        res = create_climate_data(computer_data_path,
                                  filedir,
                                  colNames=c('Date', 'P',
                                             'ETP', 'T'))
        data = res$data
        meta = res$meta
    }

    write_tibble(data,
                 filedir=tmppath,
                 filename=paste0("data_",
                                 data_dir_to_use, ".fst"))
    write_tibble(meta,
                 filedir=tmppath,
                 filename=paste0("meta_",
                                 data_dir_to_use, ".fst"))
}
