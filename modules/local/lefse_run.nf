process LEFSE_RUN {
    label 'process_low'

    conda (params.enable_conda ? { exit 1 "LEFSE has no conda package" } : null)
    container "quay.io/biocontainers/lefse:1.1.2--pyhdfd78af_0"

    input:
    path(tsv)

    output:
    path("*.pdf")  , emit: pdf
    path("*.png")  , emit: png
    path("*.svg")  , emit: svg

    script:
    """
    lefse_format_input.py ${tsv} lefse_ready_table.in -c 1 -u 2 -o 1000000

    lefse_run.py lefse_ready_table.in lefse_ready_table.res

    array=("png" "svg" "pdf")

    for i in \${array[@]}

    do

    lefse_plot_res.py lefse_ready_table.res lefse_res_bar.\$i --format \$i --dpi 300

    lefse_plot_cladogram.py lefse_ready_table.res lefse_res_clado.\$i --format \$i --dpi 300

    done

    """
}
