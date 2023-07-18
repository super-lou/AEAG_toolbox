# Copyright 2021-2023 Louis Héraut (louis.heraut@inrae.fr)*1,
#                     Éric Sauquet (eric.sauquet@inrae.fr)*1
#
# *1   INRAE, France
#
# This file is part of Explore2 R toolbox.
#
# Explore2 R toolbox is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Explore2 R toolbox is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Explore2 R toolbox.
# If not, see <https://www.gnu.org/licenses/>.


## 1. MANAGEMENT OF DATA ______________________________________________
if (!read_tmp & !delete_tmp) {

    if ('save_data' %in% to_do) {
        print("### Saving data")
        print(paste0("Save extracted data and metadata in ",
                    paste0(saving_format, collapse=", ")))

        today_resdir_tmp = today_resdir
        pattern = "data[_].*[.]fst"

        if (!(file.exists(today_resdir_tmp))) {
            dir.create(today_resdir_tmp, recursive=TRUE)
        }

        data_paths = list.files(tmppath,
                                pattern=pattern,
                                full.names=TRUE)
        data_files = gsub("[_][_]", "_", basename(data_paths))

        if ("data" %in% var2save) {
            file.copy(data_paths,
                      file.path(today_resdir_tmp, data_files))
        }
        
        for (i in 1:length(extract_data)) {
            extract = extract_data[[i]]

            dirname = paste0("dataEX_", data_dir_to_use, "_",
                             extract$name)
            filename = paste0(dirname, ".fst")
            if (file.exists(file.path(tmppath, dirname)) |
                file.exists(file.path(tmppath, filename))) {

                if ("meta" %in% var2save) {
                    meta = read_tibble(filedir=tmppath,
                                       filename=paste0(
                                           "meta_",
                                           data_dir_to_use,
                                           ".fst"))
                    
                }
                if ("metaEX" %in% var2save) {
                    metaEX = read_tibble(filedir=tmppath,
                                         filename=paste0(
                                             "metaEX_",
                                             data_dir_to_use, "_",
                                             extract$name,
                                             ".fst"))
                    
                }
                if ("dataEX" %in% var2save) {
                    dataEX = read_tibble(filedir=tmppath,
                                         filename=paste0(
                                             "dataEX_",
                                             data_dir_to_use, "_",
                                             extract$name,
                                             ".fst"))
                }
                if ("trendEX" %in% var2save) {
                    trendEX = read_tibble(filedir=tmppath,
                                          filename=paste0(
                                              "trendEX_",
                                              data_dir_to_use, "_",
                                              extract$name,
                                              ".fst"))
                }
            } else {
                next
            }

            for (format in saving_format) {

                if ("meta" %in% var2save) {
                    write_tibble(meta,
                                 filedir=today_resdir_tmp,
                                 filename=paste0("meta_",
                                                 data_dir_to_use,
                                                 ".", format))
                }

                if ("metaEX" %in% var2save) {
                    write_tibble(metaEX,
                                 filedir=today_resdir_tmp,
                                 filename=paste0("metaEX_",
                                                 data_dir_to_use, "_",
                                                 extract$name,
                                                 ".", format))
                }

                if ("dataEX" %in% var2save) {
                    write_tibble(dataEX,
                                 filedir=today_resdir_tmp,
                                 filename=paste0("dataEX_",
                                                 data_dir_to_use, "_",
                                                 extract$name,
                                                 ".", format))
                }

                if ("trendEX" %in% var2save) {
                    write_tibble(trendEX,
                                 filedir=today_resdir_tmp,
                                 filename=paste0("trendEX_",
                                                 data_dir_to_use, "_",
                                                 extract$name,
                                                 ".", format))
                }
            }
            if (exists("meta")) {
                rm ("meta")
                gc()
            }
            if (exists("metaEX")) {
                rm ("metaEX")
                gc()
            }
            if (exists("dataEX")) {
                rm ("dataEX")
                gc()
            }
            if (exists("trendEX")) {
                rm ("trendEX")
                gc()
            }
        }
    }

    if ('read_saving' %in% to_do) {
        print("### Reading saving")
        print(paste0("Reading extracted data and metadata in ",
                    read_saving))

        read_saving_tmp = file.path(read_saving)
        
        for (i in 1:length(extract_data)) {
            extract = extract_data[[i]]

            Paths = list.files(file.path(resdir,
                                         read_saving_tmp),
                               include.dirs=TRUE,
                               full.names=TRUE)

            pattern = var2search
            pattern = paste0("(", paste0(pattern,
                                         collapse=")|("), ")")

            if (extract$simplify) {
                pattern = gsub("dataEX",
                               paste0("dataEX[_]",
                                      gsub("[_]", "[_]",
                                           data_dir_to_use),
                                      "[_]",
                                      gsub("[_]", "[_]",
                                           extract$name),
                                      "[.]"),
                               pattern)
            } else {
                pattern = gsub("dataEX",
                               paste0("dataEX[_]",
                                      gsub("[_]", "[_]",
                                           data_dir_to_use),
                                      "[_]",
                                      gsub("[_]", "[_]",
                                           extract$name),
                                      "$"),
                               pattern)
            }
            pattern = gsub("metaEX",
                           paste0("metaEX[_]",
                                  gsub("[_]", "[_]",
                                       data_dir_to_use),
                                  "[_]",
                                  gsub("[_]", "[_]",
                                       extract$name),
                                  "[.]"),
                           pattern)
            
            pattern = gsub("trendEX", paste0("trendEX[_]",
                                             gsub("[_]", "[_]",
                                                  data_dir_to_use),
                                             "[_]",
                                             gsub("[_]", "[_]",
                                                  extract$name),
                                             "[.]"),
                           pattern)
            
            Paths = Paths[grepl(pattern, Paths)]
            Paths = Paths[grepl("[.]fst", Paths) | !grepl("?[.]", Paths)]
            Paths[!grepl("[.]", Paths)] =
                paste0(Paths[!grepl("[.]", Paths)], ".fst")
            Filenames = gsub("^.*[/]+", "", Paths)
            Filenames = gsub("[.].*$", "", Filenames)
            nFile = length(Filenames)
            for (i in 1:nFile) {
                print(paste0(Filenames[i], " reads in ", Paths[i]))
                assign(Filenames[i],
                       read_tibble(filepath=Paths[i]))
            }
        }
    }

    
} else {
    if (read_tmp) {
        print("### Reading tmp")
        print(paste0("Reading tmp data in ", tmppath))
        Paths = list.files(tmppath,
                           pattern=paste0("(",
                                          paste0(var2search,
                                                 collapse=")|("),
                                          ")"),
                           include.dirs=TRUE,
                           full.names=TRUE)
        Paths = Paths[grepl("[.]fst", Paths) | !grepl("?[.]", Paths)]
        Paths[!grepl("[.]", Paths)] =
            paste0(Paths[!grepl("[.]", Paths)], ".fst")
        Filenames = gsub("^.*[/]+", "", Paths)
        Filenames = gsub("[.].*$", "", Filenames)
        nFile = length(Filenames)
        for (i in 1:nFile) {
            print(paste0(Filenames[i], " reads in ", Paths[i]))
            assign(Filenames[i], read_tibble(filepath=Paths[i]))
        }
        read_tmp = FALSE
    }

    if (delete_tmp) {
        print("### Deleting tmp")
        if (file.exists(tmppath)) {
            unlink(tmppath, recursive=TRUE)
        }
        delete_tmp = FALSE
    }
}
