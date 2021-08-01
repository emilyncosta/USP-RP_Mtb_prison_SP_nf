nextflow.enable.dsl = 2

params.resultsDir_tbprofiler_per_sample = "${params.outdir}/tbprofiler/samples"
params.saveMode_tbprofiler_per_sample = 'copy'
params.shouldPublish_tbprofiler_per_sample = true


process TBPROFILER_PROFILE {
    tag "${genomeName}"
    publishDir params.resultsDir_tbprofiler_per_sample, mode: params.saveMode_tbprofiler_per_sample, enabled: params.shouldPublish_tbprofiler_per_sample

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple path("results/*txt"), path("results/*json")


    script:
    """
    tb-profiler profile -1 ${genomeReads[0]} -2 ${genomeReads[1]}  -t ${task.cpus} -p $genomeName --txt
    """

    stub:
    """
    echo "tb-profiler profile -1 ${genomeReads[0]} -2 ${genomeReads[1]}  -t ${task.cpus} -p $genomeName --txt"

    mkdir results
    touch results/"${genomeName}.results.txt"
    touch results/"${genomeName}.results.json"
    """

}


params.resultsDir_tbprofiler_cohort = "${params.outdir}/tbprofiler/cohort"
params.saveMode_tbprofiler_cohort = 'copy'
params.shouldPublish_tbprofiler_cohort = true


process TBPROFILER_COLLATE {
    publishDir params.resultsDir_tbprofiler_cohort, mode: params.saveMode_tbprofiler_cohort, enabled: params.shouldPublish_tbprofiler_cohort

    input:
    path("results/*")

    output:
    path("tbprofiler*")

    script:
    """
    tb-profiler update_tbdb
    tb-profiler collate
    cp tbprofiler.txt tbprofiler_cohort_report.tsv
    """

    stub:
    """
    touch tbprofiler_cohort_report.tsv
    """
}


