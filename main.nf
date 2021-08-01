nextflow.enable.dsl = 2

include { TBPROFILER_PROFILE; TBPROFILER_COLLATE } from "./modules/tbprofiler/tbprofiler.nf"


workflow {
    reads_ch = Channel.fromFilePairs(params.reads)

    TBPROFILER_PROFILE(reads_ch)
    TBPROFILER_COLLATE(TBPROFILER_PROFILE.out.collect())


}

