process PMULTIQC {
    tag "$meta.id"
    label 'process_high'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pmultiqc:0.0.39--pyhdfd78af_0' :
        'biocontainers/pmultiqc:0.0.39--pyhdfd78af_0' }"

    input:
    val meta
    path results

    output:
    tuple val(meta), path("*.html"), emit: report
    path "*.db", optional: true, emit: quantmsdb
    path "versions.yml", emit: versions
    path "*_data", emit: data

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    echo "=== DEBUG: Files in work directory ==="
    ls -lah
    echo ""
    echo "=== DEBUG: idXML files ==="
    find . -name "*.idXML" -type f | head -5
    echo ""
    echo "=== DEBUG: parquet files ==="
    find . -name "*.parquet" -type f | head -5
    echo ""
    echo "=== DEBUG: mzTab files ==="
    find . -name "*.mzTab" -type f | head -5
    echo ""
    echo "=== DEBUG: Running MultiQC ==="
    
    multiqc \\
        --force \\
        --filename ${prefix}_multiqc_report \\
        ${args} \\
        .

    cat <<END_VERSIONS > versions.yml
"PMULTIQC":
    pmultiqc: \$(multiqc --pmultiqc_version 2>&1 | sed -e "s/pmultiqc, version //g" | tr -d '\\n' || echo "0.0.39")
END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    touch '${prefix}_multiqc_report.html'
    mkdir '${prefix}_multiqc_report_data'

    cat <<END_VERSIONS > versions.yml
"PMULTIQC":
    pmultiqc: \$(multiqc --pmultiqc_version 2>&1 | sed -e "s/pmultiqc, version //g" | tr -d '\\n' || echo "0.0.39")
END_VERSIONS
    """
}
