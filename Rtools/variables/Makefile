# build directory of ASHES R variables

source_dir='stationarity_analysis'
AEAG='QA QMNA VCN10 tDEB_etiage tCEN_etiage'

AEAG:
	@R -e \
	"\
	dir = 'AEAG';\
	if (!(file.exists(dir))) {;\
	dir.create(dir);\
	};\
	IN = ${AEAG};\
	IN = unlist(strsplit(IN, split=' '));\
	IN = paste0(IN, '.R');\
	n = length(IN);\
	OUT = paste0(1:n, '_', IN);\
	for (i in 1:n) {;\
	file.copy(file.path(${source_dir}, IN[i]), file.path(dir, OUT[i]));\
	};\
	"

.PHONY: AEAG
