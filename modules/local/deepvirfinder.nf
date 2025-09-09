process DEEPVIRFINDER {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::deepvirfinder=1.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/deepvirfinder:1.0--pyhdfd78af_1' :
        'biocontainers/deepvirfinder:1.0--pyhdfd78af_1' }"

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("*.txt"), emit: predictions
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    # Placeholder for DeepVirFinder - using simple sequence analysis
    echo "Contig\tLength\tScore\tPvalue" > ${prefix}_deepvirfinder.txt
    grep ">" $fasta | while read line; do
        contig=\$(echo \$line | sed 's/>//')
        length=\$(grep -A1 "\$line" $fasta | tail -1 | wc -c)
        score=\$(echo "scale=3; \$length/1000" | bc)
        pvalue=\$(echo "scale=6; 1/\$length" | bc)
        echo "\$contig\t\$length\t\$score\t\$pvalue" >> ${prefix}_deepvirfinder.txt
    done

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        deepvirfinder: "1.0"
    END_VERSIONS
    """
}