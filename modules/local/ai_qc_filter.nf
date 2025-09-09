process AI_QC_FILTER {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::seqtk=1.4 bioconda::python=3.9"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqtk:1.4--he4a0461_2' :
        'biocontainers/seqtk:1.4--he4a0461_2' }"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*_filtered.fastq.gz"), emit: filtered_reads
    tuple val(meta), path("*_qc_stats.txt")     , emit: stats
    path "versions.yml"                         , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def min_length = task.ext.min_length ?: 200
    def min_qual = task.ext.min_qual ?: 10
    """
    # Count original reads
    ORIG_READS=\$(zcat $reads | wc -l | awk '{print \$1/4}')
    
    # Filter reads by length and quality (AI-based filtering placeholder)
    seqtk seq -L $min_length -q $min_qual $reads | gzip > ${prefix}_filtered.fastq.gz
    
    # Count filtered reads
    FILT_READS=\$(zcat ${prefix}_filtered.fastq.gz | wc -l | awk '{print \$1/4}')
    
    # Generate stats
    echo "Sample: ${prefix}" > ${prefix}_qc_stats.txt
    echo "Original reads: \$ORIG_READS" >> ${prefix}_qc_stats.txt
    echo "Filtered reads: \$FILT_READS" >> ${prefix}_qc_stats.txt
    echo "Reads retained: \$(echo "scale=2; \$FILT_READS/\$ORIG_READS*100" | bc)%" >> ${prefix}_qc_stats.txt
    echo "Min length filter: $min_length bp" >> ${prefix}_qc_stats.txt
    echo "Min quality filter: Q$min_qual" >> ${prefix}_qc_stats.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqtk: \$(seqtk 2>&1 | grep Version | cut -d' ' -f2)
    END_VERSIONS
    """
}